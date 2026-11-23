import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/auto_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/icon_picker_dialog.dart';
import '../../core/widgets/icon_tile.dart';
import '../../domain/models/dummy_data.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskItem? initialTask;
  final VoidCallback onBack;
  final ValueChanged<TaskItem> onSave;
  final ValueChanged<TaskItem>? onDelete;

  const AddEditTaskScreen({
    super.key,
    this.initialTask,
    required this.onBack,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedIconKey;
  bool _isManualIconSelected = false;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _reminderEnabled = true;
  int _reminderMinutes = 5;
  String? _selectedGoalId;

  final List<AppIconItem> _primaryGridIcons = AppIcons.primaryIcons;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descController = TextEditingController(text: task?.description ?? '');
    _selectedIconKey = task?.iconKey ?? 'book';
    _isManualIconSelected = task != null;

    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now().replacing(minute: 0);
    _reminderMinutes = task?.reminderMinutes ?? 5;
    _reminderEnabled = task != null ? task.reminderMinutes >= 0 : true;
    _selectedGoalId = task?.goalId;

    _titleController.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    if (!_isManualIconSelected) {
      final autoKey = AutoIcons.matchTitle(_titleController.text);
      if (autoKey != _selectedIconKey) {
        setState(() {
          _selectedIconKey = autoKey;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              surface: AppColors.cardWhite,
              onSurface: AppColors.textNavy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              surface: AppColors.cardWhite,
              onSurface: AppColors.textNavy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title.'),
          backgroundColor: AppColors.dueRed,
        ),
      );
      return;
    }

    final formattedTime = _selectedTime.format(context);
    final formattedDate = DateFormat('d MMM yyyy').format(_selectedDate);

    final updated = TaskItem(
      id: widget.initialTask?.id ?? 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: _descController.text.trim(),
      time: formattedTime,
      date: formattedDate,
      iconKey: _selectedIconKey,
      reminderMinutes: _reminderEnabled ? _reminderMinutes : 0,
      goalId: _selectedGoalId,
      ownerUserId: 'savaira',
      isDone: widget.initialTask?.isDone ?? false,
    );

    widget.onSave(updated);
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTask != null;

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Title Input
            const Text('Task Title', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Read English, Coding, Walk...',
                prefixIcon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Short Description Input
            const Text('Short Description (Optional)', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Add details or context for this task...',
              ),
            ),

            const SizedBox(height: 20),

            // Icon Grid Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose Icon', style: AppTypography.heading3),
                if (!_isManualIconSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.doneGreenLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Auto-detected',
                      style: AppTypography.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.doneGreenDark,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // 3 cols x 4 rows icon grid (11 primary + "..." picker)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                if (index < _primaryGridIcons.length) {
                  final item = _primaryGridIcons[index];
                  final isSelected = item.key == _selectedIconKey;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIconKey = item.key;
                        _isManualIconSelected = true;
                      });
                    },
                    child: IconTile(
                      icon: item.icon,
                      backgroundColor: item.bg,
                      iconColor: item.fg,
                      size: 50,
                      iconSize: 22,
                      isSelected: isSelected,
                    ),
                  );
                } else {
                  // Last tile: "..." full icon picker
                  return GestureDetector(
                    onTap: () async {
                      final picked = await IconPickerDialog.show(
                        context,
                        _selectedIconKey,
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedIconKey = picked.key;
                          _isManualIconSelected = true;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: AppTheme.tileBorderRadius,
                        border: Border.all(
                          color: AppColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: AppColors.textMuted,
                          size: 26,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            // Date & Time Selectors Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Date', style: AppTypography.caption),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: AppTheme.inputBorderRadius,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: AppTheme.inputBorderRadius,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormat('d MMM yyyy').format(_selectedDate),
                                  style: AppTypography.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Time', style: AppTypography.caption),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickTime,
                        borderRadius: AppTheme.inputBorderRadius,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: AppTheme.inputBorderRadius,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedTime.format(context),
                                  style: AppTypography.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Reminder Toggle & Offset choices
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            size: 18,
                            color: AppColors.primaryBlue,
                          ),
                          SizedBox(width: 8),
                          Text('Task Reminder', style: AppTypography.heading3),
                        ],
                      ),
                      Switch.adaptive(
                        value: _reminderEnabled,
                        activeTrackColor: AppColors.primaryBlue,
                        onChanged: (val) {
                          setState(() {
                            _reminderEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_reminderEnabled) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildReminderChip('At task time', 0),
                        _buildReminderChip('5 min before', 5),
                        _buildReminderChip('10 min before', 10),
                        _buildReminderChip('15 min before', 15),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Related Goal (Optional)
            const Text('Related Goal (Optional)', style: AppTypography.caption),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.inputBorderRadius,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedGoalId,
                  isExpanded: true,
                  hint: const Text('None / Standalone Task', style: AppTypography.bodyMuted),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None / Standalone Task'),
                    ),
                    ...DummyData.initialGoals.map(
                      (g) => DropdownMenuItem<String?>(
                        value: g.id,
                        child: Text(g.title),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedGoalId = val;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Save Task Button
            AppPrimaryButton(
              label: isEditing ? 'Save Changes' : 'Save Task',
              icon: Icons.check_rounded,
              onPressed: _handleSave,
            ),

            if (isEditing && widget.onDelete != null) ...[
              const SizedBox(height: 12),
              AppDangerButton(
                label: 'Delete Task',
                onPressed: () {
                  widget.onDelete!(widget.initialTask!);
                  widget.onBack();
                },
              ),
            ],

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderChip(String label, int minutes) {
    final isSelected = _reminderMinutes == minutes;

    return GestureDetector(
      onTap: () {
        setState(() {
          _reminderMinutes = minutes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textNavy,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
