import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeedBloodButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;

  const NeedBloodButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label, style: AppTextStyles.display(size: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
