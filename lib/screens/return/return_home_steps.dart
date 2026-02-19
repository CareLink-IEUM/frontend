import 'package:flutter/material.dart';
import 'package:hanwha/widgets/return/return_info_widget.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:hanwha/screens/main/main_screen.dart';


// 1단계: 자산정리
class AssetStepContent extends StatelessWidget {
  const AssetStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '흩어져 있는 잔액을 확인하고\n한 번에 정리하세요',
          style: TextStyle(fontFamily: 'Pretendard-Bold', fontSize: 18, height: 1.4),
        ),
        const SizedBox(height: 24),
        const ReturnInfoWidget(
          title: '잔액 통합 조회 및 이전 서비스',
          warnings: ['! 제3자 정보 제공 동의가 필요해요', '! 타행 수수료가 발생할 수 있어요'],
        ),
        const ReturnInfoWidget(
          title: '자동이체 해지 관리',
          warnings: ['! 해지 시 위약금이 발생할 수 있어요'],
        ),
        const ReturnInfoWidget(
          title: '계좌 해지 가이드',
          guides: [
            '[ 가이드 ] 비대면 계좌 폐쇄 시 잔액이 남아 있으면 어떻게 하나요?',
            '[ 가이드 ] 외국인 등록증이 만료되면 어떻게 되나요?'
          ],
        ),
      ],
    );
  }
}

// 2단계: 환전
class ExchangeStepContent extends StatelessWidget {
  const ExchangeStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Pretendard-Bold',
              fontSize: 18,
              color: Colors.black,
              height: 1.4,
            ),
            children: [
              TextSpan(text: '실시간 환율'),
              TextSpan(
                text: '을 확인하고\n',
                style: TextStyle(fontFamily: 'Pretendard-Regular'),
              ),
              TextSpan(text: '안전하게 송금'),
              TextSpan(
                text: '하세요',
                style: TextStyle(fontFamily: 'Pretendard-Regular'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // 이미지 영역
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/sample.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        const SizedBox(height: 24),
        const ReturnInfoWidget(
          title: '송금 준비 서류는 다 준비하셨나요?',
          guides: [
            '- 지정거래 은행 설정 서류',
            '- 소득 증빙 서류'
          ],
        ),
        const ReturnInfoWidget(
          title: '실시간 송금하기',
        ),
      ],
    );
  }
}

// 3단계: 보험이전
class InsuranceStepContent extends StatelessWidget {
  const InsuranceStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Pretendard-Bold',
              fontSize: 18,
              color: Colors.black,
              height: 1.4,
            ),
            children: [
              TextSpan(text: '한국 한화에서의 신뢰를 베트남에서도!\n가입 심사 간소화 및\n첫 달 보험료 지원 혜택을 확인하세요.\n'),
              TextSpan(
                text: '단, 재가입 시 가입 연령 증가나 과거 질병 이력으로 인해 \'보장 제한\' 또는 \'보험료 상승\'이 발생할 수 있습니다',
                style: TextStyle(
                  fontFamily: 'Pretendard-Medium',
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const ReturnInfoWidget(
          title: '미청구 보험금 및 환급금 수령 신청',
          warnings: ['! 미청구 보험금 존재 여부를 먼저 확인해주세요'],
        ),
        const ReturnInfoWidget(
          title: '브릿지 서비스 신청',
        ),
      ],
    );
  }
}

// 4단계: 준비완료
class FinalStepContent extends StatelessWidget {
  const FinalStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: AppColors.hanwhaOrange,
        ),
        const SizedBox(height: 24),
        const Text(
          '귀국 준비 끝!',
          style: TextStyle(
            fontFamily: 'Pretendard-Bold',
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '안전한 귀국길 되시길\n한화가 응원합니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Pretendard-Regular',
            fontSize: 16,
            color: Color(0xFF424242),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 60),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.hanwhaOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              '메인 페이지로 돌아가기',
              style: TextStyle(
                fontFamily: 'Pretendard-SemiBold',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}