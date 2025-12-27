import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../config/routes.dart';

/// Professional profile menu widget with avatar and detailed information
/// Displays user profile with elegant UI/UX design
class ProfileMenu extends StatelessWidget {
  final String userName;
  final String userRole;
  final String userEmail;
  final String? userPhone;
  final String? userImage;
  final VoidCallback? onLogout;

  const ProfileMenu({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userEmail,
    this.userPhone,
    this.userImage,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProfileDialog(context),
      child: Hero(
        tag: 'profile_avatar',
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _getGradientForRole(),
            border: Border.all(
              color: Colors.white,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _getInitials(userName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Get gradient based on user role for visual distinction
  LinearGradient _getGradientForRole() {
    if (userRole.toLowerCase().contains('doctor')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea), // Professional blue
          Color(0xFF764ba2), // Purple accent
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF11998e), // Teal
          Color(0xFF38ef7d), // Green accent
        ],
      );
    }
  }

  /// Extract initials from name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Show elegant profile dialog with user details
  void _showProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ProfileSheet(
        userName: userName,
        userRole: userRole,
        userEmail: userEmail,
        userPhone: userPhone,
        gradient: _getGradientForRole(),
        onLogout: onLogout,
      ),
    );
  }
}

/// Profile sheet with elegant design and smooth animations
class _ProfileSheet extends StatelessWidget {
  final String userName;
  final String userRole;
  final String userEmail;
  final String? userPhone;
  final LinearGradient gradient;
  final VoidCallback? onLogout;

  const _ProfileSheet({
    required this.userName,
    required this.userRole,
    required this.userEmail,
    this.userPhone,
    required this.gradient,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // Profile Header with Gradient Background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                // Large Avatar
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            gradient.createShader(bounds),
                        child: Text(
                          _getInitials(userName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // User Name
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // User Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getRoleIcon(),
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        userRole,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // User Details Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Email
                _DetailTile(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  value: userEmail,
                  iconColor: const Color(0xFF667eea),
                ),

                if (userPhone != null) ...[
                  const SizedBox(height: 12),
                  _DetailTile(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: userPhone!,
                    iconColor: const Color(0xFF11998e),
                  ),
                ],

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Edit Profile Button
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.edit_rounded,
                        label: 'Edit Profile',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to edit profile
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Logout Button
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.logout_rounded,
                        label: 'Logout',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showLogoutConfirmation(context);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon() {
    if (userRole.toLowerCase().contains('doctor')) {
      return Icons.medical_services_rounded;
    } else {
      return Icons.person_rounded;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onLogout != null) {
                onLogout!();
              } else {
                // Default logout - navigate to landing
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.landing,
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf5576c),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail tile for displaying user information
class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button with gradient background
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.colors[0].withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
