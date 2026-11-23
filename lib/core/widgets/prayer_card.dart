import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'icon_tile.dart';

enum PrayerStatus { none, completed, missed }

/// Prayer card for S8 Namaz screen:
/// - Sky icon (sunrise, sun, afternoon, sunset, moon)
/// - Prayer Name & Editable Time badge
/// - Green tick & Red cross toggle buttons
class PrayerCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData skyIcon;
  final Color iconBg;
  final Color iconFg;
  final PrayerStatus status;
  final VoidCallback? onTickTap;
  final VoidCallback? onCrossTap;
  final VoidCallback? onTimeTap;

  const PrayerCard({
    super.key,
    required this.name,
    required this.time,
    required this.skyIcon,
    this.iconBg = AppColors.pastelBlue,
    this.iconFg = AppColors.iconBlue,
    required this.status,
    this.onTickTap,
    this.onCrossTap,
    this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: status == PrayerStatus.completed
              ? AppColors.doneGreen.withValues(alpha: 0.3)
              : (status == PrayerStatus.missed
                  ? AppColors.dueRed.withValues(alpha: 0.3)
                  : AppColors.borderSubtle.withValues(alpha: 0.6)),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          // Sky Icon Tile
          IconTile(
            icon: skyIcon,
            backgroundColor: iconBg,
            iconColor: iconFg,
            size: 44,
            iconSize: 22,
          ),
          const SizedBox(width: 12),

          // Name and Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTypography.heading3.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: onTimeTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.edit_outlined,
                        size: 11,
                        color: AppColors.textLight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tick Button (Green)
          GestureDetector(
            onTap: onTickTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status == PrayerStatus.completed
                    ? AppColors.doneGreen
                    : AppColors.doneGreenLight.withValues(alpha: 0.5),
                border: Border.all(
                  color: status == PrayerStatus.completed
                      ? AppColors.doneGreen
                      : AppColors.doneGreen.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 20,
                color: status == PrayerStatus.completed
                    ? Colors.white
                    : AppColors.doneGreen.withValues(alpha: 0.4),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Cross Button (Red)
          GestureDetector(
            onTap: onCrossTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status == PrayerStatus.missed
                    ? AppColors.dueRed
                    : AppColors.dueRedLight.withValues(alpha: 0.5),
                border: Border.all(
                  color: status == PrayerStatus.missed
                      ? AppColors.dueRed
                      : AppColors.dueRed.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 20,
                color: status == PrayerStatus.missed
                    ? Colors.white
                    : AppColors.dueRed.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
