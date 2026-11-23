import 'package:flutter/material.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/goal_card.dart';
import '../../domain/models/dummy_data.dart';

class GoalsListScreen extends StatelessWidget {
  final List<GoalItem> goals;
  final ValueChanged<GoalItem> onOpenGoal;
  final VoidCallback onAddGoal;

  const GoalsListScreen({
    super.key,
    required this.goals,
    required this.onOpenGoal,
    required this.onAddGoal,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header Row: "My Goals 🎯", Subtitle & Round Blue "+" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Goals 🎯',
                    style: AppTypography.heading1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Dream • Plan • Achieve',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onAddGoal,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryButtonGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x333B6FE0),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Goals List
          ...goals.map((goal) {
            final iconItem = AppIcons.getByKey(goal.iconKey);
            return GoalCard(
              title: goal.title,
              description: goal.description,
              targetDate: goal.targetDate,
              icon: iconItem.icon,
              iconBg: iconItem.bg,
              iconFg: iconItem.fg,
              completedTasks: goal.completedTasks,
              totalTasks: goal.totalTasks,
              onTap: () => onOpenGoal(goal),
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
