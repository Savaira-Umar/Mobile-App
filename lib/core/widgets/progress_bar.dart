import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Thin horizontal rounded progress bar.
class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color trackColor;
  final Color fillColor;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.trackColor = AppColors.primaryBlueLight,
    this.fillColor = AppColors.doneGreen,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return Container(
          width: totalWidth,
          height: height,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: totalWidth * clamped,
            height: height,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      },
    );
  }
}
