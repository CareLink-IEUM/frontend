import 'package:flutter/material.dart';

class SquareCard extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color fontColor;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;

  const SquareCard({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.fontColor,
    required this.icon,
    required this.iconColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard-SemiBold',
              fontSize: 16,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }
}