import 'package:flutter/material.dart';
import '../data/blood_compatibility.dart';
import '../theme/app_theme.dart';

class BloodGroupGrid extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const BloodGroupGrid({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.6,
      children: BloodCompatibility.allGroups.map((g) {
        final isOn = g == selected;
        return GestureDetector(
          onTap: () => onSelect(g),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isOn ? AppColors.blood : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isOn ? AppColors.blood : const Color(0xFFE7DCDD), width: 1.5),
            ),
            child: Text(
              g,
              style: AppTextStyles.mono(size: 13, color: isOn ? Colors.white : AppColors.inkSoft),
            ),
          ),
        );
      }).toList(),
    );
  }
}
