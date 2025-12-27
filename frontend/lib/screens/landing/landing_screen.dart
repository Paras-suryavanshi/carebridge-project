import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dimensions.dart';
import '../../widgets/common/animated_background.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          const AnimatedBackground(),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: size.height,
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with floating animation
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              -20 * _floatController.value,
                            ),
                            child: Stack(
                              children: [
                                // Animated glowing border
                                AnimatedBuilder(
                                  animation: _floatController,
                                  builder: (context, child) {
                                    return Container(
                                      width: AppDimensions.logoSizeLarge + 10,
                                      height: AppDimensions.logoSizeLarge + 10,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.gold.withOpacity(
                                                0.6 * _floatController.value),
                                            AppColors.lightBlue.withOpacity(
                                                0.6 * _floatController.value),
                                            AppColors.mutedGreen.withOpacity(
                                                0.6 * _floatController.value),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    );
                                  },
                                ),
                                // Main logo
                                Container(
                                  width: AppDimensions.logoSizeLarge,
                                  height: AppDimensions.logoSizeLarge,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowHeavy,
                                        blurRadius: 60,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 20),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: AppColors.white,
                                    size: 80,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spaceXXLarge),

                    // Title
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        AppStrings.appName,
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spaceSmall),

                    // Subtitle
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        AppStrings.landingSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spaceXXLarge),

                    // Role Cards
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 600),
                      child: Row(
                        children: [
                          // Patient Card
                          Expanded(
                            child: _RoleCard(
                              icon: '🫀',
                              title: AppStrings.patientRole,
                              description: AppStrings.patientDescription,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.pinkStart,
                                  AppColors.pinkEnd
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () {
                                AppRoutes.navigateToLogin(context,
                                    role: 'patient');
                              },
                            ),
                          ),

                          const SizedBox(width: AppDimensions.spaceLarge),

                          // Doctor Card
                          Expanded(
                            child: _RoleCard(
                              icon: '🩺',
                              title: AppStrings.doctorRole,
                              description: AppStrings.doctorDescription,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.tealStart,
                                  AppColors.tealEnd
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () {
                                AppRoutes.navigateToLogin(context,
                                    role: 'doctor');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Icon Container
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceMedium),

              // Title
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
              ),

              const SizedBox(height: AppDimensions.spaceSmall),

              // Description
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spaceMedium),

              // Arrow
              const Icon(
                Icons.arrow_forward,
                color: AppColors.accent,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
