import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';

class LongBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;

  const LongBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Pretendard-Medium',
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard-Bold',
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}