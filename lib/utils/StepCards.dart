import 'package:flutter/material.dart';

class StepCards extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
  final Color iconBackgroundColor;
  final String text;
  final Color textColor;

  const StepCards({
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.iconBackgroundColor,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBackgroundColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: iconBackgroundColor, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
