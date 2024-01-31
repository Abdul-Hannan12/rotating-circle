import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotating Circle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

enum CircleSide {
  left,
  right,
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    final path = Path();

    Offset offset = side == CircleSide.left
        ? Offset(size.width, size.height)
        : Offset(0, size.height);
    bool clockwise = side == CircleSide.left ? false : true;

    if (side == CircleSide.left) {
      path.moveTo(size.width, 0);
    }

    path.arcToPoint(
      offset,
      clockwise: clockwise,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationAnimationController;
  late Animation<double> _counterClockwiseRotationAnimation;
  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _counterClockwiseRotationAnimation =
        Tween<double>(begin: 0.0, end: -pi / 2).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationAnimationController,
        curve: Curves.bounceOut,
      ),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: pi * 2).animate(
      CurvedAnimation(
        parent: _flipAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    _counterClockwiseRotationAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipAnimationController,
            curve: Curves.bounceOut,
          ),
        );

        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value - pi / 2,
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationAnimationController,
            curve: Curves.bounceOut,
          ),
        );

        _counterClockwiseRotationAnimationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    _counterClockwiseRotationAnimationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));
    return Scaffold(
      backgroundColor: const Color(0xFF14342b),
      body: Center(
        child: AnimatedBuilder(
          animation: _counterClockwiseRotationAnimationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockwiseRotationAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                      animation: _flipAnimationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()
                            ..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(side: CircleSide.left),
                            child: Container(
                              width: size.width / 2,
                              height: size.width / 2,
                              color: const Color(0xFFeea243),
                            ),
                          ),
                        );
                      }),
                  AnimatedBuilder(
                      animation: _flipAnimationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(side: CircleSide.right),
                            child: Container(
                              width: size.width / 2,
                              height: size.width / 2,
                              color: const Color(0xFF3581b8),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
