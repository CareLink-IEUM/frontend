// 임시 TODO
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';

class InsuranceModal extends StatelessWidget {
  final String jsonText;

  const InsuranceModal({
    super.key,
    required this.jsonText,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> decoded = json.decode(jsonText);
    final data = decoded['data'] as Map<String, dynamic>;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 상단 로고
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF005A78),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '로고',
                      style: TextStyle(
                        fontFamily: 'Pretendard-Bold',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                '상품 가입에 감사드립니다!',
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                '상품명 : ${data['productName']}',
                style: const TextStyle(
                  fontFamily: 'Pretendard-SemiBold',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                '보장 내역',
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // 2. 보장 내역 예시
              _buildCoverageItem('일반암 진단비', '암 확정 진단 시 가입금액 지급시 최대 2천만원 보장', '월 3500원'),
              _buildCoverageItem('뇌혈관질환 진단비', '뇌혈관 질환 진단 시 가입금액 지급', '월 1500원'),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
              ),

              // 3. 하단 계약 정보
              _buildBottomInfo('계약 기간', '${data['startDate']} – ${data['endDate']}'),
              _buildBottomInfo('금액', '월 ${data['totalPrice']}원', isPrice: true),

              const SizedBox(height: 32),

              // 4. 닫기 버튼
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.hanwhaOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        fontFamily: 'Pretendard-Bold',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverageItem(String name, String desc, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('- ', style: TextStyle(fontSize: 16, color: Colors.black)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Pretendard-SemiBold',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'Pretendard-Regular',
                    fontSize: 14,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Pretendard-SemiBold',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(String label, String value, {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontFamily: 'Pretendard-SemiBold',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: isPrice ? 'Pretendard-Bold' : 'Pretendard-Regular',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}