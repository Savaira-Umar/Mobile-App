import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationSettingsScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _masterNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _silentMode = false;
  String _selectedRingtone = 'Default System Tone';

  TimeOfDay _morningSummaryTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _nightReminderTime = const TimeOfDay(hour: 21, minute: 30);
  int _defaultReminderOffset = 5;

  Future<void> _pickMorningTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _morningSummaryTime,
    );
    if (picked != null) {
      setState(() {
        _morningSummaryTime = picked;
      });
    }
  }

  Future<void> _pickNightTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _nightReminderTime,
    );
    if (picked != null) {
      setState(() {
        _nightReminderTime = picked;
      });
    }
  }

  void _showRingtonePicker() {
    final ringtones = [
      'Default System Tone',
      'Gentle Bell',
      'Soft Chime',
      'Morning Bird',
      'Peaceful Ripple',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Notification Sound', style: AppTypography.heading3),
            const SizedBox(height: 12),
            ...ringtones.map(
              (tone) => ListTile(
                title: Text(tone, style: AppTypography.body),
                trailing: _selectedRingtone == tone
                    ? const Icon(Icons.check_rounded, color: AppColors.primaryBlue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedRingtone = tone;
                  });
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: const Text('Notification Settings'),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Master Toggle Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.primaryBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Allow Notifications', style: AppTypography.heading3),
                        Text(
                          'Receive reminders for scheduled tasks',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _masterNotifications,
                    activeTrackColor: AppColors.primaryBlue,
                    onChanged: (val) {
                      setState(() {
                        _masterNotifications = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sound, Vibration, Silent, Ringtone
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: _soundEnabled,
                    activeTrackColor: AppColors.primaryBlue,
                    title: const Text('Sound', style: AppTypography.body),
                    secondary: const Icon(Icons.volume_up_rounded, color: AppColors.primaryBlue),
                    onChanged: _masterNotifications
                        ? (v) => setState(() => _soundEnabled = v)
                        : null,
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  SwitchListTile.adaptive(
                    value: _vibrationEnabled,
                    activeTrackColor: AppColors.primaryBlue,
                    title: const Text('Vibration', style: AppTypography.body),
                    secondary: const Icon(Icons.vibration_rounded, color: AppColors.primaryBlue),
                    onChanged: _masterNotifications
                        ? (v) => setState(() => _vibrationEnabled = v)
                        : null,
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  SwitchListTile.adaptive(
                    value: _silentMode,
                    activeTrackColor: AppColors.primaryBlue,
                    title: const Text('Silent Notifications', style: AppTypography.body),
                    subtitle: const Text('Display banner without alert sound', style: AppTypography.caption),
                    secondary: const Icon(Icons.notifications_off_outlined, color: AppColors.primaryBlue),
                    onChanged: _masterNotifications
                        ? (v) => setState(() => _silentMode = v)
                        : null,
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.music_note_rounded, color: AppColors.primaryBlue),
                    title: const Text('Custom Ringtone', style: AppTypography.body),
                    subtitle: Text(_selectedRingtone, style: AppTypography.caption),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                    onTap: _masterNotifications ? _showRingtonePicker : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Daily Routine Reminder Times Card
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
                  const Text('Routine Reminders', style: AppTypography.heading3),
                  const SizedBox(height: 14),

                  // Morning Summary
                  InkWell(
                    onTap: _pickMorningTime,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.wb_sunny_rounded, color: AppColors.iconOrange, size: 20),
                            SizedBox(width: 10),
                            Text('Morning Summary', style: AppTypography.body),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _morningSummaryTime.format(context),
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 24, color: AppColors.divider),

                  // Night Reminder
                  InkWell(
                    onTap: _pickNightTime,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.nightlight_round, color: AppColors.iconPurple, size: 20),
                            SizedBox(width: 10),
                            Text('Night Review Reminder', style: AppTypography.body),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _nightReminderTime.format(context),
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 24, color: AppColors.divider),

                  // Default Reminder Offset
                  const Text('Default Task Reminder', style: AppTypography.caption),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildOffsetChip('At task time', 0),
                      _buildOffsetChip('5m before', 5),
                      _buildOffsetChip('10m before', 10),
                      _buildOffsetChip('15m before', 15),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Phone Battery & Autostart Optimization Help Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.pastelYellow.withValues(alpha: 0.6),
                borderRadius: AppTheme.cardBorderRadius,
                border: Border.all(
                  color: AppColors.iconYellow.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.battery_charging_full_rounded, color: AppColors.iconYellow, size: 20),
                      SizedBox(width: 8),
                      Text('Fix Notifications on My Phone', style: AppTypography.heading3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To ensure reminders ring reliably even when your phone is sleeping:\n\n'
                    '• Tecno Spark 20C (HiOS): Open Phone Master > Auto-start Management > Enable "Savaira". In Battery Lab, set Battery Optimization to "Don\'t optimize".\n\n'
                    '• Samsung S21 Ultra: Open Settings > Apps > Savaira > Battery > Set to "Unrestricted". In Device Care > Battery > Background usage limits, add Savaira to "Never sleeping apps".',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textNavy,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOffsetChip(String label, int minutes) {
    final isSelected = _defaultReminderOffset == minutes;

    return GestureDetector(
      onTap: () {
        setState(() {
          _defaultReminderOffset = minutes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
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
