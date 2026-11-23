import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppIconItem {
  final String key;
  final String name;
  final IconData icon;
  final Color bg;
  final Color fg;

  const AppIconItem({
    required this.key,
    required this.name,
    required this.icon,
    required this.bg,
    required this.fg,
  });
}

class AppIcons {
  AppIcons._();

  static const List<AppIconItem> primaryIcons = [
    AppIconItem(
      key: 'book',
      name: 'Book',
      icon: Icons.menu_book_rounded,
      bg: AppColors.pastelBlue,
      fg: AppColors.iconBlue,
    ),
    AppIconItem(
      key: 'laptop',
      name: 'Laptop',
      icon: Icons.laptop_mac_rounded,
      bg: AppColors.pastelGreen,
      fg: AppColors.iconGreen,
    ),
    AppIconItem(
      key: 'dumbbell',
      name: 'Gym',
      icon: Icons.fitness_center_rounded,
      bg: AppColors.pastelOrange,
      fg: AppColors.iconOrange,
    ),
    AppIconItem(
      key: 'plant',
      name: 'Plant',
      icon: Icons.eco_rounded,
      bg: AppColors.pastelGreen,
      fg: AppColors.iconGreen,
    ),
    AppIconItem(
      key: 'cup',
      name: 'Cup',
      icon: Icons.local_cafe_rounded,
      bg: AppColors.pastelPurple,
      fg: AppColors.iconPurple,
    ),
    AppIconItem(
      key: 'broom',
      name: 'Broom',
      icon: Icons.cleaning_services_rounded,
      bg: AppColors.pastelYellow,
      fg: AppColors.iconYellow,
    ),
    AppIconItem(
      key: 'mosque',
      name: 'Prayer',
      icon: Icons.mosque_rounded,
      bg: AppColors.pastelTeal,
      fg: AppColors.iconTeal,
    ),
    AppIconItem(
      key: 'pencil',
      name: 'Pencil',
      icon: Icons.edit_note_rounded,
      bg: AppColors.pastelPink,
      fg: AppColors.iconPink,
    ),
    AppIconItem(
      key: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      bg: AppColors.pastelCoral,
      fg: AppColors.iconCoral,
    ),
    AppIconItem(
      key: 'moon',
      name: 'Sleep',
      icon: Icons.nightlight_round,
      bg: AppColors.pastelPurple,
      fg: AppColors.iconPurple,
    ),
    AppIconItem(
      key: 'music',
      name: 'Music',
      icon: Icons.music_note_rounded,
      bg: AppColors.pastelPink,
      fg: AppColors.iconPink,
    ),
  ];

  static const List<AppIconItem> extendedIcons = [
    ...primaryIcons,
    AppIconItem(
      key: 'phone',
      name: 'Call',
      icon: Icons.phone_rounded,
      bg: AppColors.pastelBlue,
      fg: AppColors.iconBlue,
    ),
    AppIconItem(
      key: 'run',
      name: 'Run',
      icon: Icons.directions_run_rounded,
      bg: AppColors.pastelOrange,
      fg: AppColors.iconOrange,
    ),
    AppIconItem(
      key: 'food',
      name: 'Food',
      icon: Icons.restaurant_rounded,
      bg: AppColors.pastelOrange,
      fg: AppColors.iconOrange,
    ),
    AppIconItem(
      key: 'water',
      name: 'Water',
      icon: Icons.water_drop_rounded,
      bg: AppColors.pastelBlue,
      fg: AppColors.iconBlue,
    ),
    AppIconItem(
      key: 'heart',
      name: 'Health',
      icon: Icons.favorite_rounded,
      bg: AppColors.pastelPink,
      fg: AppColors.iconPink,
    ),
    AppIconItem(
      key: 'star',
      name: 'Goal',
      icon: Icons.star_rounded,
      bg: AppColors.pastelYellow,
      fg: AppColors.iconYellow,
    ),
    AppIconItem(
      key: 'walk',
      name: 'Walk',
      icon: Icons.directions_walk_rounded,
      bg: AppColors.pastelGreen,
      fg: AppColors.iconGreen,
    ),
    AppIconItem(
      key: 'code',
      name: 'Code',
      icon: Icons.code_rounded,
      bg: AppColors.pastelBlue,
      fg: AppColors.iconBlue,
    ),
  ];

  static AppIconItem getByKey(String key) {
    return extendedIcons.firstWhere(
      (item) => item.key == key,
      orElse: () => primaryIcons.first,
    );
  }
}
