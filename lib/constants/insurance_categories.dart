/// 보험 카테고리 관련 상수 정의
class InsuranceCategories {
  static const List<String> categoryCodes = [
    'DISEASE',
    'INJURY',
    'DENTAL',
    'DRIVER',
    'LIVING',
  ];

  static const Map<String, String> categoryLabels = {
    'DISEASE': '질병',
    'INJURY': '상해',
    'DENTAL': '치아',
    'DRIVER': '운전자',
    'LIVING': '생활',
  };

  // productId
  static const Map<String, int> categoryProductIds = {
    'DISEASE': 2,
    'INJURY': 3,
    'DENTAL': 4,
    'DRIVER': 5,
    'LIVING': 6,
  };

  static const int customProductId = 1;


  static int? getProductIdByCategory(String categoryCode) {
    return categoryProductIds[categoryCode];
  }

  static String getLabelByCategory(String categoryCode) {
    return categoryLabels[categoryCode] ?? categoryCode;
  }

  static String getLabelByProductId(int productId) {
    if (productId == customProductId) {
      return '자유 조립형 보험';
    }

    final categoryCode = categoryProductIds.entries
        .firstWhere(
          (e) => e.value == productId,
          orElse: () => const MapEntry('', -1),
        )
        .key;

    if (categoryCode.isEmpty) {
      return '보험상품';
    }
    return getLabelByCategory(categoryCode);
  }

  static List<String> getLabels() {
    return categoryCodes.map((code) => getLabelByCategory(code)).toList();
  }
}