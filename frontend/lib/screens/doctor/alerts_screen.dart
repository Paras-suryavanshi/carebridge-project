import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'patient': 'Margaret Chen',
      'type': 'Critical',
      'message': 'Abnormal heart rate detected: 135 bpm',
      'time': '5 min ago',
      'isRead': false,
      'icon': Icons.favorite,
      'color': AppColors.error,
    },
    {
      'patient': 'Robert Williams',
      'type': 'High',
      'message': 'Blood pressure elevated: 150/95 mmHg',
      'time': '15 min ago',
      'isRead': false,
      'icon': Icons.bloodtype,
      'color': AppColors.warning,
    },
    {
      'patient': 'Emily Davis',
      'type': 'Critical',
      'message': 'Missed medication: Lisinopril 10mg',
      'time': '1 hour ago',
      'isRead': true,
      'icon': Icons.medication,
      'color': AppColors.error,
    },
    {
      'patient': 'James Thompson',
      'type': 'Medium',
      'message': 'Low activity level today: 1,200 steps',
      'time': '2 hours ago',
      'isRead': true,
      'icon': Icons.directions_walk,
      'color': AppColors.info,
    },
    {
      'patient': 'Sarah Martinez',
      'type': 'High',
      'message': 'Temperature spike: 101.2°F',
      'time': '3 hours ago',
      'isRead': true,
      'icon': Icons.thermostat,
      'color': AppColors.warning,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _alerts.where((a) => !a['isRead']).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              AppStrings.alerts,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                for (var alert in _alerts) {
                  alert['isRead'] = true;
                }
              });
            },
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text('Mark All Read'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Critical',
                      '${_alerts.where((a) => a['type'] == 'Critical').length}',
                      AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'High',
                      '${_alerts.where((a) => a['type'] == 'High').length}',
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Medium',
                      '${_alerts.where((a) => a['type'] == 'Medium').length}',
                      AppColors.info,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Alerts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 50 * index),
                  child: _buildAlertCard(_alerts[index], index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildAlertCard(Map<String, dynamic> alert, int index) {
    final isUnread = !alert['isRead'];

    return Dismissible(
      key: Key('alert_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _alerts.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alert dismissed'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: isUnread
              ? Border.all(color: alert['color'].withOpacity(0.3), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                alert['isRead'] = true;
              });
              _showAlertDetails(alert);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: alert['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(alert['icon'], color: alert['color'], size: 24),
                  ),
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert['patient'],
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
                                color: alert['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                alert['type'],
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: alert['color'],
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alert['message'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: isUnread ? FontWeight.w600 : null,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alert['time'],
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textLight),
                            ),
                            if (isUnread) ...[
                              const SizedBox(width: 12),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textLight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: alert['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(alert['icon'], color: alert['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['patient'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        alert['time'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              alert['message'],
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.call),
                    label: const Text('Call Patient'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.assignment),
                    label: const Text('View Records'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
