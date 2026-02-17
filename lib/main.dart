import 'package:flutter/material.dart';
// 1. 여기서 파일을 정확히 불러와야 합니다.
import 'screens/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MainScreen());
  }
}
