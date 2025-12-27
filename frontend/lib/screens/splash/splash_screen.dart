import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartbeatController;

  @override
  void initState() {
    super.initState();

    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Navigate to landing page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.landing);
    });
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Heartbeat Logo
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                    CurvedAnimation(
                      parent: _heartbeatController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    width: AppDimensions.logoSize,
                    height: AppDimensions.logoSize,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowMedium,
                          blurRadius: 30,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceLarge),

              // App Name
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceSmall),

              // Tagline
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
                child: Text(
                  AppStrings.appTagline,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXXLarge),

              // Loading Indicator
              FadeIn(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: AppDimensions.spaceMedium),
                    Text(
                      AppStrings.loading,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
