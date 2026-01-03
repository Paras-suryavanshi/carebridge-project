import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http; // <--- Added for API
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../config/routes.dart';
import '../../widgets/profile_menu.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;

  // --- NEW STATE VARIABLES FOR AI SUMMARY ---
  bool _isLoadingSummary = true;
  String _summary = "Loading patient data...";
  String _lastUpdated = "";

  @override
  void initState() {
    super.initState();
    _fetchClinicalSummary(); // <--- Fetch data when screen loads
  }

  // --- NEW FUNCTION TO FETCH SUMMARY ---
  Future<void> _fetchClinicalSummary() async {
    try {
      // Use 127.0.0.1 for Web, 10.0.2.2 for Android Emulator
      final response = await http.get(
        Uri.parse('https://carebridge-backend-42d7.onrender.com/api/communication/summary/1/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _summary = data['summary'];
            _lastUpdated = DateTime.now().toString().substring(0, 16);
            _isLoadingSummary = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _summary = "No recent patient activity to summarize.";
            _isLoadingSummary = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _summary = "System Notice: Unable to connect to Care AI server.";
          _isLoadingSummary = false;
        });
      }
    }
  }

  void _onMenuItemTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0: break;
      case 1: Navigator.pushNamed(context, AppRoutes.doctorPatients); break;
      case 2: Navigator.pushNamed(context, AppRoutes.callLogs); break;
      case 3: Navigator.pushNamed(context, AppRoutes.analytics); break;
      case 4: Navigator.pushNamed(context, AppRoutes.alerts); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.welcomeDoctor,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.monitorPatients,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
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
                      userName: 'Dr. Sarah Johnson',
                      userRole: 'Doctor - Cardiology',
                      userEmail: 'sarah.johnson@carebridge.com',
                      userPhone: '+1 234 567 8900',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Metrics Grid
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMetricCard(
                      icon: Icons.phone,
                      title: AppStrings.totalCallsToday,
                      value: '24',
                      color: AppColors.primary,
                    ),
                    _buildMetricCard(
                      icon: Icons.people,
                      title: AppStrings.patientsMonitored,
                      value: '156',
                      color: AppColors.info,
                    ),
                    _buildMetricCard(
                      icon: Icons.warning,
                      title: AppStrings.criticalAlerts,
                      value: '3',
                      color: AppColors.error,
                    ),
                    _buildMetricCard(
                      icon: Icons.star,
                      title: AppStrings.patientSatisfaction,
                      value: '4.8',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- NEW AI SUMMARY CARD SECTION ---
              FadeInUp(
                 duration: const Duration(milliseconds: 600),
                 delay: const Duration(milliseconds: 300),
                 child: _buildSummaryCard(),
              ),
              const SizedBox(height: 32),

              // Charts Row
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    _buildCallsChart(),
                    const SizedBox(height: 16),
                    _buildAlertsChart(),
                  ],
                ),
              ),
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- NEW WIDGET: AI SUMMARY CARD ---
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05), 
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Patient Focus: John Doe (ID #001)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              if (_isLoadingSummary) 
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
          const Divider(height: 30),
          Text(
            _summary,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _lastUpdated.isEmpty ? "" : "Generated at $_lastUpdated",
            style: TextStyle(color: Colors.grey[400], fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ... (Keep existing _buildBottomNavigationBar, _buildNavItem, _buildMetricCard, etc.) ...
  
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
              _buildNavItem(icon: Icons.people, label: 'Patients', index: 1),
              _buildNavItem(icon: Icons.call, label: 'Calls', index: 2),
              _buildNavItem(icon: Icons.analytics, label: 'Analytics', index: 3),
              _buildNavItem(icon: Icons.notifications, label: 'Alerts', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onMenuItemTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Calls',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5),
                      FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 5.5),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alert Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(color: AppColors.error, value: 30, title: '30%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white)),
                  PieChartSectionData(color: AppColors.warning, value: 50, title: '50%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white)),
                  PieChartSectionData(color: AppColors.success, value: 20, title: '20%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}