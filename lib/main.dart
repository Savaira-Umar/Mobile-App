import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_shell.dart';
import 'domain/models/dummy_data.dart';
import 'features/auth/login_screen.dart';
import 'features/goals/add_edit_goal_screen.dart';
import 'features/goals/goal_details_screen.dart';
import 'features/goals/goals_list_screen.dart';
import 'features/namaz/namaz_screen.dart';
import 'features/night_review/night_review_screen.dart';
import 'features/plan/daily_plan_screen.dart';
import 'features/plan/weekly_plan_screen.dart';
import 'features/settings/notification_settings_screen.dart';
import 'features/settings/profile_settings_screen.dart';
import 'features/today/add_edit_task_screen.dart';
import 'features/today/comments_bottom_sheet.dart';
import 'features/today/task_details_screen.dart';
import 'features/today/today_screen.dart';
import 'features/user2/user2_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SavairaApp()));
}

class SavairaApp extends StatelessWidget {
  const SavairaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savaira',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationShellHost(),
    );
  }
}

class MainNavigationShellHost extends StatefulWidget {
  const MainNavigationShellHost({super.key});

  @override
  State<MainNavigationShellHost> createState() => _MainNavigationShellHostState();
}

class _MainNavigationShellHostState extends State<MainNavigationShellHost> {
  bool _isLoggedIn = true;
  int _selectedTabIndex = 0;
  bool _isUser2Locked = true;

  late List<GoalItem> _goals;

  @override
  void initState() {
    super.initState();
    _goals = List.from(DummyData.initialGoals);
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: () {
          setState(() {
            _isLoggedIn = true;
          });
        },
      );
    }

    final screens = [
      // 0: Today Screen (S1)
      TodayScreen(
        onOpenNotifications: () {
          _navigateTo(
            NotificationSettingsScreen(
              onBack: () => Navigator.pop(context),
            ),
          );
        },
        onOpenProfile: () {
          _navigateTo(
            ProfileSettingsScreen(
              onBack: () => Navigator.pop(context),
              onOpenNotificationSettings: () {
                _navigateTo(
                  NotificationSettingsScreen(
                    onBack: () => Navigator.pop(context),
                  ),
                );
              },
              onLogout: () {
                Navigator.pop(context);
                setState(() {
                  _isLoggedIn = false;
                });
              },
            ),
          );
        },
        onViewAllTasks: () {
          _navigateTo(
            DailyPlanScreen(
              onBack: () => Navigator.pop(context),
              onOpenTaskDetails: (task) {
                _navigateTo(
                  TaskDetailsScreen(
                    task: task,
                    onBack: () => Navigator.pop(context),
                    onEdit: (t) {
                      Navigator.pop(context);
                      _navigateTo(
                        AddEditTaskScreen(
                          initialTask: t,
                          onBack: () => Navigator.pop(context),
                          onSave: (saved) {},
                        ),
                      );
                    },
                    onDelete: (t) {},
                    onOpenComments: () {
                      CommentsBottomSheet.show(context, task);
                    },
                  ),
                );
              },
              onAddTask: () {
                _navigateTo(
                  AddEditTaskScreen(
                    onBack: () => Navigator.pop(context),
                    onSave: (saved) {},
                  ),
                );
              },
            ),
          );
        },
        onOpenWeeklyPlan: () {
          _navigateTo(
            WeeklyPlanScreen(
              onBack: () => Navigator.pop(context),
              onOpenTaskDetails: (task) {
                _navigateTo(
                  TaskDetailsScreen(
                    task: task,
                    onBack: () => Navigator.pop(context),
                    onEdit: (t) {},
                    onDelete: (t) {},
                    onOpenComments: () {
                      CommentsBottomSheet.show(context, task);
                    },
                  ),
                );
              },
              onAddTask: () {
                _navigateTo(
                  AddEditTaskScreen(
                    onBack: () => Navigator.pop(context),
                    onSave: (saved) {},
                  ),
                );
              },
            ),
          );
        },
        onOpenTaskDetails: (task) {
          _navigateTo(
            TaskDetailsScreen(
              task: task,
              onBack: () => Navigator.pop(context),
              onEdit: (t) {
                Navigator.pop(context);
                _navigateTo(
                  AddEditTaskScreen(
                    initialTask: t,
                    onBack: () => Navigator.pop(context),
                    onSave: (saved) {},
                  ),
                );
              },
              onDelete: (t) {},
              onOpenComments: () {
                CommentsBottomSheet.show(context, task);
              },
            ),
          );
        },
        onAddTask: () {
          _navigateTo(
            AddEditTaskScreen(
              onBack: () => Navigator.pop(context),
              onSave: (saved) {},
            ),
          );
        },
        onOpenNightReview: () {
          _navigateTo(
            NightReviewScreen(
              onBack: () => Navigator.pop(context),
            ),
          );
        },
        onOpenComments: (task) {
          CommentsBottomSheet.show(context, task);
        },
      ),

      // 1: Goals Screen (S4)
      GoalsListScreen(
        goals: _goals,
        onOpenGoal: (goal) {
          _navigateTo(
            GoalDetailsScreen(
              goal: goal,
              onBack: () => Navigator.pop(context),
              onEditGoal: (g) {
                Navigator.pop(context);
                _navigateTo(
                  AddEditGoalScreen(
                    initialGoal: g,
                    onBack: () => Navigator.pop(context),
                    onSave: (saved) {},
                  ),
                );
              },
              onDeleteGoal: (g) {},
              onAddTaskForGoal: () {
                _navigateTo(
                  AddEditTaskScreen(
                    onBack: () => Navigator.pop(context),
                    onSave: (saved) {},
                  ),
                );
              },
              onOpenTaskDetails: (task) {
                _navigateTo(
                  TaskDetailsScreen(
                    task: task,
                    onBack: () => Navigator.pop(context),
                    onEdit: (t) {},
                    onDelete: (t) {},
                    onOpenComments: () {
                      CommentsBottomSheet.show(context, task);
                    },
                  ),
                );
              },
            ),
          );
        },
        onAddGoal: () {
          _navigateTo(
            AddEditGoalScreen(
              onBack: () => Navigator.pop(context),
              onSave: (saved) {},
            ),
          );
        },
      ),

      // 2: Namaz Screen (S8)
      const NamazScreen(),

      // 3: User 2 Screen (S9)
      User2Screen(
        onLockStatusChanged: () {
          setState(() {
            _isUser2Locked = !_isUser2Locked;
          });
        },
      ),
    ];

    return AppShell(
      selectedIndex: _selectedTabIndex,
      isUser2Locked: _isUser2Locked,
      onItemSelected: (index) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: screens[_selectedTabIndex],
    );
  }
}
