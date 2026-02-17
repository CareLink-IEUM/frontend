import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:hanwha/widgets/insurance/insurance_check_card.dart';
import 'package:hanwha/widgets/insurance/insurance_category_select.dart';

class InsuranceCustomScreen extends StatefulWidget {
  const InsuranceCustomScreen({super.key});

  @override
  State<InsuranceCustomScreen> createState() => _InsuranceCustomScreenState();
}

class _InsuranceCustomScreenState extends State<InsuranceCustomScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['암', '건강', '사망', '저축·연금', '유병자'];

  // 1. final을 제거하여 데이터 수정이 가능하게 변경합니다.
  List<Map<String, dynamic>> _coreItems = [
    {
      'title': '암 진단비',
      'subTitle': '유사암 제외 최초 1회 지급',
      'amount': '2,000만원',
      'isChecked': true,
    },
    {
      'title': '뇌혈관질환 진단비',
      'subTitle': '최초 1회 지급',
      'amount': '1,000만원',
      'isChecked': true,
    },
  ];

  List<Map<String, dynamic>> _riderItems = [
    {
      'title': '허혈성심장질환 진단비',
      'subTitle': '최초 1회 지급',
      'amount': '1,000만원',
      'isChecked': true,
    },
    {
      'title': '상해수술비',
      'subTitle': '수술 1회당 지급',
      'amount': '100만원',
      'isChecked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '내 맞춤 보장',
          style: TextStyle(
            fontFamily: 'Pretendard-Bold',
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '자유 조립형 보험',
                  style: TextStyle(
                    fontFamily: 'Pretendard-Bold',
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '원하는 보장을 선택해서 설계해보세요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard-Medium',
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 30),
                
                // --- 필수 담보 섹션 (onTap 추가) ---
                ..._coreItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return InsuranceCheckCard(
                    title: item['title'],
                    subTitle: item['subTitle'],
                    amount: item['amount'],
                    isChecked: item['isChecked'],
                    onTap: () {
                      setState(() {
                        _coreItems[index]['isChecked'] = !_coreItems[index]['isChecked'];
                      });
                    },
                  );
                }),
                
                const SizedBox(height: 40),
                const Text(
                  '추가 선택 담보 (Rider)',
                  style: TextStyle(
                    fontFamily: 'Pretendard-Bold',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                
                InsuranceCategorySelect(
                  categories: _categories,
                  selectedIndex: _selectedCategoryIndex,
                  onCategorySelected: (index) {
                    setState(() => _selectedCategoryIndex = index);
                  },
                ),
                const SizedBox(height: 20),
                
                // --- 선택 담보 리스트 (onTap 추가) ---
                ..._riderItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return InsuranceCheckCard(
                    title: item['title'],
                    subTitle: item['subTitle'],
                    amount: item['amount'],
                    isChecked: item['isChecked'],
                    onTap: () {
                      setState(() {
                        _riderItems[index]['isChecked'] = !_riderItems[index]['isChecked'];
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          
          // 하단 버튼 생략 (기존 코드와 동일)
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background.withOpacity(0),
              AppColors.background,
            ],
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.hanwhaOrange,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.hanwhaOrange.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '현재 월 / 13,000원',
              style: TextStyle(
                fontFamily: 'Pretendard-Bold',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}