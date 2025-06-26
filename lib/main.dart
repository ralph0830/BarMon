// Flutter 진입점: 내 바코디언 리스트 → 상세 페이지 네비게이션
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/barcodian_list_page.dart';

void main() {
  runApp(const ProviderScope(child: BarcodianApp()));
}

class BarcodianApp extends StatelessWidget {
  const BarcodianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '바코디언',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const BarcodianListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
