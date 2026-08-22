enum Gender { male, female }

class UserProfile {
  final String id;
  final String fullName;
  final int age;
  final Gender gender;
  final String bloodGroup;
  final bool willingToDonate;
  final String mobileNumber;
  final String email;
  final String province;
  final String city;
  final String area;
  final String? profilePhotoUrl;
  final double? lastLat;
  final double? lastLng;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.willingToDonate,
    required this.mobileNumber,
    required this.email,
    required this.province,
    required this.city,
    required this.area,
    this.profilePhotoUrl,
    this.lastLat,
    this.lastLng,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'age': age,
        'gender': gender.name,
        'bloodGroup': bloodGroup,
        'willingToDonate': willingToDonate,
        'mobileNumber': mobileNumber,
        'email': email,
        'province': province,
        'city': city,
        'area': area,
        'profilePhotoUrl': profilePhotoUrl,
        'lastLat': lastLat,
        'lastLng': lastLng,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as String,
        fullName: map['fullName'] as String,
        age: map['age'] as int,
        gender: (map['gender'] as String) == 'female' ? Gender.female : Gender.male,
        bloodGroup: map['bloodGroup'] as String,
        willingToDonate: map['willingToDonate'] as bool,
        mobileNumber: map['mobileNumber'] as String,
        email: map['email'] as String,
        province: map['province'] as String,
        city: map['city'] as String,
        area: map['area'] as String,
        profilePhotoUrl: map['profilePhotoUrl'] as String?,
        lastLat: (map['lastLat'] as num?)?.toDouble(),
        lastLng: (map['lastLng'] as num?)?.toDouble(),
      );
}
