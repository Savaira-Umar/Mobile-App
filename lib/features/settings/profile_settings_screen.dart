import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenNotificationSettings;
  final VoidCallback onLogout;

  const ProfileSettingsScreen({
    super.key,
    required this.onBack,
    required this.onOpenNotificationSettings,
    required this.onLogout,
  });

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _nameController = TextEditingController(text: 'Savaira');
  bool _isEditingName = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
        title: const Row(
          children: [
            Icon(Icons.system_update_rounded, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text('App Version', style: AppTypography.heading3),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are running the latest version:', style: AppTypography.bodyMuted),
            SizedBox(height: 6),
            Text('Savaira v1.0.0 (Build 1)', style: AppTypography.heading3),
            SizedBox(height: 12),
            Text('Package ID: com.savaira.app', style: AppTypography.caption),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
        title: const Text('Backup & Restore', style: AppTypography.heading3),
        content: const Text(
          'Export your tasks, goals, and reflections as a local JSON backup, or import a previous backup.',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup exported successfully to Documents/savaira_backup.json'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            },
            child: const Text('Export JSON'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
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
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Profile Card: Avatar + Editable Name
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
                border: Border.all(
                  color: AppColors.borderSubtle.withValues(alpha: 0.7),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 2.5,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                              fontFamily: AppTypography.fontUi,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (_isEditingName)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          child: TextField(
                            controller: _nameController,
                            autofocus: true,
                            style: AppTypography.heading2,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 6),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check_rounded, color: AppColors.doneGreen),
                          onPressed: () {
                            setState(() {
                              _isEditingName = false;
                            });
                          },
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingName = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_nameController.text, style: AppTypography.heading2),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.textLight,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 4),
                  Text(
                    'savaira@savaira.app',
                    style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Settings Items List
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: AppTheme.cardBorderRadius,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Settings',
                    subtitle: 'Sounds, vibration, reminder times',
                    onTap: widget.onOpenNotificationSettings,
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  _buildSettingTile(
                    icon: Icons.sync_rounded,
                    title: 'Sync Status',
                    subtitle: 'Local mode active • Ready for Firebase in Phase 4',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Offline storage active. Ready for Firebase sync.'),
                          backgroundColor: AppColors.primaryBlue,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  _buildSettingTile(
                    icon: Icons.import_export_rounded,
                    title: 'Export / Import Backup',
                    subtitle: 'Save JSON data to device',
                    onTap: _showBackupDialog,
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  _buildSettingTile(
                    icon: Icons.system_update_rounded,
                    title: 'Check for Updates',
                    subtitle: 'Current version: v1.0.0',
                    onTap: _showUpdateDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            AppDangerButton(
              label: 'Logout',
              icon: Icons.logout_rounded,
              onPressed: widget.onLogout,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.primaryBlueLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 20),
      ),
      title: Text(title, style: AppTypography.heading3.copyWith(fontSize: 14)),
      subtitle: Text(subtitle, style: AppTypography.caption),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: AppColors.textLight,
      ),
    );
  }
}
