import 'package:flutter/material.dart';

/// 프로젝트 공통 AppBar
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.backgroundColor = Colors.white,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard-Bold',
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      centerTitle: centerTitle,
    );
  }
}


