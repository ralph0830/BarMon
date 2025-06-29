import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final String title;
  final VoidCallback onMenu;
  final Widget? child;
  const BasePage({Key? key, required this.title, required this.onMenu, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return Column(
            children: [
              SizedBox(
                height: height * 0.05,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 1.0],
                      colors: [
                        Color(0xFFFF9408), // 0%
                        Color(0xFF95122C), // 100%
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black87),
                        onPressed: onMenu,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.9,
                child: child ?? Container(
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text('중간 80%', style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 1.0],
                      colors: [
                        Color(0xFFFF9408), // 0%
                        Color(0xFF95122C), // 100%
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 