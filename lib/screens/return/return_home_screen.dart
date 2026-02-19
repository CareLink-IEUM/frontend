import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:hanwha/screens/return/return_home_steps.dart';

class ReturnHomeScreen extends StatefulWidget {
  const ReturnHomeScreen({super.key});

  @override
  State<ReturnHomeScreen> createState() => _ReturnHomeScreenState();
}

class _ReturnHomeScreenState extends State<ReturnHomeScreen> {
  int _currentStep = 0;
  final List<String> _steps = ['자산정리', '환전', '보험이전', '준비완료'];

  // 다음 단계로 이동하는 함수
  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '귀국 준비',
          style: TextStyle(
            fontFamily: 'Pretendard-Bold',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1. 상단 스테퍼 인디케이터
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                _buildStepper(),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // 2. 단계별 컨텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStepBody(),
            ),
          ),

          // 3. 하단 버튼
          if (_currentStep < _steps.length - 1)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.hanwhaOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '다음 단계로',
                    style: TextStyle(
                      fontFamily: 'Pretendard-SemiBold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 상태에 따라 컨텐츠 위젯 반환
  Widget _buildStepBody() {
    switch (_currentStep) {
      case 0:
        return const AssetStepContent();
      case 1:
        return const ExchangeStepContent();
      case 2:
        return const InsuranceStepContent();
      case 3:
        return const FinalStepContent();
      default:
        return const AssetStepContent();
    }
  }

  // 스테퍼 바 위젯
  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_steps.length, (index) {
        bool isProcessed = index <= _currentStep;
        bool isLast = index == _steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isProcessed ? AppColors.hanwhaOrange : Colors.white,
                    border: Border.all(
                      color: isProcessed ? AppColors.hanwhaOrange : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: index < _currentStep
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentStep ? Colors.white : Colors.grey.shade300,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 60,
                  child: Text(
                    _steps[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: index == _currentStep ? 'Pretendard-SemiBold' : 'Pretendard-Regular',
                      fontSize: 12,
                      color: index <= _currentStep ? Colors.black : Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            if (!isLast)
              Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: 2,
                margin: const EdgeInsets.only(top: 14),
                color: index < _currentStep ? AppColors.hanwhaOrange : Colors.grey.shade300,
              ),
          ],
        );
      }),
    );
  }
}