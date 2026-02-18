import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart'; //

class InsuranceCategorySelect extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const InsuranceCategorySelect({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // 기본 전체 하단 검정 바
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        children: List.generate(categories.length, (index) {
          bool isSelected = selectedIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onCategorySelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  // 선택된 카테고리에만 주황색 하단 바 적용
                  border: isSelected
                      ? const Border(
                          bottom: BorderSide(
                            color: AppColors.hanwhaOrange,
                            width: 3.0,
                          ),
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard-Bold',
                      fontSize: 14,
                      // 선택 여부에 따른 텍스트 색상 변경
                      color: isSelected ? AppColors.hanwhaOrange : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}