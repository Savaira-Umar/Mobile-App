import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/prayer_card.dart';

class PrayerData {
  final String name;
  String time;
  final IconData skyIcon;
  final Color iconBg;
  final Color iconFg;
  PrayerStatus status;

  PrayerData({
    required this.name,
    required this.time,
    required this.skyIcon,
    required this.iconBg,
    required this.iconFg,
    this.status = PrayerStatus.none,
  });
}

class NamazScreen extends StatefulWidget {
  const NamazScreen({super.key});

  @override
  State<NamazScreen> createState() => _NamazScreenState();
}

class _NamazScreenState extends State<NamazScreen> {
  DateTime _selectedDate = DateTime.now();

  late List<PrayerData> _prayers;

  @override
  void initState() {
    super.initState();
    _prayers = [
      PrayerData(
        name: 'Fajr',
        time: '05:15 AM',
        skyIcon: Icons.wb_twilight_rounded,
        iconBg: AppColors.pastelBlue,
        iconFg: AppColors.iconBlue,
        status: PrayerStatus.completed,
      ),
      PrayerData(
        name: 'Zuhar',
        time: '12:30 PM',
        skyIcon: Icons.wb_sunny_rounded,
        iconBg: AppColors.pastelYellow,
        iconFg: AppColors.iconYellow,
        status: PrayerStatus.completed,
      ),
      PrayerData(
        name: 'Asar',
        time: '04:45 PM',
        skyIcon: Icons.sunny_snowing,
        iconBg: AppColors.pastelOrange,
        iconFg: AppColors.iconOrange,
        status: PrayerStatus.completed,
      ),
      PrayerData(
        name: 'Maghrib',
        time: '06:20 PM',
        skyIcon: Icons.nightlight_round,
        iconBg: AppColors.pastelCoral,
        iconFg: AppColors.iconCoral,
        status: PrayerStatus.none,
      ),
      PrayerData(
        name: 'Isha',
        time: '07:45 PM',
        skyIcon: Icons.bedtime_rounded,
        iconBg: AppColors.pastelPurple,
        iconFg: AppColors.iconPurple,
        status: PrayerStatus.none,
      ),
    ];
  }

  void _onTick(int index) {
    setState(() {
      if (_prayers[index].status == PrayerStatus.completed) {
        _prayers[index].status = PrayerStatus.none;
      } else {
        _prayers[index].status = PrayerStatus.completed;
      }
    });
  }

  void _onCross(int index) {
    setState(() {
      if (_prayers[index].status == PrayerStatus.missed) {
        _prayers[index].status = PrayerStatus.none;
      } else {
        _prayers[index].status = PrayerStatus.missed;
      }
    });
  }

  Future<void> _editPrayerTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _prayers[index].time = picked.format(context);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateDisplay = DateFormat('EEE, d MMM yyyy').format(_selectedDate);

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header with Mosque Illustration at top right
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Namaz',
                    style: AppTypography.heading1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'May Allah accept our prayers',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -8,
                right: 0,
                child: Opacity(
                  opacity: 0.9,
                  child: SvgPicture.asset(
                    AssetPaths.mosque,
                    width: 76,
                    height: 64,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Date Selector Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderSubtle.withValues(alpha: 0.6),
              ),
              boxShadow: AppTheme.subtleShadow,
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
                        Icons.calendar_month_rounded,
                        size: 15,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateDisplay,
                        style: AppTypography.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textNavy,
                        ),
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

          const SizedBox(height: 18),

          // 5 Prayer Cards
          ..._prayers.asMap().entries.map((entry) {
            final idx = entry.key;
            final prayer = entry.value;

            return PrayerCard(
              name: prayer.name,
              time: prayer.time,
              skyIcon: prayer.skyIcon,
              iconBg: prayer.iconBg,
              iconFg: prayer.iconFg,
              status: prayer.status,
              onTickTap: () => _onTick(idx),
              onCrossTap: () => _onCross(idx),
              onTimeTap: () => _editPrayerTime(idx),
            );
          }),

          const SizedBox(height: 16),

          // Bottom Arabic Dua Card: "اللهم تقبل منا" + "May Allah accept our prayers" with heart
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueLight.withValues(alpha: 0.7),
              borderRadius: AppTheme.cardBorderRadius,
              border: Border.all(
                color: AppColors.primaryBlueBorder.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'اللهم تقبل منا',
                  style: AppTypography.arabicDua,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'May Allah accept our prayers',
                      style: AppTypography.bodyMuted.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlueDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.favorite,
                      size: 14,
                      color: AppColors.user2Heart,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
