// Flutter 진입점: 내 바몬 리스트 → 상세 페이지 네비게이션
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/barmon_list_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: BarmonApp()),
    ),
  );
}

class BarmonApp extends StatelessWidget {
  const BarmonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '바몬',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const BarmonListPage(),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}
