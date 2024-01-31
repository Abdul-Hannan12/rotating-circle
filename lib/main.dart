import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFF14342b),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: HalfCircleClipper(side: CircleSide.left),
              child: Container(
                width: size.width / 2,
                height: size.width / 2,
                color: const Color(0xFFeea243),
              ),
            ),
            ClipPath(
              clipper: HalfCircleClipper(side: CircleSide.right),
              child: Container(
                width: size.width / 2,
                height: size.width / 2,
                color: const Color(0xFF3581b8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
