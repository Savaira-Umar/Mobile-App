import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/icon_tile.dart';
import '../../domain/models/dummy_data.dart';

class AddEditGoalScreen extends StatefulWidget {
  final GoalItem? initialGoal;
  final VoidCallback onBack;
  final ValueChanged<GoalItem> onSave;

  const AddEditGoalScreen({
    super.key,
    this.initialGoal,
    required this.onBack,
    required this.onSave,
  });

  @override
  State<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends State<AddEditGoalScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedIconKey;
  late DateTime _targetDate;

  final List<AppIconItem> _goalIcons = AppIcons.primaryIcons;

  @override
  void initState() {
    super.initState();
    final goal = widget.initialGoal;
    _titleController = TextEditingController(text: goal?.title ?? '');
    _descController = TextEditingController(text: goal?.description ?? '');
    _selectedIconKey = goal?.iconKey ?? 'book';
    _targetDate = DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a goal title.'),
          backgroundColor: AppColors.dueRed,
        ),
      );
      return;
    }

    final formattedDate = DateFormat('d MMM yyyy').format(_targetDate);

    final updated = GoalItem(
      id: widget.initialGoal?.id ?? 'goal_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: _descController.text.trim(),
      targetDate: formattedDate,
      iconKey: _selectedIconKey,
      completedTasks: widget.initialGoal?.completedTasks ?? 0,
      totalTasks: widget.initialGoal?.totalTasks ?? 0,
      ownerUserId: 'savaira',
    );

    widget.onSave(updated);
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialGoal != null;

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: Text(isEditing ? 'Edit Goal' : 'Add Goal'),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            const Text('Goal Title', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Master Flutter, Daily Reading...',
                prefixIcon: Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Description (Optional)', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Why is this goal important to you?',
              ),
            ),

            const SizedBox(height: 20),

            const Text('Select Goal Icon', style: AppTypography.heading3),
            const SizedBox(height: 10),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _goalIcons.map((item) {
                final isSelected = item.key == _selectedIconKey;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIconKey = item.key;
                    });
                  },
                  child: IconTile(
                    icon: item.icon,
                    backgroundColor: item.bg,
                    iconColor: item.fg,
                    size: 52,
                    iconSize: 24,
                    isCircle: true,
                    isSelected: isSelected,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            const Text('Target Completion Date', style: AppTypography.caption),
            const SizedBox(height: 6),
            InkWell(
              onTap: _pickTargetDate,
              borderRadius: AppTheme.inputBorderRadius,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: AppTheme.inputBorderRadius,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('d MMM yyyy').format(_targetDate),
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            AppPrimaryButton(
              label: isEditing ? 'Save Goal Changes' : 'Create Goal',
              icon: Icons.check_rounded,
              onPressed: _handleSave,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
