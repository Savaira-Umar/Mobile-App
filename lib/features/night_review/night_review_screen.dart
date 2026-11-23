import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';

class NightReviewScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int completedCount;
  final int pendingCount;
  final String? initialNote;
  final ValueChanged<String>? onSaveNote;

  const NightReviewScreen({
    super.key,
    required this.onBack,
    this.completedCount = 4,
    this.pendingCount = 1,
    this.initialNote,
    this.onSaveNote,
  });

  @override
  State<NightReviewScreen> createState() => _NightReviewScreenState();
}

class _NightReviewScreenState extends State<NightReviewScreen> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: widget.initialNote ??
          'Today was productive! Alhamdu Lillah completed my core study goals and had a refreshing evening walk.',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveReview() {
    final note = _noteController.text.trim();
    widget.onSaveNote?.call(note);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Night Review saved for today 🌙'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: const Row(
          children: [
            Icon(Icons.nightlight_round, color: AppColors.primaryBlue, size: 20),
            SizedBox(width: 8),
            Text('Night Review'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          children: [
            // Crescent Moon Illustration Header
            Center(
              child: SvgPicture.asset(
                AssetPaths.moonCloud,
                width: 110,
                height: 85,
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: Text(
                'How was your day?',
                style: AppTypography.heading1.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                todayStr,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Two Summary Cards: Completed & Pending
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.doneGreenLight,
                      borderRadius: AppTheme.cardBorderRadius,
                      border: Border.all(
                        color: AppColors.doneGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.doneGreen,
                          size: 26,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.completedCount} Completed',
                          style: AppTypography.heading3.copyWith(
                            color: AppColors.doneGreenDark,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Great momentum!',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.doneGreenDark.withValues(alpha: 0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.dueRedLight,
                      borderRadius: AppTheme.cardBorderRadius,
                      border: Border.all(
                        color: AppColors.dueRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.pending_actions_rounded,
                          color: AppColors.dueRed,
                          size: 26,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.pendingCount} Pending',
                          style: AppTypography.heading3.copyWith(
                            color: AppColors.dueRedDark,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Can do tomorrow',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.dueRedDark.withValues(alpha: 0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Note Section
            const Text(
              'What did you do today?',
              style: AppTypography.heading3,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
                border: Border.all(
                  color: AppColors.borderSubtle.withValues(alpha: 0.8),
                ),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts, reflections and gratitude here...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save My Day Button
            AppPrimaryButton(
              label: 'Save My Day',
              icon: Icons.bookmark_added_rounded,
              onPressed: _saveReview,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
