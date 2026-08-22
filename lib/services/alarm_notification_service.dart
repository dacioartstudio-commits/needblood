import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

/// Handles the donor-side "incoming alert" experience: a full-screen
/// notification, a medium-to-high intensity ringtone, and vibration —
/// so an urgent request is impossible to miss, similar to an incoming
/// call rather than a quiet push notification.
class AlarmNotificationService {
  static final AlarmNotificationService _instance = AlarmNotificationService._internal();
  factory AlarmNotificationService() => _instance;
  AlarmNotificationService._internal();

  final _player = AudioPlayer();
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    // Dedicated Android channel set to max importance so it behaves like
    // a ringing call: heads-up display, sound, and vibration all forced on.
    const channel = AndroidNotificationChannel(
      'needblood_alerts',
      'Blood Request Alerts',
      description: 'Urgent blood request alarms',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Triggered when an FCM push (online) or a background SMS listener
  /// (offline) delivers a new blood request matching this donor.
  Future<void> triggerAlert({
    required String title,
    required String body,
  }) async {
    await _showFullScreenNotification(title, body);
    await _playAlarmSound();
    await _vibrate();
  }

  Future<void> _showFullScreenNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'needblood_alerts',
      'Blood Request Alerts',
      channelDescription: 'Urgent blood request alarms',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true, // wakes the screen like an incoming call
      category: AndroidNotificationCategory.call,
      ongoing: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Medium–high intensity ringtone, looped until the donor responds —
  /// noticeably louder/longer than a standard notification ping.
  Future<void> _playAlarmSound() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.85); // medium-high, not max, to stay comfortable
    await _player.play(AssetSource('sounds/alert_ring.mp3'));
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 600, 300, 600, 300, 600]);
    }
  }

  Future<void> stopAlarm() async {
    await _player.stop();
    Vibration.cancel();
  }
}
