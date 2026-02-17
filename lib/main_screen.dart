import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // 살짝 밝은 그레이로 배경색 변경 (카드 부각)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/hanwha_logo.png',
              width: 32, // 로고 크기 적절히 조절
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'Hanwha',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Pretendard-Bold',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.all(2),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                child: Icon(
                  Icons.settings_rounded,
                  color: Color.fromARGB(255, 243, 115, 33),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              '안녕하세요, 한화인님',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Pretendard-SemiBold',
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              '어쩌고저쩌고',
              style: TextStyle(fontSize: 18, fontFamily: 'Pretendard-SemiBold'),
            ),
            const SizedBox(height: 30),

            // --- 내 보험 섹션 (디자인 강화) ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 243, 115, 33),
                    Color.fromARGB(255, 248, 155, 108),
                    Color.fromARGB(255, 251, 181, 132),
                    Color(0xFFFCD2B2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '내 보험 정보',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Pretendard-Regular',
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '3개의 보험에\n가입되어 있어요',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Pretendard-Semibold',
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                        Opacity(
                          opacity: 0.9,
                          child: Image.asset(
                            'assets/images/hanwha_logo.png', // 내가 저장한 경로
                            width: 75,
                            height: 75,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 하단 액션 바
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        _buildActionBtn(
                          Icons.assignment_turned_in,
                          '보험 확인',
                          context,
                        ),
                        Container(width: 1, height: 20, color: Colors.white24),
                        _buildActionBtn(Icons.question_answer, '질문하기', context),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- 중간 버튼 라인 ---
            _buildMenuButton(
              '실시간 송금하기',
              Icons.send_rounded,
              const Color.fromARGB(255, 248, 155, 108),
            ),

            const SizedBox(height: 30),

            // --- 하단 3개 그리드 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGridItem(
                  '주변 병원',
                  Icons.local_hospital_rounded,
                  const Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 248, 155, 108),
                ),
                const SizedBox(width: 12),
                _buildGridItem(
                  '병원 통역',
                  Icons.translate_rounded,
                  const Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 248, 155, 108),
                ),
                const SizedBox(width: 12),
                _buildGridItem(
                  '가족 관리',
                  Icons.family_restroom_rounded,
                  const Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 248, 155, 108),
                ),
                const SizedBox(width: 12),
                _buildGridItem(
                  '귀국 신청',
                  Icons.airplane_ticket_rounded,
                  const Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 248, 155, 108),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- 긴급 상황 버튼 ---
            GestureDetector(
              onTap: () {
                print('긴급신고(119) 클릭됨');
              },
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 115, 33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      '긴급 신고 (119)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Pretendard-Semibold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 보험 카드 전용 버튼
  Widget _buildActionBtn(IconData icon, String label, BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (label == '보험 확인') {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsuranceDetailScreen()));
            print('보험확인 클릭됨');
          } else if (label == '질문하기') {
            print('질문하기 클릭됨');
          }
        },
        child: Padding(
          // 클릭 영역을 확보하기 위해 Padding 추가
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard-Semibold',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 일반 가로 버튼
  Widget _buildMenuButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard-Semibold',
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // 그리드 아이템
  Widget _buildGridItem(
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return GestureDetector(
      onTap: () {
        print('$label 클릭됨');
        if (label == '주변 병원') {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalScreen()));
        } else if (label == '병원 통역') {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => const TranslateScreen()));
        } else if (label == '가족 관리') {
        } else {
          // 귀국 시청
        }
      },
      child: Column(
        children: [
          Container(
            width: 60, // 동그라미 크기 고정
            height: 60,
            decoration: BoxDecoration(
              color: bgColor, // 여기가 이제 아이콘의 배경색
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12), // 아이콘과 글자 사이 간격
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard-Semibold',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }
}
