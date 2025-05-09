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
        Container(
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
        ),
        if (showIcons) _buildBackgroundIcons(),
        SafeArea(child: child),
      ],
    );
  }

  Widget _buildBackgroundIcons() {
    return Opacity(
      opacity: iconOpacity,
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: Icon(
              Icons.local_taxi_rounded,
              size: 80,
              color: Colors.blue.shade200,
            ),
          ),
          Positioned(
            top: 150,
            right: 30,
            child: Icon(
              Icons.access_time_filled_rounded,
              size: 60,
              color: Colors.blue.shade300,
            ),
          ),
          Positioned(
            bottom: 120,
            left: 40,
            child: Icon(
              Icons.hotel_rounded,
              size: 70,
              color: Colors.blue.shade200,
            ),
          ),
          Positioned(
            bottom: 200,
            right: 50,
            child: Icon(
              Icons.face_rounded,
              size: 80,
              color: Colors.blue.shade300,
            ),
          ),
          Positioned(
            top: 300,
            left: 200,
            child: Icon(
              Icons.notifications_active_rounded,
              size: 50,
              color: Colors.blue.shade200,
            ),
          ),
        ],
      ),
    );
  }
}