import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart';

class InsuranceMockChatScreen extends StatefulWidget {
  const InsuranceMockChatScreen({super.key});

  @override
  State<InsuranceMockChatScreen> createState() => _InsuranceMockChatScreenState();
}

class _InsuranceMockChatScreenState extends State<InsuranceMockChatScreen> {
  // 💡 데이터 구조에 'notice' 필드를 추가하여 주의사항을 분리했습니다.
  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': true,
      'text': '내가 가입한 보험으로 어떤 경우에 보상을 받을 수 있어?',
    },
    {
      'isMe': false,
      'text': '고객님의 가입 정보를 바탕으로 약관상 명시된 핵심 담보를 안내해 드립니다. 현재 [화재상해후유장해], [화재배상책임] 등의 담보가 확인됩니다.\n\n각 담보별로 상해 장해지급률이나 타인에 대한 배상 책임 발생 시 보험금이 지급됩니다.\n\n구체적인 사고 맥락이나 상황을 말씀해 주시면 더 정확한 안내가 가능합니다.',
      'actions': ['화재상해후유장해 약관', '화재배상책임 약관'],
      'notice': '본 답변은 AI가 약관을 바탕으로 생성했습니다. 실제 지급 여부는 사고 심사 결과에 따라 달라질 수 있습니다.',
      'source': '한화손해보험 무배당 한화 입국안심 상해보험 약관 제4절',
    },
    {
      'isMe': true,
      'text': '식당에서 밥 먹다가 불이 나서 다쳤는데, 이거 보험 처리 돼? 얼마나 받을 수 있을까?',
    },
    {
      'isMe': false,
      'text': '많이 놀라셨을 고객님의 쾌유를 먼저 기원합니다. 현재 질문하신 상황은 가입하신 [화재상해후유장해] 조항의 보상 범위에 해당할 가능성이 높습니다.\n\n다만, 정확한 지급 금액은 고객님의 실제 상해 정도(장해지급률)와 가입금액에 따라 산출되므로, 서류 접수 후 전문 보상 상담사를 통해 확정됩니다. 지금 바로 서류를 접수해 보시겠어요?',
      'actions': ['지금 바로 서류 접수하기', '전문 보상 상담사 연결'],
      'notice': '본 답변은 AI가 약관을 바탕으로 생성했습니다. 예상 보상 범위를 안내할 뿐 구체적인 액수는 심사 결과에 따라 달라질 수 있습니다.',
      'source': '한화손해보험 상해/배상책임 보험금 지급 표준 가이드',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '보험 안내 챗봇',
          style: TextStyle(fontFamily: 'Pretendard-Bold', fontSize: 18, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final bool isMe = message['isMe'];

        return Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // 1. 말풍선
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFF2F2F7) : AppColors.orangeLighter,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                ),
                child: Text(
                  message['text'],
                  style: const TextStyle(fontFamily: 'Pretendard-Regular', fontSize: 15, height: 1.5),
                ),
              ),
            ),
            // 2. 챗봇 부가 정보 (액션 버튼, 공지, 출처)
            if (!isMe) ...[
              if (message['actions'] != null) _buildActionButtons(message['actions']),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message['notice'] != null)
                      Text(
                        '*${message['notice']}',
                        style: TextStyle(fontFamily: 'Pretendard-Regular', fontSize: 11, color: Colors.grey.shade500, height: 1.4),
                      ),
                    const SizedBox(height: 4),
                    if (message['source'] != null)
                      Text(
                        '[데이터 출처]: ${message['source']}',
                        style: TextStyle(fontFamily: 'Pretendard-Regular', fontSize: 11, color: Colors.grey.shade500),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(List<String> actions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions.map((action) {
          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.hanwhaOrange.withOpacity(0.4)),
              ),
              child: Text(
                action,
                style: const TextStyle(fontFamily: 'Pretendard-Medium', color: AppColors.hanwhaOrange, fontSize: 13),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(28)),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '궁금한 것을 물어보세요!',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.hanwhaOrange),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}