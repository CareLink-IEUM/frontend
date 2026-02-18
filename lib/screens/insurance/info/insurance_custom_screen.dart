import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hanwha/config/api_config.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:hanwha/constants/insurance_categories.dart';
import 'package:hanwha/widgets/common/common_app_bar.dart';
import 'package:hanwha/widgets/insurance/insurance_check_card.dart';
import 'package:hanwha/widgets/insurance/insurance_category_select.dart';
import 'package:hanwha/screens/insurance/info/insurance_modal.dart';
import 'package:http/http.dart' as http;

class InsuranceCustomScreen extends StatefulWidget {
  final int productId;

  const InsuranceCustomScreen({
    super.key,
    required this.productId,
  });

  @override
  State<InsuranceCustomScreen> createState() => _InsuranceCustomScreenState();
}

class _InsuranceCustomScreenState extends State<InsuranceCustomScreen> {
  int _selectedCategoryIndex = 0;

  // 실제 카드에 쓸 데이터
  List<CoverageItem> _coreItems = [];
  List<CoverageItem> _riderItems = [];

  List<String> get _categories => InsuranceCategories.getLabels();

  bool get _isCustomProduct =>
      widget.productId == InsuranceCategories.customProductId;

  String get _coreSectionHint => _isCustomProduct
      ? '조립식일 때는 주계약 중에 하나 이상 선택해주세요.'
      : '필수 계약 사항입니다.';

  List<CoverageItem> get _filteredRiderItems {
    if (_riderItems.isEmpty) return [];
    final currentCode = InsuranceCategories.categoryCodes[_selectedCategoryIndex];
    return _riderItems
        .where((item) => item.category == currentCode)
        .toList();
  }

  int get _totalSelectedPrice {
    final all = <CoverageItem>[
      ..._coreItems,
      ..._riderItems,
    ];
    return all
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + item.price);
  }

  @override
  void initState() {
    super.initState();
    _fetchInsuranceCoverages();
  }

  Future<void> _fetchInsuranceCoverages() async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/insurance/${widget.productId}');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        return;
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      final coverages = (data['coverages'] as List<dynamic>? ?? []);

      final List<CoverageItem> core = [];
      final List<CoverageItem> rider = [];

      for (final item in coverages) {
        final map = item as Map<String, dynamic>;

        final coverage = CoverageItem(
          coverageId: (map['coverageId'] as num).toInt(),
          linkId: (map['linkId'] as num).toInt(),
          name: map['name'] as String,
          category: map['category'] as String,
          description: map['description'] as String? ?? '',
          amount: (map['amount'] as num).toInt(),
          price: (map['price'] as num).toInt(),
          mandatory: map['mandatory'] as bool,
          recommended: (map['recommended'] as bool?) ?? false,
        );

        if (coverage.mandatory) {
          core.add(coverage);
        } else {
          rider.add(coverage);
        }
      }

      setState(() {
        _coreItems = core;
        _riderItems = rider;
      });
    } catch (_) {
      // 실패 시에는 일단 화면에 아무 것도 표시하지 않음
    }
  }

  Future<void> _submitContract() async {
    final selected = <CoverageItem>[
      ..._coreItems.where((item) => item.isChecked),
      ..._riderItems.where((item) => item.isChecked),
    ];

    if (selected.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('선택된 담보가 없습니다.')),
        );
      }
      return;
    }

    final now = DateTime.now();
    String formatDate(DateTime d) => d.toIso8601String().split('T').first;

    final request = InsuranceContractRequestDto(
      memberId: 1, // TODO: 나중에 실제 로그인 사용자 ID로 교체
      productId: widget.productId,
      paymentCycle: 'MONTHLY',
      coverageIds: selected.map((e) => e.coverageId).toList(),
      startDate: formatDate(now),
      endDate: formatDate(
        DateTime(now.year + 1, now.month, now.day),
      ),
    );

    try {
      final uri =
          Uri.parse('${ApiConfig.baseUrl}/api/insurance/contract');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('가입 요청 실패 (${response.statusCode})'),
          ),
        );
        return;
      }

      final decoded = json.decode(response.body);
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(decoded);

      showDialog(
        context: context,
        builder: (context) => InsuranceModal(jsonText: prettyJson),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가입 요청 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CommonAppBar(title: '내 맞춤 보장'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  InsuranceCategories.getLabelByProductId(widget.productId),
                  style: TextStyle(
                    fontFamily: 'Pretendard-Bold',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '주계약',
                      style: TextStyle(
                        fontFamily: 'Pretendard-Bold',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _coreSectionHint,
                      style: const TextStyle(
                        fontFamily: 'Pretendard-Medium',
                        fontSize: 14,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // --- 필수 담보 섹션 (onTap 추가) ---
                ..._coreItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return InsuranceCheckCard(
                    title: item.name,
                    subTitle: '${item.description}시 최대 ${formatMoney(item.amount)} 보장',
                    amount: '월 ${formatMoney(item.price)}',
                    isChecked: item.isChecked,
                    badgeText: item.recommended ? '추천상품' : null,
                    onTap: () {
                      setState(() {
                        _coreItems[index].isChecked = !_coreItems[index].isChecked;
                      });
                    },
                  );
                }),
                
                const SizedBox(height: 40),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '선택 특약',
                      style: TextStyle(
                        fontFamily: 'Pretendard-Bold',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '원하는 특약을 자유롭게 추가할 수 있어요',
                      style: TextStyle(
                        fontFamily: 'Pretendard-Medium',
                        fontSize: 14,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
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
                ..._filteredRiderItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return InsuranceCheckCard(
                    title: item.name,
                    subTitle: '${item.description}시 최대 ${formatMoney(item.amount)} 보장',
                    amount: '월 ${formatMoney(item.price)}',
                    isChecked: item.isChecked,
                    badgeText: item.recommended ? '추천상품' : null,
                    onTap: () {
                      setState(() {
                        _filteredRiderItems[index].isChecked =
                            !_filteredRiderItems[index].isChecked;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
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
        child: GestureDetector(
          onTap: _submitContract,
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
            child: Center(
              child: Text(
                '현재 월 / ${_totalSelectedPrice}원',
                style: const TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InsuranceContractRequestDto {
  final int memberId;
  final int productId;
  final String paymentCycle;
  final List<int> coverageIds;
  final String startDate;
  final String endDate;

  InsuranceContractRequestDto({
    required this.memberId,
    required this.productId,
    required this.paymentCycle,
    required this.coverageIds,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'productId': productId,
      'paymentCycle': paymentCycle,
      'coverageIds': coverageIds,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class CoverageItem {
  final int coverageId;
  final int linkId;
  final String name;
  final String category;
  final String description;
  final int amount;
  final int price;
  final bool mandatory;
  final bool recommended;
  bool isChecked;

  CoverageItem({
    required this.coverageId,
    required this.linkId,
    required this.name,
    required this.category,
    required this.description,
    required this.amount,
    required this.price,
    required this.mandatory,
    required this.recommended,
    this.isChecked = false,
  });
}

String formatMoney(int amount) {
  if (amount >= 100000000) {
    int eok = amount ~/ 100000000;
    return '${eok}억원';
  } else if (amount >= 10000000) {
    int tenMillion = amount ~/ 10000000;
    return '${tenMillion}천만원';
  } else if (amount >= 1000000) {
    int million = amount ~/ 1000000;
    return '${million}백만원';
  } else if (amount >= 10000) {
    int man = amount ~/ 10000;
    return '${man}만원';
  } else {
    return '${amount}원';
  }
}
