import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/patient_model.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final List<PatientModel> _patients = PatientModel.samplePatients;
  String _searchQuery = '';

  List<PatientModel> get _filteredPatients {
    if (_searchQuery.isEmpty) return _patients;
    return _patients
        .where(
          (p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.condition.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.patients,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search patients...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
            ),
          ),

          // Patient Stats
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: AppColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatChip(
                      'Total',
                      '${_patients.length}',
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatChip(
                      'Critical',
                      '${_patients.where((p) => p.status == 'Critical').length}',
                      AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatChip(
                      'Stable',
                      '${_patients.where((p) => p.status == 'Stable').length}',
                      AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Patients Table
          Expanded(
            child: _filteredPatients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No patients found',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: Duration(milliseconds: 50 * index),
                        child: _buildPatientCard(_filteredPatients[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(PatientModel patient) {
    final statusColor = patient.status == 'Critical'
        ? AppColors.error
        : patient.status == 'Stable'
            ? AppColors.success
            : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      patient.initials,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            patient.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              patient.status,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient.age} years • ${patient.condition}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            patient.moodIcon,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Last updated: ${patient.lastUpdate}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    _showPatientActions(patient);
                  },
                ),
              ],
            ),
          ),

          // Vitals
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildVitalChip(
                    Icons.favorite,
                    'Heart',
                    '${patient.heartRate} bpm',
                    AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVitalChip(
                    Icons.thermostat,
                    'Temp',
                    '${patient.temperature}°F',
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVitalChip(
                    Icons.bloodtype,
                    'BP',
                    patient.bloodPressure,
                    AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPatientActions(PatientModel patient) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.call, color: AppColors.primary),
              title: const Text('Call Patient'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.message, color: AppColors.info),
              title: const Text('Send Message'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: AppColors.warning),
              title: const Text('View Records'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
