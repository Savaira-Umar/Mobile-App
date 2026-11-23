import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Pastel rounded-square or circle tile behind each icon.
class IconTile extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final bool isCircle;
  final bool isSelected;

  const IconTile({
    super.key,
    required this.icon,
    this.backgroundColor = AppColors.pastelBlue,
    this.iconColor = AppColors.iconBlue,
    this.size = 46,
    this.iconSize = 24,
    this.isCircle = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : AppTheme.tileBorderRadius,
        border: isSelected
            ? Border.all(color: AppColors.primaryBlue, width: 2.2)
            : null,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
