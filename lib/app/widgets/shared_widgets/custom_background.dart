import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool showIcons;
  final double iconOpacity;

  const CustomBackground({
    super.key,
    required this.child,
    this.backgroundColor,
    this.showIcons = true,
    this.iconOpacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade50,
                  Colors.white,
                ],
              ),
            ),
            child: showIcons ? _buildBackgroundIcons() : null,
          ),
        ),
        SafeArea(
          child: RepaintBoundary(
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundIcons() => Opacity(
        opacity: iconOpacity,
        child: Stack(
          children: const [
            Positioned(
              top: 50,
              left: 20,
              child: Icon(Icons.local_taxi_rounded, size: 80, color: Colors.blueAccent),
            ),
            Positioned(
              top: 150,
              right: 30,
              child: Icon(Icons.access_time_filled_rounded, size: 60, color: Colors.blue),
            ),
            Positioned(
              bottom: 120,
              left: 40,
              child: Icon(Icons.hotel_rounded, size: 70, color: Colors.lightBlue),
            ),
            Positioned(
              bottom: 200,
              right: 50,
              child: Icon(Icons.face_rounded, size: 80, color: Colors.blueGrey),
            ),
            Positioned(
              top: 300,
              left: 200,
              child: Icon(Icons.notifications_active_rounded, size: 50, color: Colors.blueAccent),
            ),
          ],
        ),
      );
}