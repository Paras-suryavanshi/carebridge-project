import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _voiceAlertsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.settings,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'john.doe@example.com',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.white),
                      onPressed: () {
                        // TODO: Edit profile
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Settings Sections
            _buildSectionTitle('Notifications'),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 100),
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Receive health updates and reminders',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    icon: Icons.volume_up_outlined,
                    title: 'Voice Alerts',
                    subtitle: 'Enable voice notifications',
                    value: _voiceAlertsEnabled,
                    onChanged: (value) {
                      setState(() => _voiceAlertsEnabled = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Appearance'),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() => _darkModeEnabled = value);
                },
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Account'),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: Change password
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // TODO: Show privacy policy
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // TODO: Show help
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // App Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/landing', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}