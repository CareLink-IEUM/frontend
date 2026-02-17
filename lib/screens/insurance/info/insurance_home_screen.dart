import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:hanwha/widgets/common/long_banner_card.dart';
import 'package:hanwha/widgets/common/square_card.dart';
import 'package:hanwha/screens/insurance/info/insurance_custom_screen.dart';

class InsuranceHomeScreen extends StatelessWidget {
  const InsuranceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                '보험상품',
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // 상단 롱 배너 클릭 시 화면 이동
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InsuranceCustomScreen(),
                    ),
                  );
                },
                child: LongBannerCard(
                  subtitle: '원하는 보장만 선택해서 보험을 만보보오요!',
                  title: '자유 조립형 보험',
                  backgroundColor: AppColors.hanwhaOrange,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  // 2. AppColors를 사용하는 위젯은 const를 뺍니다.
                  SquareCard(
                    label: '미니',
                    backgroundColor: AppColors.hanwhaOrange,
                    fontColor: Colors.white,
                  ),
                  SquareCard(
                    label: '암',
                    backgroundColor: Colors.white,
                    fontColor: Colors.black,
                    icon: Icon(Icons.check_circle, color: AppColors.hanwhaOrange),
                  ),
                  const SquareCard(
                    label: '사망',
                    backgroundColor: Colors.white,
                    fontColor: Colors.black,
                  ),
                  SquareCard(
                    label: '저축',
                    backgroundColor: Colors.white,
                    fontColor: Colors.black,
                    icon: Icon(Icons.check_circle, color: AppColors.hanwhaOrange),
                  ),
                  const SquareCard(
                    label: '자동차',
                    backgroundColor: Colors.white,
                    fontColor: Colors.black,
                  ),
                  SquareCard(
                    label: '암',
                    backgroundColor: Colors.white,
                    fontColor: Colors.black,
                    icon: Icon(Icons.check_circle, color: AppColors.hanwhaOrange),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}