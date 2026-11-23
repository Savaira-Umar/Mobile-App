import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'icon_tile.dart';

/// Modal bottom sheet allowing selection from all available icons.
class IconPickerDialog extends StatelessWidget {
  final String selectedKey;
  final ValueChanged<AppIconItem> onSelect;

  const IconPickerDialog({
    super.key,
    required this.selectedKey,
    required this.onSelect,
  });

  static Future<AppIconItem?> show(BuildContext context, String currentKey) {
    return showModalBottomSheet<AppIconItem>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => IconPickerDialog(
        selectedKey: currentKey,
        onSelect: (item) => Navigator.pop(context, item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.circleOutline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose an Icon',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: AppIcons.extendedIcons.map((item) {
                final isSelected = item.key == selectedKey;
                return GestureDetector(
                  onTap: () => onSelect(item),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTile(
                        icon: item.icon,
                        backgroundColor: item.bg,
                        iconColor: item.fg,
                        size: 52,
                        iconSize: 24,
                        isSelected: isSelected,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.textNavy,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
