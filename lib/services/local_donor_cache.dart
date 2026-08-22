import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/blood_request.dart';
import '../models/user_profile.dart';

/// On-device cache that makes offline alerts possible.
///
/// Whenever the app is online, it periodically syncs down a snapshot of
/// donors in the user's own city (see `SyncService`, not shown here) into
/// this local SQLite database. When the user has no internet and taps
/// "Need Blood", `AlertDispatchService` reads matching donors straight
/// from this cache instead of Firestore, and sends SMS directly.
///
/// Any request sent while offline is also queued here, and flushed to
/// Firestore automatically once connectivity returns (see
/// `ConnectivityWatcher`), so the request still shows up in-app for chat,
/// live status, and history once the network is back.
class LocalDonorCache {
  static Database? _db;

  Future<Database> _database() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'needblood_cache.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE donors (
            id TEXT PRIMARY KEY,
            fullName TEXT, age INTEGER, gender TEXT, bloodGroup TEXT,
            willingToDonate INTEGER, mobileNumber TEXT, email TEXT,
            province TEXT, city TEXT, area TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE pending_requests (
            id TEXT PRIMARY KEY,
            payloadJson TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  /// Replaces the cached donor snapshot for [city]. Called by the sync
  /// service whenever the app is online.
  Future<void> replaceDonorsForCity(String city, List<UserProfile> donors) async {
    final db = await _database();
    await db.transaction((txn) async {
      await txn.delete('donors', where: 'city = ?', whereArgs: [city]);
      for (final d in donors) {
        await txn.insert(
          'donors',
          {
            'id': d.id,
            'fullName': d.fullName,
            'age': d.age,
            'gender': d.gender.name,
            'bloodGroup': d.bloodGroup,
            'willingToDonate': d.willingToDonate ? 1 : 0,
            'mobileNumber': d.mobileNumber,
            'email': d.email,
            'province': d.province,
            'city': d.city,
            'area': d.area,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<UserProfile>> getDonors({
    required String city,
    required List<String> bloodGroups,
  }) async {
    final db = await _database();
    final placeholders = List.filled(bloodGroups.length, '?').join(',');
    final rows = await db.rawQuery(
      'SELECT * FROM donors WHERE city = ? AND willingToDonate = 1 AND bloodGroup IN ($placeholders)',
      [city, ...bloodGroups],
    );
    return rows
        .map((r) => UserProfile(
              id: r['id'] as String,
              fullName: r['fullName'] as String,
              age: r['age'] as int,
              gender: (r['gender'] as String) == 'female' ? Gender.female : Gender.male,
              bloodGroup: r['bloodGroup'] as String,
              willingToDonate: (r['willingToDonate'] as int) == 1,
              mobileNumber: r['mobileNumber'] as String,
              email: r['email'] as String,
              province: r['province'] as String,
              city: r['city'] as String,
              area: r['area'] as String,
            ))
        .toList();
  }

  Future<void> queuePendingOnlineSync(BloodRequest request) async {
    final db = await _database();
    await db.insert(
      'pending_requests',
      {
        'id': request.id,
        'payloadJson': request.toMap().toString(),
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final db = await _database();
    return db.query('pending_requests');
  }

  Future<void> clearPendingRequest(String id) async {
    final db = await _database();
    await db.delete('pending_requests', where: 'id = ?', whereArgs: [id]);
  }
}
