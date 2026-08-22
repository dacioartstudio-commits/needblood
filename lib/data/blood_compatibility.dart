/// The compatibility engine — the "brain" of NeedBlood.
/// Given a recipient's blood group, returns every donor group that can
/// safely give to them. This runs automatically whenever a "Need Blood"
/// alert is sent; the user never selects donor groups manually.
class BloodCompatibility {
  static const List<String> allGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  /// recipient group -> list of donor groups that can give to them
  static const Map<String, List<String>> _donorsFor = {
    'O-': ['O-'],
    'O+': ['O+', 'O-'],
    'A-': ['A-', 'O-'],
    'A+': ['A+', 'A-', 'O+', 'O-'],
    'B-': ['B-', 'O-'],
    'B+': ['B+', 'B-', 'O+', 'O-'],
    'AB-': ['AB-', 'A-', 'B-', 'O-'],
    'AB+': ['AB+', 'AB-', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-'], // universal recipient
  };

  static List<String> compatibleDonorsFor(String recipientGroup) {
    return _donorsFor[recipientGroup] ?? const [];
  }

  /// Whether [donorGroup] can safely donate to [recipientGroup].
  static bool canDonate({required String donorGroup, required String recipientGroup}) {
    return compatibleDonorsFor(recipientGroup).contains(donorGroup);
  }
}
