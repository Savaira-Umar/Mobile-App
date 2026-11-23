import 'package:flutter/material.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/icon_tile.dart';
import '../../domain/models/dummy_data.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskItem task;
  final VoidCallback onBack;
  final ValueChanged<TaskItem> onEdit;
  final ValueChanged<TaskItem> onDelete;
  final VoidCallback onOpenComments;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
    required this.onOpenComments,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _isDone = widget.task.isDone;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
        title: const Text('Delete Task', style: AppTypography.heading3),
        content: Text(
          'Are you sure you want to delete "${widget.task.title}"?',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dueRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete(widget.task);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${widget.task.title}"'),
                  backgroundColor: AppColors.textNavy,
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: AppColors.primaryBlueLight,
                    onPressed: () {
                      // Undo action
                    },
                  ),
                ),
              );
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
    final iconItem = AppIcons.getByKey(widget.task.iconKey);

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: const Text('Task Details'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (val) {
              if (val == 'edit') {
                widget.onEdit(widget.task);
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
                    Text('Edit Task'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.dueRed),
                    SizedBox(width: 8),
                    Text('Delete Task', style: TextStyle(color: AppColors.dueRed)),
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
            // Header Card with Big Icon Tile
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
                border: Border.all(
                  color: AppColors.borderSubtle.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                children: [
                  IconTile(
                    icon: iconItem.icon,
                    backgroundColor: _isDone ? AppColors.doneGreenLight : iconItem.bg,
                    iconColor: _isDone ? AppColors.doneGreenDark : iconItem.fg,
                    size: 64,
                    iconSize: 32,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.task.title,
                    textAlign: TextAlign.center,
                    style: AppTypography.heading2,
                  ),
                  const SizedBox(height: 8),
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isDone ? AppColors.doneGreenLight : AppColors.dueRedLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isDone ? 'Done' : (widget.task.isDue ? 'Due' : 'Pending'),
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _isDone ? AppColors.doneGreenDark : AppColors.dueRedDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description Card
            if (widget.task.description.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: AppTheme.cardBorderRadius,
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description', style: AppTypography.caption),
                    const SizedBox(height: 6),
                    Text(widget.task.description, style: AppTypography.body),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Schedule & Details Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: widget.task.date,
                  ),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: widget.task.time,
                  ),
                  const Divider(height: 20, color: AppColors.divider),
                  _buildDetailRow(
                    icon: Icons.notifications_active_outlined,
                    label: 'Reminder',
                    value: widget.task.reminderMinutes > 0
                        ? '${widget.task.reminderMinutes} min before'
                        : 'At task time',
                  ),
                  if (widget.task.goalTitle != null) ...[
                    const Divider(height: 20, color: AppColors.divider),
                    _buildDetailRow(
                      icon: Icons.track_changes_rounded,
                      label: 'Related Goal',
                      value: widget.task.goalTitle!,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Comments Button / Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onOpenComments,
                  borderRadius: AppTheme.cardBorderRadius,
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlueLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Comments', style: AppTypography.heading3),
                            Text(
                              '${widget.task.commentCount} notes & reflections',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textLight,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Big Toggle Button: Mark as Done / Pending
            AppPrimaryButton(
              label: _isDone ? 'Mark as Pending' : 'Mark as Done',
              icon: _isDone ? Icons.undo_rounded : Icons.check_circle_rounded,
              onPressed: () {
                setState(() {
                  _isDone = !_isDone;
                });
              },
            ),

            const SizedBox(height: 12),

            // Edit & Delete Outlined Buttons
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    label: 'Edit',
                    icon: Icons.edit_outlined,
                    onPressed: () => widget.onEdit(widget.task),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDangerButton(
                    label: 'Delete',
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryBlue),
        const SizedBox(width: 12),
        Text(label, style: AppTypography.bodyMuted),
        const Spacer(),
        Text(
          value,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
