import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core/constants/asset_paths.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';

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
      home: const Phase0TestScreen(),
    );
  }
}

/// Simple elegant test & splash screen proving the Phase 0 setup:
/// - Theme colors, soft shadows, rounded shapes
/// - Bundled typography (GreatVibes script, Nunito UI sans, Noto Naskh Arabic)
/// - SVG illustrations (flower sprig, sun/cloud, delicate logo floral)
/// - UI components (pastel icon tiles, pill buttons, status indicators)
class Phase0TestScreen extends StatelessWidget {
  const Phase0TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageBackgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative flower sprig at bottom-left (matching sidebar design)
              Positioned(
                bottom: 12,
                left: 12,
                child: Opacity(
                  opacity: 0.85,
                  child: SvgPicture.asset(
                    AssetPaths.flowerSprig,
                    width: 72,
                    height: 86,
                  ),
                ),
              ),

              // Sun & Cloud illustration at top-right
              Positioned(
                top: 16,
                right: 20,
                child: SvgPicture.asset(
                  AssetPaths.sunCloud,
                  width: 68,
                  height: 54,
                ),
              ),

              // Main content
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Savaira Logo Section
                      SvgPicture.asset(
                        AssetPaths.logoFlower,
                        width: 32,
                        height: 24,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Savaira',
                        style: AppTypography.logoScript,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 1.2,
                            color: AppColors.primaryBlue.withValues(alpha: 0.4),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.favorite,
                              size: 13,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 1.2,
                            color: AppColors.primaryBlue.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Private Daily Planner',
                        style: AppTypography.caption.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Phase 0 Verification Card
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: AppTheme.cardBorderRadius,
                          boxShadow: AppTheme.cardShadow,
                          border: Border.all(
                            color: AppColors.borderSubtle.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.doneGreenLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 14,
                                        color: AppColors.doneGreen,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Phase 0 Ready',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.doneGreenDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'v1.0.0 (com.savaira.app)',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'System Setup Complete',
                              style: AppTypography.heading3,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Theme tokens, bundled offline fonts, SVG illustrations, Riverpod state, and clean architecture packages are initialized.',
                              style: AppTypography.bodyMuted,
                            ),
                            const SizedBox(height: 20),

                            // Color Palette & Icon Tile Showcase
                            const Text(
                              'Sample Pastel Icon Tiles',
                              style: AppTypography.caption,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildIconTile(
                                  icon: Icons.menu_book_rounded,
                                  bg: AppColors.pastelBlue,
                                  fg: AppColors.iconBlue,
                                  label: 'Read',
                                ),
                                _buildIconTile(
                                  icon: Icons.laptop_mac_rounded,
                                  bg: AppColors.pastelGreen,
                                  fg: AppColors.iconGreen,
                                  label: 'Code',
                                ),
                                _buildIconTile(
                                  icon: Icons.fitness_center_rounded,
                                  bg: AppColors.pastelOrange,
                                  fg: AppColors.iconOrange,
                                  label: 'Gym',
                                ),
                                _buildIconTile(
                                  icon: Icons.local_cafe_rounded,
                                  bg: AppColors.pastelPurple,
                                  fg: AppColors.iconPurple,
                                  label: 'Tea',
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // Arabic Font Test
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlueLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    'اللهم تقبل منا',
                                    style: AppTypography.arabicDua,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    'May Allah accept our prayers',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Pill button test
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryButtonGradient,
                          borderRadius: AppTheme.pillBorderRadius,
                          boxShadow: AppTheme.buttonShadow,
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.pillBorderRadius,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Phase 0 Verified',
                                style: AppTypography.buttonPrimary,
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildIconTile({
    required IconData icon,
    required Color bg,
    required Color fg,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppTheme.tileBorderRadius,
          ),
          child: Icon(icon, color: fg, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
