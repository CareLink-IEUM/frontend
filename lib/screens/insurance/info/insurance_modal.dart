import 'package:flutter/material.dart';

class InsuranceModal extends StatelessWidget {
  final String jsonText;

  const InsuranceModal({
    super.key,
    required this.jsonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '가입 결과',
        style: TextStyle(
          fontFamily: 'Pretendard-Bold',
          fontSize: 18,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: SelectableText(
            jsonText,
            style: const TextStyle(
              fontFamily: 'Pretendard-Regular',
              fontSize: 12,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '닫기',
            style: TextStyle(
              fontFamily: 'Pretendard-Medium',
            ),
          ),
        ),
      ],
    );
  }
}


