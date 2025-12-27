import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../config/routes.dart';
import '../../models/vital_signs_model.dart';
import '../../widgets/profile_menu.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;
  final VitalSignsModel _vitalSigns = VitalSignsModel.defaultValues();

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.careAI);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.medications);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.health_and_safety,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.welcomeBack,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.healthOverview,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: AppColors.textPrimary,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    const ProfileMenu(
                      userName: 'John Doe',
                      userRole: 'Patient',
                      userEmail: 'john.doe@example.com',
                      userPhone: '+1 234 567 8900',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Health Metrics Grid
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildHealthCard(
                      icon: Icons.favorite,
                      title: AppStrings.heartRate,
                      value: '${_vitalSigns.heartRate}',
                      unit: 'bpm',
                      status: AppStrings.normal,
                      color: AppColors.error,
                      gradient: AppColors.errorGradient,
                    ),
                    _buildHealthCard(
                      icon: Icons.directions_walk,
                      title: AppStrings.stepsToday,
                      value: '${_vitalSigns.steps}',
                      unit: '',
                      status: AppStrings.good,
                      color: AppColors.primary,
                      gradient: AppColors.primaryGradient,
                    ),
                    _buildHealthCard(
                      icon: Icons.medication,
                      title: AppStrings.medicationsTaken,
                      value: '${_vitalSigns.medicationsTaken}',
                      unit: '/3',
                      status: AppStrings.onTrack,
                      color: AppColors.success,
                      gradient: AppColors.successGradient,
                    ),
                    _buildHealthCard(
                      icon: Icons.bedtime,
                      title: AppStrings.sleepLastNight,
                      value: '${_vitalSigns.sleep}',
                      unit: 'hrs',
                      status: AppStrings.good,
                      color: AppColors.info,
                      gradient: AppColors.infoGradient,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick Actions
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      icon: Icons.chat_bubble_outline,
                      title: 'Talk to Care AI',
                      subtitle: 'Get instant health advice',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.careAI),
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: Icons.info_outline,
                      title: 'About Carebridge',
                      subtitle: 'Learn more about our services',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.about),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Care AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined),
              activeIcon: Icon(Icons.medication),
              label: 'Medications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required String status,
    required Color color,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.white, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  if (unit.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        unit,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
