import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/prayer_card.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/progress_ring.dart';
import '../../domain/models/dummy_data.dart';
import '../today/comments_bottom_sheet.dart';

class User2Screen extends StatefulWidget {
  final VoidCallback onLockStatusChanged;

  const User2Screen({
    super.key,
    required this.onLockStatusChanged,
  });

  @override
  State<User2Screen> createState() => _User2ScreenState();
}

class _User2ScreenState extends State<User2Screen> {
  bool _isUnlocked = false;
  final _nameController = TextEditingController();
  String? _errorMessage;
  int _failedAttempts = 0;
  bool _isLockedOut = false;

  // Tabs inside Unlocked User 2 space: 0 = Today, 1 = Goals, 2 = Namaz
  int _currentTab = 0;

  static const String _expectedName = 'ayesha';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _verifyName() {
    if (_isLockedOut) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Too many attempts. Please wait 30 seconds.'),
          backgroundColor: AppColors.dueRed,
        ),
      );
      return;
    }

    final entered = _nameController.text.trim().toLowerCase();
    if (entered == _expectedName || entered == 'ayesha') {
      setState(() {
        _isUnlocked = true;
        _errorMessage = null;
        _failedAttempts = 0;
      });
      widget.onLockStatusChanged();
    } else {
      setState(() {
        _failedAttempts++;
        _errorMessage = 'Name is not correct';
        if (_failedAttempts >= 5) {
          _isLockedOut = true;
          Future.delayed(const Duration(seconds: 30), () {
            if (mounted) {
              setState(() {
                _isLockedOut = false;
                _failedAttempts = 0;
              });
            }
          });
        }
      });
    }
  }

  void _lockSpace() {
    setState(() {
      _isUnlocked = false;
      _nameController.clear();
      _errorMessage = null;
    });
    widget.onLockStatusChanged();
  }

  @override
  Widget build(BuildContext context) {
    return _isUnlocked ? _buildUnlockedSpace() : _buildLockedGate();
  }

  // S9 Locked Gate Screen
  Widget _buildLockedGate() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shield with padlock illustration
              SvgPicture.asset(
                AssetPaths.shieldLock,
                width: 90,
                height: 100,
              ),

              const SizedBox(height: 20),

              const Text('User 2', style: AppTypography.heading1),
              const SizedBox(height: 6),
              Text(
                'Enter the name to access User 2\'s page',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMuted,
              ),

              const SizedBox(height: 26),

              // Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  errorText: _errorMessage,
                ),
                onSubmitted: (_) => _verifyName(),
              ),

              const SizedBox(height: 20),

              // Full-width blue Continue button with arrow
              AppPrimaryButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: _verifyName,
              ),

              const SizedBox(height: 32),

              // Bottom illustration: blue and pink persons with heart
              SvgPicture.asset(
                AssetPaths.privacyPeople,
                width: 110,
                height: 65,
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Your privacy is our priority',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // S9 Unlocked View-Only Space
  Widget _buildUnlockedSpace() {
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header: Hello, Ayesha 💕 with lock button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View-Only Space',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.user2Pink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Hello, Ayesha 💕',
                    style: AppTypography.heading1,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.lock_rounded, color: AppColors.primaryBlue),
                tooltip: 'Lock User 2 Space',
                onPressed: _lockSpace,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Segmented Control: Today / Goals / Namaz
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderSubtle.withValues(alpha: 0.8),
              ),
            ),
            child: Row(
              children: [
                _buildSegmentTab('Today', 0),
                _buildSegmentTab('Goals', 1),
                _buildSegmentTab('Namaz', 2),
              ],
            ),
          ),

          const SizedBox(height: 18),

          if (_currentTab == 0) _buildUser2Today(),
          if (_currentTab == 1) _buildUser2Goals(),
          if (_currentTab == 2) _buildUser2Namaz(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSegmentTab(String title, int index) {
    final isSelected = _currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppTypography.fontUi,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textNavy,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUser2Today() {
    final tasks = DummyData.user2Tasks;
    final done = tasks.where((t) => t.isDone).length;
    final total = tasks.length;
    final progress = total > 0 ? (done / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: AppTheme.cardBorderRadius,
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              ProgressRing(
                completed: done,
                total: total,
                size: 70,
                strokeWidth: 6,
                progressColor: AppColors.user2Pink,
                trackColor: AppColors.user2PinkLight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ayesha\'s Progress', style: AppTypography.heading3),
                    const SizedBox(height: 4),
                    Text(
                      '$done of $total tasks finished today',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 8),
                    AppProgressBar(
                      progress: progress,
                      height: 6,
                      trackColor: AppColors.user2PinkLight,
                      fillColor: AppColors.user2Pink,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Text('Today\'s Tasks (View Only)', style: AppTypography.heading3),
        const SizedBox(height: 10),

        ...tasks.map((task) {
          final iconItem = AppIcons.getByKey(task.iconKey);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: AppTheme.cardBorderRadius,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                IconTile(
                  icon: iconItem.icon,
                  backgroundColor: task.isDone ? AppColors.doneGreenLight : iconItem.bg,
                  iconColor: task.isDone ? AppColors.doneGreenDark : iconItem.fg,
                  size: 44,
                  iconSize: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTypography.heading3.copyWith(
                          fontSize: 14,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        task.time,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Speech bubble for comments (tappable to open comments!)
                GestureDetector(
                  onTap: () {
                    CommentsBottomSheet.show(context, task, currentUser: 'Savaira');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 14,
                          color: AppColors.primaryBlue,
                        ),
                        if (task.commentCount > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '${task.commentCount}',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Status Indicator
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isDone ? AppColors.doneGreen : Colors.transparent,
                    border: Border.all(
                      color: task.isDone ? AppColors.doneGreen : AppColors.circleOutline,
                      width: 2,
                    ),
                  ),
                  child: task.isDone
                      ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUser2Goals() {
    return Column(
      children: [
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
                children: [
                  const IconTile(
                    icon: Icons.school_rounded,
                    backgroundColor: AppColors.pastelPurple,
                    iconColor: AppColors.iconPurple,
                    size: 44,
                    iconSize: 22,
                    isCircle: true,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Master Software Architecture', style: AppTypography.heading3),
                        Text('Target: 15 Jan 2027', style: AppTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const AppProgressBar(progress: 0.65, fillColor: AppColors.user2Pink),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUser2Namaz() {
    return Column(
      children: [
        PrayerCard(
          name: 'Fajr',
          time: '05:30 AM',
          skyIcon: Icons.wb_twilight_rounded,
          iconBg: AppColors.pastelBlue,
          iconFg: AppColors.iconBlue,
          status: PrayerStatus.completed,
        ),
        PrayerCard(
          name: 'Zuhar',
          time: '01:00 PM',
          skyIcon: Icons.wb_sunny_rounded,
          iconBg: AppColors.pastelYellow,
          iconFg: AppColors.iconYellow,
          status: PrayerStatus.completed,
        ),
        PrayerCard(
          name: 'Asar',
          time: '04:30 PM',
          skyIcon: Icons.sunny_snowing,
          iconBg: AppColors.pastelOrange,
          iconFg: AppColors.iconOrange,
          status: PrayerStatus.none,
        ),
      ],
    );
  }
}
