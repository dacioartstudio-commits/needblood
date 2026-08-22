import 'package:flutter/material.dart';
import '../data/pakistan_locations.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_group_grid.dart';
import '../widgets/needblood_button.dart';
import '../services/location_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _customCityCtrl = TextEditingController();

  Gender _gender = Gender.male;
  String? _bloodGroup;
  bool _willingToDonate = true;
  bool _liveLocationOn = true;

  String _province = PakistanLocations.allProvinces.first;
  String? _city;
  bool _addingCustomCity = false;

  final _locationService = LocationService();

  Future<void> _autoDetectLocation() async {
    final pos = await _locationService.getCurrentPosition();
    if (pos == null) return;
    final resolved = await _locationService.resolveCityArea(pos);
    setState(() {
      if (resolved.city != null) _city = resolved.city;
      if (resolved.area != null) _areaCtrl.text = resolved.area!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cities = PakistanLocations.citiesFor(_province);

    return Scaffold(
      appBar: AppBar(title: const Text('Build Your Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(color: AppColors.rose, shape: BoxShape.circle),
              child: const Icon(Icons.add_a_photo_outlined, color: AppColors.bloodDeep),
            ),
          ),
          const SizedBox(height: 20),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
          const SizedBox(height: 12),
          TextField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          const SizedBox(height: 20),

          Text('Gender', style: AppTextStyles.display(size: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _GenderPill(label: 'Male', selected: _gender == Gender.male, onTap: () => setState(() => _gender = Gender.male))),
              const SizedBox(width: 8),
              Expanded(child: _GenderPill(label: 'Female', selected: _gender == Gender.female, onTap: () => setState(() => _gender = Gender.female))),
            ],
          ),
          const SizedBox(height: 20),

          Text('Your Blood Group', style: AppTextStyles.display(size: 15)),
          const SizedBox(height: 8),
          BloodGroupGrid(selected: _bloodGroup, onSelect: (g) => setState(() => _bloodGroup = g)),
          const SizedBox(height: 12),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Willing to Donate Blood?', style: AppTextStyles.body(size: 13, w: FontWeight.w600, color: AppColors.ink)),
            value: _willingToDonate,
            activeColor: AppColors.go,
            onChanged: (v) => setState(() => _willingToDonate = v),
          ),

          const SizedBox(height: 12),
          Text('Province', style: AppTextStyles.display(size: 15)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _province,
            items: PakistanLocations.allProvinces
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => setState(() {
              _province = v!;
              _city = null;
              _addingCustomCity = false;
            }),
          ),
          const SizedBox(height: 12),

          Text('City', style: AppTextStyles.display(size: 15)),
          const SizedBox(height: 8),
          if (!_addingCustomCity)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cities
                  .map((c) => ChoiceChip(
                        label: Text(c),
                        selected: _city == c,
                        onSelected: (_) => setState(() => _city = c),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 8),
          if (!_addingCustomCity)
            OutlinedButton.icon(
              onPressed: () => setState(() => _addingCustomCity = true),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Can't find your city? Add it manually"),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customCityCtrl,
                    decoration: const InputDecoration(hintText: 'Type your city name'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: AppColors.go),
                  onPressed: () {
                    if (_customCityCtrl.text.trim().isEmpty) return;
                    setState(() {
                      _city = _customCityCtrl.text.trim();
                      _addingCustomCity = false;
                      // TODO: also submit to a `suggested_cities` collection
                      // so the admin can review and add it to the master list.
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 12),

          TextField(controller: _areaCtrl, decoration: const InputDecoration(labelText: 'Area / Locality')),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () async {
              setState(() => _liveLocationOn = true);
              await _autoDetectLocation();
            },
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text('Use My Live Location'),
          ),
          const SizedBox(height: 20),

          NeedBloodButton(
            label: 'Save & Continue',
            color: AppColors.go,
            onTap: () {
              // TODO: build UserProfile and write to Firestore users/{uid}
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GenderPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenderPill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.trust : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.trust : const Color(0xFFE7DCDD)),
        ),
        child: Text(label, style: AppTextStyles.body(size: 13, w: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSoft)),
      ),
    );
  }
}
