import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/progress_ring.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/task_card.dart';
import '../../domain/models/dummy_data.dart';

class TodayScreen extends StatefulWidget {
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenProfile;
  final VoidCallback onViewAllTasks;
  final VoidCallback onOpenWeeklyPlan;
  final ValueChanged<TaskItem> onOpenTaskDetails;
  final VoidCallback onAddTask;
  final VoidCallback onOpenNightReview;
  final ValueChanged<TaskItem>? onOpenComments;

  const TodayScreen({
    super.key,
    required this.onOpenNotifications,
    required this.onOpenProfile,
    required this.onViewAllTasks,
    required this.onOpenWeeklyPlan,
    required this.onOpenTaskDetails,
    required this.onAddTask,
    required this.onOpenNightReview,
    this.onOpenComments,
  });

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late List<TaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(DummyData.initialTodayTasks);
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isDone: !task.isDone);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) return 'Good Morning!';
    if (hour >= 12 && hour < 17) return 'Good Afternoon!';
    if (hour >= 17 && hour < 21) return 'Good Evening!';
    return 'Good Night!';
  }

  bool _isNightTime() {
    final hour = DateTime.now().hour;
    return hour < 5 || hour >= 20;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('d MMM yyyy').format(now);
    final weekdayStr = DateFormat('EEE').format(now);

    final completedCount = _tasks.where((t) => t.isDone).length;
    final totalCount = _tasks.length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Top Bar: Avatar (left), Date + Bell (right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar
              GestureDetector(
                onTap: widget.onOpenProfile,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontFamily: AppTypography.fontUi,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),

              // Date Pill & Bell Icon
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onOpenWeeklyPlan,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderSubtle.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 15,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateStr,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textNavy,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                weekdayStr,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onOpenNotifications,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderSubtle.withValues(alpha: 0.6),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 18,
                        color: AppColors.textNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Greeting Row with Sun/Moon Illustration
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: AppTypography.caption.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Savaira 😊',
                    style: AppTypography.heading1,
                  ),
                ],
              ),
              Positioned(
                top: -8,
                right: 0,
                child: Opacity(
                  opacity: 0.9,
                  child: SvgPicture.asset(
                    _isNightTime()
                        ? AssetPaths.moonCloud
                        : AssetPaths.sunCloud,
                    width: 76,
                    height: 60,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Card: Circular ring "3/5", title & bar
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: AppTheme.cardBorderRadius,
              boxShadow: AppTheme.cardShadow,
              border: Border.all(
                color: AppColors.borderSubtle.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              children: [
                ProgressRing(
                  completed: completedCount,
                  total: totalCount,
                  size: 74,
                  strokeWidth: 6.5,
                  progressColor: AppColors.primaryBlue,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Progress",
                        style: AppTypography.heading3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedCount of $totalCount tasks completed',
                        style: AppTypography.bodyMuted.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      AppProgressBar(
                        progress: progress,
                        height: 6,
                        trackColor: AppColors.primaryBlueLight,
                        fillColor: AppColors.doneGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Today's Tasks Section Header
          SectionHeader(
            title: "Today's Tasks",
            actionLabel: 'View All',
            onActionTap: widget.onViewAllTasks,
          ),

          const SizedBox(height: 8),

          // Task Cards List (Sorted by time)
          ..._tasks.asMap().entries.map((entry) {
            final idx = entry.key;
            final task = entry.value;
            final iconItem = AppIcons.getByKey(task.iconKey);

            return TaskCard(
              title: task.title,
              description: task.description,
              time: task.time,
              icon: iconItem.icon,
              iconBg: iconItem.bg,
              iconFg: iconItem.fg,
              isDone: task.isDone,
              isDue: task.isDue,
              commentCount: task.commentCount,
              onTap: () => widget.onOpenTaskDetails(task),
              onToggleDone: () => _toggleTask(idx),
              onCommentTap: () => widget.onOpenComments?.call(task),
            );
          }),

          const SizedBox(height: 14),

          // Night Review Card Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primaryBlueBorder.withValues(alpha: 0.5),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onOpenNightReview,
                borderRadius: BorderRadius.circular(18),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Night Review',
                            style: AppTypography.heading3.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryBlueDark,
                            ),
                          ),
                          Text(
                            'Reflect and record your day',
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Big Blue Pill Button: + Add Task
          AppPrimaryButton(
            label: '+ Add Task',
            onPressed: widget.onAddTask,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
