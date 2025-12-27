import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({super.key});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  final List<Map<String, dynamic>> _callLogs = [
    {
      'patient': 'Margaret Chen',
      'duration': '15:32',
      'time': '10:30 AM',
      'date': 'Today',
      'status': 'Completed',
      'type': 'Video',
      'notes': 'Routine checkup. Patient reported feeling better.',
    },
    {
      'patient': 'Robert Williams',
      'duration': '8:45',
      'time': '09:15 AM',
      'date': 'Today',
      'status': 'Completed',
      'type': 'Audio',
      'notes': 'Medication adjustment discussed.',
    },
    {
      'patient': 'Emily Davis',
      'duration': '12:20',
      'time': '4:30 PM',
      'date': 'Yesterday',
      'status': 'Completed',
      'type': 'Video',
      'notes': 'Follow-up on recent symptoms.',
    },
    {
      'patient': 'James Thompson',
      'duration': '0:00',
      'time': '2:15 PM',
      'date': 'Yesterday',
      'status': 'Missed',
      'type': 'Video',
      'notes': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.callLogs,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: AppColors.textPrimary,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Row
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.call_made,
                      label: 'Today',
                      value:
                          '${_callLogs.where((c) => c['date'] == 'Today').length}',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.access_time,
                      label: 'Total Time',
                      value: '36m',
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.call_missed,
                      label: 'Missed',
                      value:
                          '${_callLogs.where((c) => c['status'] == 'Missed').length}',
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Call Logs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _callLogs.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 50 * index),
                  child: _buildCallLogCard(_callLogs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCallLogCard(Map<String, dynamic> call) {
    final isMissed = call['status'] == 'Missed';
    final statusColor = isMissed ? AppColors.error : AppColors.success;
    final callIcon = call['type'] == 'Video' ? Icons.videocam : Icons.phone;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isMissed
            ? Border.all(color: AppColors.error.withOpacity(0.3))
            : null,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Call Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(callIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),

                // Call Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              call['patient'],
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
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
                              call['status'],
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${call['date']} at ${call['time']}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          if (!isMissed) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.timer,
                              size: 14,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              call['duration'],
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                      if (call['notes'].isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.note,
                                size: 14,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  call['notes'],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          if (!isMissed)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text('Call Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.description, size: 18),
                      label: const Text('Transcript'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.info,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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
