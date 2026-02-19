import 'package:flutter/material.dart';
import 'package:hanwha/constants/theme.dart'; // hanwhaOrange 사용을 위해 필요

class InsuranceChatScreen extends StatefulWidget {
  const InsuranceChatScreen({super.key});

  @override
  State<InsuranceChatScreen> createState() => _InsuranceChatScreenState();
}

class _InsuranceChatScreenState extends State<InsuranceChatScreen> {
  final List<Map<String, dynamic>> _messages = []; // 초기값은 비워두어 '시작 전' 화면 노출
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'isMe': true, 'text': _controller.text});
      // 챗봇 응답 예시 (테스트용)
      _messages.add({'isMe': false, 'text': '보험금 청구 절차에 대해 안내해 드릴까요?'});
    });
    _controller.clear();
  }

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
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty 
                ? _buildEmptyState() // 채팅 시작 전 화면
                : _buildChatList(),  // 채팅 진행 중 화면
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // 1. 채팅 시작 전 가이드 디자인
  Widget _buildEmptyState() {
  return Container(
    padding: const EdgeInsets.only(left: 40, top: 120),
    alignment: Alignment.topLeft,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안녕하세요\n보험에 대해\n궁금한 것을 물어보세요',
          style: TextStyle(
            fontFamily: 'Pretendard-Bold',
            fontSize: 18,
            height: 1.4,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}


  // 2. 채팅 중 말풍선 리스트
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final bool isMe = message['isMe'];

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFF2F2F7) : AppColors.orangeLighter,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              border: isMe ? null : Border.all(color: Colors.grey.shade200),
              boxShadow: isMe ? [] : [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))
              ],
            ),
            child: Text(
              message['text'],
              style: const TextStyle(fontFamily: 'Pretendard-Regular', fontSize: 16, height: 1.4),
            ),
          ),
        );
      },
    );
  }

  // 3. 하단 입력바 디자인
  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: '보험에 대해 궁금한 것을 물어보세요!',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.hanwhaOrange),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}