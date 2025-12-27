import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(seconds: 20 + (index * 5)),
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Shape 1
          AnimatedBuilder(
            animation: _animations[0],
            builder: (context, child) {
              return Positioned(
                top: size.height * 0.1 + (_animations[0].value * 30),
                left: size.width * 0.1 + (_animations[0].value * 20),
                child: Transform.rotate(
                  angle: _animations[0].value * 2,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.lightBlue.withOpacity(0.1),
                          AppColors.lightBlue.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Shape 2
          AnimatedBuilder(
            animation: _animations[1],
            builder: (context, child) {
              return Positioned(
                top: size.height * 0.6 - (_animations[1].value * 20),
                right: size.width * 0.15 + (_animations[1].value * 15),
                child: Transform.rotate(
                  angle: -_animations[1].value * 2,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mutedGreen.withOpacity(0.1),
                          AppColors.mutedGreen.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Shape 3
          AnimatedBuilder(
            animation: _animations[2],
            builder: (context, child) {
              return Positioned(
                bottom: size.height * 0.2 + (_animations[2].value * 25),
                left: size.width * 0.2 - (_animations[2].value * 10),
                child: Transform.rotate(
                  angle: _animations[2].value * 1.5,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withOpacity(0.1),
                          AppColors.gold.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
