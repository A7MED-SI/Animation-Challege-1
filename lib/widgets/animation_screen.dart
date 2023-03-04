import 'package:animation_challenge_1/clippers/half_circle_clipper.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController rotatingController;
  late Animation<double> rotatingAnimation;
  late AnimationController flippingController;
  late Animation<double> flippingAnimation;
  double startRotationAngle = 0;
  double startFlippingAngle = 0;

  @override
  void initState() {
    rotatingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    rotatingAnimation = Tween<double>(begin: 0, end: -pi / 2).animate(
        CurvedAnimation(parent: rotatingController, curve: Curves.bounceOut));
    flippingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    flippingAnimation = Tween<double>(begin: 0, end: -pi).animate(
        CurvedAnimation(parent: flippingController, curve: Curves.bounceOut));
    rotatingController.addListener(() {
      if (rotatingController.isCompleted) {
        startRotationAngle -= pi / 2;
        flippingController.stop();
        flippingAnimation = Tween<double>(
                begin: startFlippingAngle, end: startFlippingAngle - pi)
            .animate(CurvedAnimation(
                parent: flippingController, curve: Curves.bounceOut));
        flippingController.reset();
        flippingController.forward();
      }
    });
    flippingController.addListener(() {
      if (flippingController.isCompleted) {
        startFlippingAngle -= pi;
        rotatingController.stop();
        rotatingAnimation = Tween<double>(
                begin: startRotationAngle, end: startRotationAngle - pi / 2)
            .animate(CurvedAnimation(
                parent: rotatingController, curve: Curves.bounceOut));
        rotatingController.reset();
        rotatingController.forward();
      }
    });
    rotatingController.forward();
    super.initState();
  }

  @override
  void dispose() {
    rotatingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: AnimatedBuilder(
            animation: flippingAnimation,
            builder: (context, _) {
              return AnimatedBuilder(
                animation: rotatingAnimation,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..rotateZ(rotatingAnimation.value),
                    alignment: Alignment.center,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..rotateY(flippingAnimation.value),
                      alignment: Alignment.center,
                      child: child,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipPath(
                      clipper: HalfCircleClipper(HalfCircleSide.left),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                    ClipPath(
                      clipper: HalfCircleClipper(HalfCircleSide.right),
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
