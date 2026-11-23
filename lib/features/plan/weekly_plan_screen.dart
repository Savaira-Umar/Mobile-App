import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/task_card.dart';
import '../../domain/models/dummy_data.dart';

class WeeklyPlanScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<TaskItem> onOpenTaskDetails;
  final VoidCallback onAddTask;

  const WeeklyPlanScreen({
    super.key,
    required this.onBack,
    required this.onOpenTaskDetails,
    required this.onAddTask,
  });

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  DateTime _weekStart = DateTime.now().subtract(
    Duration(days: DateTime.now().weekday - 1),
  );
  int _selectedDayIndex = DateTime.now().weekday - 1;
  late List<TaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(DummyData.initialTodayTasks);
  }

  void _previousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isDone: !task.isDone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = _weekStart.add(Duration(days: _selectedDayIndex));
    final fullDayHeading = DateFormat('EEEE, d MMM').format(selectedDate);
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: const Text('Weekly Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: AppColors.primaryBlue),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _weekStart = picked.subtract(Duration(days: picked.weekday - 1));
                  _selectedDayIndex = picked.weekday - 1;
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Week navigation header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: AppColors.primaryBlue,
                    onPressed: _previousWeek,
                  ),
                  Text(
                    '${DateFormat('d MMM').format(_weekStart)} - ${DateFormat('d MMM yyyy').format(_weekStart.add(const Duration(days: 6)))}',
                    style: AppTypography.heading3.copyWith(fontSize: 14),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: AppColors.primaryBlue,
                    onPressed: _nextWeek,
                  ),
                ],
              ),
            ),

            // Row of weekday chips (Mon to Sun)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final dayDate = _weekStart.add(Duration(days: i));
                  final isSelected = _selectedDayIndex == i;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = i;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.borderSubtle,
                        ),
                        boxShadow: isSelected ? AppTheme.buttonShadow : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            dayNames[i],
                            style: TextStyle(
                              fontFamily: AppTypography.fontUi,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dayDate.day}',
                            style: TextStyle(
                              fontFamily: AppTypography.fontUi,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : AppColors.textNavy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Selected Day Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  fullDayHeading,
                  style: AppTypography.heading3.copyWith(
                    color: AppColors.primaryBlueDark,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tasks List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
