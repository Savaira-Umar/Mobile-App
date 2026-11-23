import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/asset_paths.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'icon_tile.dart';
import 'progress_bar.dart';

/// Goal Card matching the design reference:
/// - Circular pastel icon at left
/// - Title, short description
/// - Calendar icon + target date
/// - Thin green progress bar with percentage / count
/// - Bottom chip with green check circle, task count and chevron ">"
/// - Subtle leaf decoration on top-right card corner
class GoalCard extends StatelessWidget {
  final String title;
  final String description;
  final String targetDate;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final int completedTasks;
  final int totalTasks;
  final VoidCallback? onTap;

  const GoalCard({
    super.key,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.icon,
    this.iconBg = AppColors.pastelGreen,
    this.iconFg = AppColors.iconGreen,
    required this.completedTasks,
    required this.totalTasks,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        totalTasks > 0 ? (completedTasks / totalTasks).clamp(0.0, 1.0) : 0.0;
    final int percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: AppColors.borderSubtle.withValues(alpha: 0.6),
          width: 1.1,
        ),
      ),
      child: Stack(
        children: [
          // Corner Leaf Decoration (top right)
          Positioned(
            top: 2,
            right: 2,
            child: Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                AssetPaths.leafCorner,
                width: 26,
                height: 26,
              ),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: AppTheme.cardBorderRadius,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: Circular icon, title & target date
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconTile(
                          icon: icon,
                          backgroundColor: iconBg,
                          iconColor: iconFg,
                          size: 46,
                          iconSize: 22,
                          isCircle: true,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppTypography.heading3.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (description.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodyMuted.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 12,
                                    color: AppColors.textLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    targetDate,
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Progress Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedTasks/$totalTasks tasks',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textNavy,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.doneGreenDark,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AppProgressBar(
                      progress: progress,
                      height: 6,
                      trackColor: AppColors.primaryBlueLight,
                      fillColor: AppColors.doneGreen,
                    ),

                    const SizedBox(height: 12),

                    // Bottom Chip: Green Check + Count + Chevron
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: AppColors.doneGreen,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$totalTasks Tasks assigned',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textNavy,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppColors.textLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
