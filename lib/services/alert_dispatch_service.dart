import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:telephony/telephony.dart';

import '../data/blood_compatibility.dart';
import '../models/blood_request.dart';
import '../models/user_profile.dart';
import 'local_donor_cache.dart';

/// Decides HOW an alert reaches donors:
///  - Online  -> write to Firestore; a Cloud Function fans it out as FCM
///               push notifications (full-screen alarm on the donor's phone).
///  - Offline -> read donors from the on-device SQLite cache (synced the
///               last time the app had internet) and send the same alert
///               text as a direct SMS via the telephony package.
///
/// Either path uses the same BloodRequest.buildAlertText(), so the donor
/// sees identical information (blood group, hospital, area, message)
/// regardless of delivery channel.
class AlertDispatchService {
  final FirebaseFirestore _firestore;
  final Telephony _telephony;
  final LocalDonorCache _localCache;

  AlertDispatchService({
    FirebaseFirestore? firestore,
    Telephony? telephony,
    LocalDonorCache? localCache,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _telephony = telephony ?? Telephony.instance,
        _localCache = localCache ?? LocalDonorCache();

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Sends [request] to every compatible, willing donor in the same
  /// city/area. Returns the delivery mode actually used, so the UI can
  /// show the requester whether it went out online or via SMS.
  Future<RequestDeliveryMode> sendAlert(BloodRequest request) async {
    final online = await _hasInternet();

    if (online) {
      await _sendOnline(request);
      return RequestDeliveryMode.online;
    } else {
      await _sendViaSms(request);
      return RequestDeliveryMode.smsFallback;
    }
  }

  Future<void> _sendOnline(BloodRequest request) async {
    // Writing the request doc triggers a Cloud Function (server side,
    // not shown here) that:
    //  1. Queries donors where city == request.city, willingToDonate == true,
    //     bloodGroup in BloodCompatibility.compatibleDonorsFor(request.bloodGroupNeeded)
    //  2. Sends an FCM data message to each donor's device token
    //  3. The app's background handler (see notification_service.dart)
    //     shows the full-screen alarm UI with the medium-high ringtone.
    await _firestore.collection('blood_requests').doc(request.id).set(request.toMap());
  }

  Future<void> _sendViaSms(BloodRequest request) async {
    final compatibleGroups = BloodCompatibility.compatibleDonorsFor(request.bloodGroupNeeded);

    // Donors previously synced to the local cache while online — this is
    // what makes offline sending possible at all.
    final donors = await _localCache.getDonors(
      city: request.city,
      bloodGroups: compatibleGroups,
    );

    final message = request.buildAlertText(recipientName: request.requesterName);

    for (final UserProfile donor in donors) {
      await _telephony.sendSms(to: donor.mobileNumber, message: message);
    }

    // Queue the request locally too, so it auto-retries an online send
    // (which also lets chat/call and live tracking pick it up) the next
    // time connectivity returns.
    await _localCache.queuePendingOnlineSync(request);
  }
}
