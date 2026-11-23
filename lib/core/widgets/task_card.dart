import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'icon_tile.dart';

/// Task Card adhering strictly to SAVAIRA design specifications:
/// - Left pastel icon tile
/// - Title (bold), short description (grey)
/// - Clock icon + time in blue
/// - Right status circle (Green checkmark when done; soft red / outline when pending)
/// - Optional comment bubble indicator
class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final bool isDone;
  final bool isDue;
  final int commentCount;
  final VoidCallback? onTap;
  final VoidCallback? onToggleDone;
  final VoidCallback? onCommentTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.iconBg = AppColors.pastelBlue,
    this.iconFg = AppColors.iconBlue,
    required this.isDone,
    this.isDue = false,
    this.commentCount = 0,
    this.onTap,
    this.onToggleDone,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: isDone
              ? AppColors.doneGreen.withValues(alpha: 0.25)
              : (isDue
                  ? AppColors.dueRed.withValues(alpha: 0.25)
                  : AppColors.borderSubtle.withValues(alpha: 0.6)),
          width: 1.1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.cardBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Pastel Icon Tile
                IconTile(
                  icon: icon,
                  backgroundColor: isDone ? AppColors.doneGreenLight : iconBg,
                  iconColor: isDone ? AppColors.doneGreenDark : iconFg,
                  size: 46,
                  iconSize: 22,
                ),
                const SizedBox(width: 12),

                // Title, description & time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.heading3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone
                              ? AppColors.textMuted
                              : AppColors.textNavy,
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
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
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          if (isDue && !isDone)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.dueRedLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Due',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.dueRedDark,
                                ),
                              ),
                            ),
                          if (commentCount > 0)
                            GestureDetector(
                              onTap: onCommentTap,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 12,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$commentCount',
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Status Check Circle
                GestureDetector(
                  onTap: onToggleDone,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.doneGreen : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone
                            ? AppColors.doneGreen
                            : (isDue ? AppColors.dueRed : AppColors.circleOutline),
                        width: 2,
                      ),
                    ),
                    child: isDone
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
