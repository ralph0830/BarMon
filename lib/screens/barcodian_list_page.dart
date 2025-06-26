// 내 바코디언 리스트 페이지 (스캔 버튼 포함)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/barcodian_provider.dart';
import '../widgets/barcodian_card.dart';
import '../models/barcodian.dart';
import 'barcodian_detail_page.dart';
import 'barcode_scan_page.dart';

class BarcodianListPage extends ConsumerWidget {
  const BarcodianListPage({super.key});

  void _onScan(BuildContext context, WidgetRef ref) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodeScanPage(
          onScan: (barcode) {
            // TODO: 바코드 값(barcode) 처리 로직 구현
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('스캔된 바코드: $barcode')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodians = ref.watch(barcodianListProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('내 바코디언'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.black87),
              tooltip: '바코드 스캔',
              onPressed: () => _onScan(context, ref),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: barcodians.length,
          itemBuilder: (context, index) {
            final barcodian = barcodians[index];
            return BarcodianCard(
              barcodian: barcodian,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BarcodianDetailPage(barcodian: barcodian),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
