import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/task_card.dart';
import '../../domain/models/dummy_data.dart';

class DailyPlanScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<TaskItem> onOpenTaskDetails;
  final VoidCallback onAddTask;

  const DailyPlanScreen({
    super.key,
    required this.onBack,
    required this.onOpenTaskDetails,
    required this.onAddTask,
  });

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  DateTime _currentDate = DateTime.now();
  late List<TaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(DummyData.initialTodayTasks);
  }

  void _previousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _currentDate = picked;
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isDone: !task.isDone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateDisplay = DateFormat('EEE, d MMM').format(_currentDate);

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: const Text('Daily Plan'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Selector Pill with arrows
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: AppColors.primaryBlue,
                      onPressed: _previousDay,
                    ),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 15,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateDisplay,
                            style: AppTypography.heading3.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      color: AppColors.primaryBlue,
                      onPressed: _nextDay,
                    ),
                  ],
                ),
              ),
            ),

            // Tasks List
            Expanded(
              child: _tasks.isEmpty
                  ? const EmptyStateWidget(
                      title: 'No tasks planned',
                      message: 'You have no tasks scheduled for this day yet.',
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
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
                          onToggleDone: () => _toggleTask(index),
                        );
                      },
                    ),
            ),

            // Bottom + Add Task Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppPrimaryButton(
                label: '+ Add Task',
                onPressed: widget.onAddTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
