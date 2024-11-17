import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnimatedScrollEffect(),
      ),
    );
  }
}

class AnimatedScrollEffect extends StatefulWidget {
  @override
  _AnimatedScrollEffectState createState() => _AnimatedScrollEffectState();
}

class _AnimatedScrollEffectState extends State<AnimatedScrollEffect>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Smooth animation duration
    );

    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });

      // Trigger animation
      if (!_animationController.isAnimating) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 20,
      itemBuilder: (context, index) {
        double currentPosition = (_scrollPosition - (index * 150)).abs();
        double scaleFactor = max(0.6, 1 - (currentPosition / 400));

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            double fadeEffect = max(0.3, 1 - (currentPosition / 500));
            return Opacity(
              opacity: fadeEffect,
              child: Transform.scale(
                scale: scaleFactor,
                child: Transform.translate(
                  offset: Offset(0, sin(currentPosition / 300) * 20), // Adds depth
                  child: RepaintBoundary(
                    child: ClipPath(
                      clipper: DynamicStickClipper(currentPosition),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors
                              .primaries[index % Colors.primaries.length]
                              .withOpacity(fadeEffect),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: Offset(0, 10), // Adds depth shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Item $index',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DynamicStickClipper extends CustomClipper<Path> {
  final double position;

  DynamicStickClipper(this.position);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = min(size.height / 2, position / 4);
    double curveIntensity = sin(position / 300) * 20;

    path.lineTo(0, size.height - curveHeight);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + curveHeight + curveIntensity,
      size.width,
      size.height - curveHeight,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
