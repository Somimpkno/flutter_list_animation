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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom Animated Background
        AnimatedBackground(scrollPosition: _scrollPosition),
        ListView.builder(
          controller: _scrollController,
          itemCount: 20,
          itemBuilder: (context, index) {
            double currentPosition = (_scrollPosition - (index * 150)).abs();
            double scaleFactor = max(0.6, 1 - (currentPosition / 400));
            double rotationAngle = (currentPosition / 500) * pi / 10; // Rotation effect
            bool isFocused = currentPosition < 150; // Glow for focused item

            return Transform.scale(
              scale: scaleFactor,
              child: Transform.rotate(
                angle: rotationAngle,
                child: GestureDetector(
                  onTap: () {
                    // Ripple Effect Placeholder
                    print("Tapped on Item $index");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.primaries[index % Colors.primaries.length],
                          Colors.primaries[(index + 1) %
                              Colors.primaries.length].withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: Colors.yellowAccent.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 10),
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
            );
          },
        ),
      ],
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  final double scrollPosition;

  const AnimatedBackground({required this.scrollPosition});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.blue.withOpacity(0.4),
              Colors.purple.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
            stops: [
              0.4,
              0.7,
              1.0,
            ],
            center: Alignment(
                sin(scrollPosition / 500), cos(scrollPosition / 500)),
            radius: 1.5,
          ),
        ),
      ),
    );
  }
}
