import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hanwha/screens/main/main_screen.dart';

class InsuranceClaimScreen extends StatefulWidget {
  const InsuranceClaimScreen({super.key});

  @override
  State<InsuranceClaimScreen> createState() => _InsuranceClaimScreenState();
}

class _InsuranceClaimScreenState extends State<InsuranceClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  // OCR 엔진 초기화
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.korean,
  );

  final TextEditingController _diseaseCodeController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // 이미지 선택 및 OCR 실행 호출
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _processImage(_image!);
    }
  }

  // 핵심 OCR 로직
  Future<void> _processImage(File imageFile) async {
    setState(() => _isLoading = true);

    final inputImage = InputImage.fromFile(imageFile);

    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      String fullText = recognizedText.text;

      setState(() {
        _diseaseCodeController.text = _extractDiseaseCode(fullText);
        _hospitalNameController.text = _extractHospitalName(fullText);
        _amountController.text = _extractAmount(fullText);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("OCR 에러: $e");
      setState(() => _isLoading = false);
    }
  }

  String _extractDiseaseCode(String text) {
    final regExp = RegExp(r'[A-Z]\d{2}(\.\d)?');
    return regExp.firstMatch(text)?.group(0) ?? "";
  }

  String _extractHospitalName(String text) {
    final regExp = RegExp(r'([가-힣]+(병원|의원))');
    return regExp.firstMatch(text)?.group(0) ?? "";
  }

  String _extractAmount(String text) {
    final regExp = RegExp(r'(\d{1,3}(,\d{3})*)\s?원');
    String? matched = regExp.firstMatch(text)?.group(1);
    return matched?.replaceAll(',', '') ?? "";
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 엔진 닫기
    _textRecognizer.close();
    _diseaseCodeController.dispose();
    _hospitalNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "진단서 촬영",
                style: TextStyle(
                  fontFamily: 'Pretendard-Semibold',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // --- 이미지 표시 영역 ---
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _image == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: AppColors.orangeLighter,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "여기를 눌러 서류를 찍으세요",
                              style: TextStyle(
                                fontFamily: 'Pretendard-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),

              const SizedBox(height: 30),

              // --- OCR 결과 수정 폼 ---
              _buildInputField("질병코드", _diseaseCodeController, "진단서의 질병기호"),
              _buildInputField("병원명", _hospitalNameController, "병원 이름을 확인하세요"),
              _buildInputField(
                "금액",
                _amountController,
                "숫자만 확인",
                isNumber: true,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _image != null && !_isLoading ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeLighter,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    "청구 데이터 전송하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard-Semibold',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard-Semibold',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Pretendard-Regular',
                fontSize: 14,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.orangeLight,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white, width: 1),
        ),
        title: const Text(
          "청구 완료",
          style: TextStyle(
            fontFamily: 'Pretendard-Semibold',
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.99, // 가로 너비 확장
          child: Text(
            "${_hospitalNameController.text}에 대한 청구가 성공적으로 접수되었습니다.",
            style: const TextStyle(
              fontFamily: 'Pretendard-Regular',
              fontSize: 15,
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.orangeLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                "확인",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pretendard-Semibold',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
