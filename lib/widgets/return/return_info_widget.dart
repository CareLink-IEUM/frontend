import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';

class ReturnInfoWidget extends StatelessWidget {
  final String title;
  final List<String>? warnings; // ! 경고 문구
  final List<String>? guides;   // [ 가이드 ] 문구
  final VoidCallback? onTap;

  const ReturnInfoWidget({
    super.key,
    required this.title,
    this.warnings,
    this.guides,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          // 1. 메인 화면의 분위기를 잇는 화이트 배경과 둥근 모서리
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          // 2. 투박한 테두리 대신 은은한 그림자 효과
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Pretendard-Bold',
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (warnings != null && warnings!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          ...warnings!.map((msg) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  msg,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard-Medium',
                                    fontSize: 14,
                                    color: AppColors.hanwhaOrange,
                                  ),
                                ),
                              )),
                        ],
                        // 가이드 문구 스타일링
                        if (guides != null && guides!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ...guides!.map((msg) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  msg,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard-Regular',
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                  // 3. 우측 화살표 아이콘
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.hanwhaOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.hanwhaOrange,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}