import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  const HeaderWidget({super.key, this.title = 'Tips de Descanso'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}