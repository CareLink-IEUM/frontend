import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';

class InsuranceCheckCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String amount;
  final bool isChecked;
  final VoidCallback? onTap;

  const InsuranceCheckCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.amount,
    this.isChecked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 체크 아이콘 (상태에 따라 색상 변경)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? AppColors.hanwhaOrange : const Color(0xFFE0E0E0),
              ),
              child: const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Pretendard-Bold',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontFamily: 'Pretendard-Regular',
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            // 금액 정보
            Text(
              amount,
              style: const TextStyle(
                fontFamily: 'Pretendard-SemiBold',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}