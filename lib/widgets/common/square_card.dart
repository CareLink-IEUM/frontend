import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';

class SquareCard extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color fontColor;
  final Widget? icon;

  // 생성자 이름을 클래스 이름과 일치시킴
  const SquareCard({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.fontColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
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
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard-SemiBold',
              fontSize: 18,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }
}