/// Pakistan provinces/territories with their cities.
/// Punjab, Sindh, and Khyber Pakhtunkhwa each list 30 real cities/towns.
/// Balochistan, Islamabad Capital Territory, Azad Kashmir, and
/// Gilgit-Baltistan list every well-known city/town in that region —
/// smaller territories genuinely don't have 30 major population centers,
/// so padding them further would mean inventing names.
///
/// Users can always add a city NeedBlood doesn't list yet via the
/// "Add your city" box in the profile screen (see ProfileSetupScreen).
class PakistanLocations {
  static const Map<String, List<String>> provinceCities = {
    'Punjab': [
      'Lahore', 'Jhang', 'Faisalabad', 'Multan', 'Rawalpindi', 'Gujranwala',
      'Sialkot', 'Bahawalpur', 'Sargodha', 'Sahiwal', 'Sheikhupura',
      'Rahim Yar Khan', 'Gujrat', 'Kasur', 'Okara', 'Dera Ghazi Khan',
      'Mianwali', 'Chiniot', 'Kamoke', 'Muzaffargarh', 'Khanewal',
      'Hafizabad', 'Vehari', 'Jhelum', 'Attock', 'Bahawalnagar',
      'Toba Tek Singh', 'Narowal', 'Layyah', 'Chakwal', 'Pakpattan',
      'Khushab', 'Mandi Bahauddin', 'Rajanpur', 'Nankana Sahib',
    ],
    'Sindh': [
      'Karachi', 'Hyderabad', 'Sukkur', 'Larkana', 'Nawabshah',
      'Mirpur Khas', 'Jacobabad', 'Shikarpur', 'Khairpur', 'Dadu',
      'Thatta', 'Badin', 'Umerkot', 'Sanghar', 'Tando Adam',
      'Tando Allahyar', 'Ghotki', 'Kashmore', 'Matiari', 'Naushahro Feroze',
      'Shaheed Benazirabad', 'Jamshoro', 'Kandhkot', 'Ranipur', 'Moro',
      'Tando Muhammad Khan', 'Kotri', 'Mehar', 'Rohri', 'Pano Aqil',
    ],
    'Khyber Pakhtunkhwa': [
      'Peshawar', 'Mardan', 'Abbottabad', 'Swat (Mingora)', 'Kohat',
      'Dera Ismail Khan', 'Bannu', 'Charsadda', 'Nowshera', 'Swabi',
      'Mansehra', 'Haripur', 'Chitral', 'Batagram', 'Buner (Daggar)',
      'Karak', 'Hangu', 'Lakki Marwat', 'Tank', 'Shangla (Alpuri)',
      'Malakand (Batkhela)', 'Dir (Lower)', 'Dir (Upper)', 'Tor Ghar (Judba)',
      'Kurram (Parachinar)', 'Khyber (Landi Kotal)', 'Orakzai (Kalaya)',
      'Torkham', 'Topi', 'Jamrud',
    ],
    'Balochistan': [
      'Quetta', 'Gwadar', 'Turbat', 'Khuzdar', 'Chaman', 'Hub', 'Sibi',
      'Zhob', 'Loralai', 'Dera Murad Jamali', 'Dera Allah Yar', 'Usta Muhammad',
      'Kalat', 'Mastung', 'Panjgur', 'Pasni', 'Ormara', 'Nushki', 'Kharan',
      'Lasbela', 'Sohbatpur', 'Barkhan', 'Kohlu', 'Dera Bugti', 'Harnai',
      'Ziarat', 'Musakhel', 'Washuk', 'Awaran', 'Duki',
    ],
    'Islamabad Capital Territory': ['Islamabad'],
    'Azad Kashmir': [
      'Muzaffarabad', 'Mirpur', 'Rawalakot', 'Kotli', 'Bhimber',
      'Bagh', 'Neelum (Athmuqam)', 'Hattian Bala', 'Sudhnoti (Pallandri)',
      'Haveli (Forward Kahuta)',
    ],
    'Gilgit-Baltistan': [
      'Gilgit', 'Skardu', 'Hunza (Karimabad)', 'Ghanche (Khaplu)',
      'Diamer (Chilas)', 'Astore', 'Nagar', 'Ghizer (Gahkuch)',
      'Shigar', 'Kharmang',
    ],
  };

  static List<String> get allProvinces => provinceCities.keys.toList();

  static List<String> citiesFor(String province) =>
      provinceCities[province] ?? const [];
}
