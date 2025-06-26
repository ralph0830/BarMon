// 바코드 스캔 화면 (mobile_scanner 사용)
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanPage extends StatefulWidget {
  final void Function(String barcode) onScan;
  const BarcodeScanPage({super.key, required this.onScan});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('바코드 스캔'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            // allowDuplicates 파라미터 제거 (최신 버전 미지원)
            onDetect: (capture) {
              if (_scanned) return;
              final barcode = capture.barcodes.first.rawValue;
              if (barcode != null) {
                setState(() => _scanned = true);
                widget.onScan(barcode);
                Navigator.pop(context);
              }
            },
          ),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (_scanned)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
