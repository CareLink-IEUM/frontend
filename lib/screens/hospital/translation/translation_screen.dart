import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hanwha/constants/theme.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  bool isKoreanToVietnamese = true;
  final TextEditingController _inputController = TextEditingController();

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _lastFilePath;

  String translatedText = "Kết quả bản dịch sẽ được hiển thị tại đây.";
  String get _defaultResultText => isKoreanToVietnamese
      ? "Kết quả bản dịch sẽ được hiển thị tại đây."
      : "번역 결과가 여기에 표시됩니다.";

  @override
  void initState() {
    super.initState();
    translatedText = _defaultResultText;
  }

  @override
  void dispose() {
    _inputController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  // 녹음 시작 함수
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // 1. 저장할 디렉토리 가져오기 (앱 내부 문서 폴더)
        final directory = await getApplicationDocumentsDirectory();
        final String path =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // 2. 녹음 설정
        const config = RecordConfig();

        // 3. 녹음 시작
        await _audioRecorder.start(config, path: path);

        setState(() {
          _isRecording = true;
          _lastFilePath = null; // 이전 경로 초기화
        });
        print("녹음 시작: $path");
      }
    } catch (e) {
      print("녹음 시작 에러: $e");
    }
  }

  // 녹음 중지 및 파일 저장 확인 함수
  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _lastFilePath = path;
      });

      if (path != null) {
        print("녹음 완료! 파일 저장 경로: $path");
        // 파일이 실제로 존재하는지 확인
        final file = File(path);
        if (await file.exists()) {
          print("파일 확인 성공! 크기: ${await file.length()} bytes");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("녹음 완료: ${path.split('/').last}")),
          );
        }
      }
    } catch (e) {
      print("녹음 중지 에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '병원 통역',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard-Bold',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. 언어 선택 탭 (양옆 마진 및 간격 조정)
          _buildLanguageSelector(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // 2. 입력 카드 (상태에 따라 언어 이름 변경)
                _buildSourceInputCard(),
                const SizedBox(height: 20),
                // 2. 결과 카드 (상태에 따라 언어 이름 변경)
                _buildTranslationResultCard(),
                if (_lastFilePath != null) // 마지막 저장 경로 확인용
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "최근 파일: ${_lastFilePath!.split('/').last}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),

          _buildBottomActionSection(),
        ],
      ),
    );
  }

  // 1. 언어 선택 위젯: 왼쪽/오른쪽 글씨가 버튼 클릭 시 서로 바뀜
  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 왼쪽 언어
          Text(
            isKoreanToVietnamese ? "한국어" : "베트남어",
            style: const TextStyle(
              fontFamily: 'Pretendard-Semibold',
              fontWeight: FontWeight.bold,
              color: AppColors.orangeLighter,
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: AppColors.orangeLight),
            onPressed: () {
              setState(() {
                isKoreanToVietnamese = !isKoreanToVietnamese;
                _inputController.clear();
                translatedText = _defaultResultText;
              });
            },
          ),
          const SizedBox(width: 15),
          // 오른쪽 언어
          Text(
            isKoreanToVietnamese ? "베트남어" : "한국어",
            style: const TextStyle(
              fontFamily: 'Pretendard-Semibold',
              fontWeight: FontWeight.bold,
              color: AppColors.hanwhaOrange,
            ),
          ),
        ],
      ),
    );
  }

  // 2. 입력 카드: 현재 '출발어'가 무엇인지에 따라 라벨과 힌트가 바뀜
  Widget _buildSourceInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isKoreanToVietnamese ? "한국어" : "베트남어", // 버튼 누르면 이 글씨가 바뀜
                style: const TextStyle(
                  color: AppColors.orangeLighter,
                  fontFamily: 'Pretendard-Semibold',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: AppColors.orangeLight),
                onPressed: () => _inputController.clear(),
              ),
            ],
          ),
          TextField(
            controller: _inputController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: isKoreanToVietnamese
                  ? "여기에 입력해주세요."
                  : "Nhập nội dung tại đây.",
              border: InputBorder.none,
              isDense: true,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Pretendard-Regular',
                fontSize: 14,
              ),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // 3. 결과 카드: 현재 '도착어'가 무엇인지에 따라 라벨이 바뀜
  Widget _buildTranslationResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isKoreanToVietnamese ? "베트남어" : "한국어", // 버튼 누르면 이 글씨가 바뀜
                style: const TextStyle(
                  color: AppColors.hanwhaOrange,
                  fontFamily: 'Pretendard-Semibold',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.copy_all_outlined,
                  color: AppColors.orangeLight,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: translatedText));
                },
              ),
            ],
          ),
          Text(
            translatedText,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Pretendard-Regular',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // 하단 버튼 섹션 (번역하기 버튼 & 마이크)
  Widget _buildBottomActionSection() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // 번역 로직 실행
                setState(() {
                  translatedText = "번역된 내용이 표시됩니다.";
                });
              },
              child: Container(
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.orangeLight,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  '번역하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pretendard-Semibold',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              if (_isRecording) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                // 녹음 중일 때 색상을 빨간색으로 변경하여 표시
                gradient: _isRecording
                    ? const LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                      )
                    : const LinearGradient(
                        colors: [
                          AppColors.hanwhaOrange,
                          AppColors.orangeLight,
                          AppColors.orangeLighter,
                        ],
                      ),
                shape: BoxShape.circle,
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
