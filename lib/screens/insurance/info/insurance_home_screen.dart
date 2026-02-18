import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:hanwha/constants/insurance_categories.dart';
import 'package:hanwha/widgets/common/long_banner_card.dart';
import 'package:hanwha/widgets/common/square_card.dart';
import 'package:hanwha/screens/insurance/info/insurance_custom_screen.dart';

class InsuranceHomeScreen extends StatefulWidget {
  const InsuranceHomeScreen({super.key});

  @override
  State<InsuranceHomeScreen> createState() => _InsuranceHomeScreenState();
}

class _InsuranceHomeScreenState extends State<InsuranceHomeScreen> {
  bool isSelectedMini = true;

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
              // 상단 롱 배너
              GestureDetector(
                onTap: () => _navigateToCustom(context, InsuranceCategories.customProductId),
                child: const LongBannerCard(
                  subtitle: '원하는대로 보험을 만들어보세요!',
                  title: '자유 조립형 보험',
                  backgroundColor: AppColors.hanwhaOrange,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // --- 일반보험 / 미니보험 탭 ---
              Row(
                children: [
                  _buildTabButton("미니보험", isSelectedMini, () {
                    setState(() => isSelectedMini = true);
                  }),
                  const SizedBox(width: 15),
                  _buildTabButton("일반보험", !isSelectedMini, () {
                    setState(() => isSelectedMini = false);
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // --- 보험 상품 그리드 ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: InsuranceCategories.categoryCodes.map((categoryCode) {
                  final label = InsuranceCategories.getLabelByCategory(categoryCode);
                  return _buildInsuranceCard(
                    context,
                    label,
                    categoryCode,
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 탭 버튼 위젯 빌더
  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: isSelected ? 'Pretendard-SemiBold' : 'Pretendard-Regular',
          fontSize: 20,
          color: isSelected ? AppColors.hanwhaOrange : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  // 카드 위젯 빌더
  Widget _buildInsuranceCard(
  BuildContext context,
  String label,
  String categoryCode,
) {
  IconData categoryIcon;
  switch (categoryCode) {
    case 'DISEASE': categoryIcon = Icons.local_hospital_rounded; break;
    case 'INJURY': categoryIcon = Icons.accessible_forward_rounded; break;
    case 'DENTAL': categoryIcon = Icons.medical_services_rounded; break;
    case 'DRIVER': categoryIcon = Icons.directions_car_filled_rounded; break;
    case 'LIVING': categoryIcon = Icons.house_rounded; break;
    default: 
      categoryIcon = Icons.shield_rounded;
  }

  Color iconColor = isSelectedMini ? Colors.white : AppColors.orangeLight;

  return GestureDetector(
    onTap: isSelectedMini
        ? () {
            final productId = InsuranceCategories.getProductIdByCategory(categoryCode);
            if (productId != null) {
              _navigateToCustom(context, productId);
            }
          }
        : null,
    child: SquareCard(
      label: label,
      icon: categoryIcon,
      iconColor: iconColor,
      isSelected: isSelectedMini,
      backgroundColor: isSelectedMini ? AppColors.orangeLight : Colors.white,
      fontColor: isSelectedMini ? Colors.white : Colors.black,
    ),
  );
}

  // 화면 이동 함수
  void _navigateToCustom(BuildContext context, int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsuranceCustomScreen(productId: productId),
      ),
    );
  }
}