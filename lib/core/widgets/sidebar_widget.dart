import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/asset_paths.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isUser2Locked;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isUser2Locked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(
          right: BorderSide(
            color: AppColors.borderSubtle.withValues(alpha: 0.7),
            width: 1.2,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x061F2A44),
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Top: "Savaira" Logo Section
            SvgPicture.asset(
              AssetPaths.logoFlower,
              width: 22,
              height: 18,
            ),
            const SizedBox(height: 2),
            Text(
              'Savaira',
              style: AppTypography.logoScript.copyWith(
                fontSize: 20,
                color: AppColors.primaryBlue,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 1,
                  color: AppColors.primaryBlue.withValues(alpha: 0.4),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Icon(
                    Icons.favorite,
                    size: 9,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Container(
                  width: 10,
                  height: 1,
                  color: AppColors.primaryBlue.withValues(alpha: 0.4),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4 Navigation Items
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildNavItem(
                      index: 0,
                      label: 'Today',
                      icon: Icons.home_rounded,
                      activeColor: AppColors.primaryBlue,
                      inactiveColor: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 16),
                    _buildNavItem(
                      index: 1,
                      label: 'Goals',
                      icon: Icons.track_changes_rounded,
                      activeColor: AppColors.primaryBlue,
                      inactiveColor: AppColors.doneGreen,
                    ),
                    const SizedBox(height: 16),
                    _buildNavItem(
                      index: 2,
                      label: 'Namaz',
                      icon: Icons.mosque_rounded,
                      activeColor: AppColors.primaryBlue,
                      inactiveColor: AppColors.primaryBlueDark,
                    ),
                    const SizedBox(height: 16),
                    _buildNavItem(
                      index: 3,
                      label: 'User 2',
                      icon: Icons.people_alt_rounded,
                      activeColor: AppColors.primaryBlue,
                      inactiveColor: AppColors.user2Pink,
                      hasLock: isUser2Locked,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom: Flower Illustration at bottom-left of sidebar
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 6),
              child: Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  AssetPaths.flowerSprig,
                  width: 58,
                  height: 70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required Color activeColor,
    required Color inactiveColor,
    bool hasLock = false,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 62,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: AppTheme.pillBorderRadius,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : inactiveColor,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.fontUi,
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textNavy,
                    ),
                  ),
                ),
                if (hasLock && !isSelected) ...[
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.lock_rounded,
                    size: 9,
                    color: AppColors.textLight,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
