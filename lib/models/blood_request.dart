enum RequestDeliveryMode { online, smsFallback }

class BloodRequest {
  final String id;
  final String requesterId;
  final String requesterName;
  final String bloodGroupNeeded;
  final String province;
  final String city;
  final String area;
  final double radiusKm;

  /// Shown to every donor alongside the alert so they know exactly
  /// where to go — required field on the request form.
  final String hospitalName;

  final String customMessage;
  final DateTime createdAt;
  final RequestDeliveryMode deliveryMode;
  final double? lat;
  final double? lng;

  const BloodRequest({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.bloodGroupNeeded,
    required this.province,
    required this.city,
    required this.area,
    required this.radiusKm,
    required this.hospitalName,
    required this.customMessage,
    required this.createdAt,
    required this.deliveryMode,
    this.lat,
    this.lng,
  });

  /// Text used for both the in-app alarm alert and the SMS fallback,
  /// so donors see the same information either way.
  String buildAlertText({required String recipientName}) {
    return '$recipientName needs $bloodGroupNeeded blood at $hospitalName, '
        '$area, $city. $customMessage';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'requesterId': requesterId,
        'requesterName': requesterName,
        'bloodGroupNeeded': bloodGroupNeeded,
        'province': province,
        'city': city,
        'area': area,
        'radiusKm': radiusKm,
        'hospitalName': hospitalName,
        'customMessage': customMessage,
        'createdAt': createdAt.toIso8601String(),
        'deliveryMode': deliveryMode.name,
        'lat': lat,
        'lng': lng,
      };

  factory BloodRequest.fromMap(Map<String, dynamic> map) => BloodRequest(
        id: map['id'] as String,
        requesterId: map['requesterId'] as String,
        requesterName: map['requesterName'] as String,
        bloodGroupNeeded: map['bloodGroupNeeded'] as String,
        province: map['province'] as String,
        city: map['city'] as String,
        area: map['area'] as String,
        radiusKm: (map['radiusKm'] as num).toDouble(),
        hospitalName: map['hospitalName'] as String,
        customMessage: map['customMessage'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        deliveryMode: (map['deliveryMode'] as String) == 'smsFallback'
            ? RequestDeliveryMode.smsFallback
            : RequestDeliveryMode.online,
        lat: (map['lat'] as num?)?.toDouble(),
        lng: (map['lng'] as num?)?.toDouble(),
      );
}
