import 'package:flutter/material.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/progress_bar.dart';
import '../../domain/models/dummy_data.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalItem goal;
  final VoidCallback onBack;
  final ValueChanged<GoalItem> onEditGoal;
  final ValueChanged<GoalItem> onDeleteGoal;
  final VoidCallback onAddTaskForGoal;
  final ValueChanged<TaskItem> onOpenTaskDetails;

  const GoalDetailsScreen({
    super.key,
    required this.goal,
    required this.onBack,
    required this.onEditGoal,
    required this.onDeleteGoal,
    required this.onAddTaskForGoal,
    required this.onOpenTaskDetails,
  });

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late String _targetDate;
  late List<TaskItem> _goalTasks;

  @override
  void initState() {
    super.initState();
    _targetDate = widget.goal.targetDate;
    // Filter tasks belonging to this goal
    _goalTasks = DummyData.initialTodayTasks
        .where((t) => t.goalId == widget.goal.id)
        .toList();
    if (_goalTasks.isEmpty) {
      _goalTasks = [
        TaskItem(
          id: 'gt_1',
          title: '${widget.goal.title} Chapter 1',
          description: 'Read and take structured summary notes',
          time: '10:00 AM',
          date: '23 Nov 2026',
          iconKey: widget.goal.iconKey,
          isDone: true,
          goalId: widget.goal.id,
          goalTitle: widget.goal.title,
          ownerUserId: 'savaira',
        ),
        TaskItem(
          id: 'gt_2',
          title: '${widget.goal.title} Practice Session',
          description: 'Complete hands-on exercise and verify output',
          time: '02:30 PM',
          date: '23 Nov 2026',
          iconKey: widget.goal.iconKey,
          isDone: false,
          isDue: true,
          goalId: widget.goal.id,
          goalTitle: widget.goal.title,
          ownerUserId: 'savaira',
        ),
      ];
    }
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _goalTasks[index];
      _goalTasks[index] = task.copyWith(isDone: !task.isDone);
    });
  }

  Future<void> _changeTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _targetDate = '${picked.day} ${_monthName(picked.month)} ${picked.year}';
      });
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
        title: const Text('Delete Goal', style: AppTypography.heading3),
        content: Text(
          'Are you sure you want to delete "${widget.goal.title}"? Associated tasks will be kept.',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dueRed),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDeleteGoal(widget.goal);
              widget.onBack();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconItem = AppIcons.getByKey(widget.goal.iconKey);
    final completedCount = _goalTasks.where((t) => t.isDone).length;
    final totalCount = _goalTasks.length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
    final percentage = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: const Text('Goal Details'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (val) {
              if (val == 'edit') {
                widget.onEditGoal(widget.goal);
              } else if (val == 'change_date') {
                _changeTargetDate();
              } else if (val == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text('Edit Goal'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'change_date',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text('Change Target Date'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.dueRed),
                    SizedBox(width: 8),
                    Text('Delete Goal', style: TextStyle(color: AppColors.dueRed)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  IconTile(
                    icon: iconItem.icon,
                    backgroundColor: iconItem.bg,
                    iconColor: iconItem.fg,
                    size: 60,
                    iconSize: 28,
                    isCircle: true,
                  ),
                  const SizedBox(height: 12),
                  Text(widget.goal.title, style: AppTypography.heading2),
                  if (widget.goal.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      widget.goal.description,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMuted,
                    ),
                  ],
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _changeTargetDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Target Date: $_targetDate',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textNavy,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.edit_outlined,
                            size: 12,
                            color: AppColors.textLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedCount of $totalCount tasks done',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.doneGreenDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppProgressBar(
                    progress: progress,
                    height: 8,
                    trackColor: AppColors.primaryBlueLight,
                    fillColor: AppColors.doneGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tasks Strip Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlueLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tasks for this Goal', style: AppTypography.heading3),
                  GestureDetector(
                    onTap: widget.onAddTaskForGoal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 14, color: Colors.white),
                          SizedBox(width: 2),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Goal Tasks List
            ..._goalTasks.asMap().entries.map((entry) {
              final idx = entry.key;
              final task = entry.value;
              final tIcon = AppIcons.getByKey(task.iconKey);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: AppTheme.cardBorderRadius,
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    // Status Check Circle
                    GestureDetector(
                      onTap: () => _toggleTask(idx),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.isDone
                              ? AppColors.doneGreen
                              : Colors.transparent,
                          border: Border.all(
                            color: task.isDone
                                ? AppColors.doneGreen
                                : AppColors.circleOutline,
                            width: 2,
                          ),
                        ),
                        child: task.isDone
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconTile(
                      icon: tIcon.icon,
                      backgroundColor: tIcon.bg,
                      iconColor: tIcon.fg,
                      size: 38,
                      iconSize: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onOpenTaskDetails(task),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: AppTypography.heading3.copyWith(
                                fontSize: 14,
                                decoration:
                                    task.isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            Text(
                              task.time,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: task.isDone
                            ? AppColors.doneGreenLight
                            : AppColors.dueRedLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.isDone ? 'Done' : 'Due',
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: task.isDone
                              ? AppColors.doneGreenDark
                              : AppColors.dueRedDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Bottom Buttons: Add Task, Edit Goal, Delete Goal
            AppPrimaryButton(
              label: '+ Add Task',
              onPressed: widget.onAddTaskForGoal,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    label: 'Edit Goal',
                    icon: Icons.edit_outlined,
                    onPressed: () => widget.onEditGoal(widget.goal),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDangerButton(
                    label: 'Delete Goal',
                    onPressed: _confirmDelete,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
