import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'sidebar_widget.dart';

/// Top-level layout shell with the persistent left vertical sidebar.
class AppShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget child;
  final bool isUser2Locked;

  const AppShell({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.child,
    this.isUser2Locked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGradientStart,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageBackgroundGradient,
        ),
        child: Row(
          children: [
            // Left persistent navigation sidebar
            SidebarWidget(
              selectedIndex: selectedIndex,
              onItemSelected: onItemSelected,
              isUser2Locked: isUser2Locked,
            ),

            // Content area
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
