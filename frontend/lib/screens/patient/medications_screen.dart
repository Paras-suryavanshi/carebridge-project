import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/medication_model.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final List<MedicationModel> _medications = MedicationModel.sampleMedications;

  void _toggleMedication(int index) {
    setState(() {
      _medications[index] = MedicationModel(
        id: _medications[index].id,
        name: _medications[index].name,
        dosage: _medications[index].dosage,
        frequency: _medications[index].frequency,
        time: _medications[index].time,
        isTaken: !_medications[index].isTaken,
        color: _medications[index].color,
        notes: _medications[index].notes,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _medications[index].isTaken
              ? '${_medications[index].name} marked as taken'
              : '${_medications[index].name} marked as not taken',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final takenCount = _medications.where((m) => m.isTaken).length;
    final totalCount = _medications.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.myMedications,
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
            // Progress Card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.medication,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Progress',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$takenCount of $totalCount medications taken',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: takenCount / totalCount,
                        backgroundColor: AppColors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Medications List
            Text(
              'Your Medications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 100 * index),
                  child: _buildMedicationCard(_medications[index], index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(MedicationModel medication, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: medication.isTaken
              ? AppColors.success.withOpacity(0.3)
              : AppColors.border,
          width: medication.isTaken ? 2 : 1,
        ),
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
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: medication.isTaken
                  ? AppColors.successGradient
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              medication.isTaken ? Icons.check_circle : Icons.medication,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Medication Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        decoration: medication.isTaken
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  medication.dosage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
                      medication.frequency,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mark Taken Button
          ElevatedButton(
            onPressed: () => _toggleMedication(index),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  medication.isTaken ? AppColors.success : AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              medication.isTaken ? 'Taken' : AppStrings.markTaken,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
