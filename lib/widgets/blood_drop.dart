import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The app's signature shape — used for the logo mark and, at larger
/// sizes, as the mask for profile photos instead of a plain circle.
class BloodDrop extends StatelessWidget {
  final double size;
  final Color color;
  const BloodDrop({super.key, this.size = 14, this.color = AppColors.blood});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(size * 0.6),
            bottomLeft: Radius.circular(size * 0.6),
            bottomRight: Radius.circular(size * 0.6),
          ),
        ),
      ),
    );
  }
}
