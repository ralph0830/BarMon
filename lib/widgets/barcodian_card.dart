// 바코디언 카드 위젯 (리스트용)
import 'package:flutter/material.dart';
import '../models/barcodian.dart';
import 'barcodian_badge.dart';

class BarcodianCard extends StatelessWidget {
  final Barcodian barcodian;
  final VoidCallback? onTap;
  const BarcodianCard({super.key, required this.barcodian, this.onTap});

  Color get cardColor {
    // 첫 번째 타입 기준으로 카드 배경색 결정
    switch (barcodian.types.first) {
      case BarcodianType.grass:
        return const Color(0xFF78C850);
      case BarcodianType.poison:
        return const Color(0xFFA040A0);
      case BarcodianType.fire:
        return const Color(0xFFF08030);
      case BarcodianType.water:
        return const Color(0xFF6890F0);
      case BarcodianType.electric:
        return const Color(0xFFF8D030);
      case BarcodianType.ground:
        return const Color(0xFFE0C068);
      case BarcodianType.rock:
        return const Color(0xFFB8A038);
      case BarcodianType.psychic:
        return const Color(0xFFF85888);
      case BarcodianType.ice:
        return const Color(0xFF98D8D8);
      case BarcodianType.bug:
        return const Color(0xFFA8B820);
      case BarcodianType.dragon:
        return const Color(0xFF7038F8);
      case BarcodianType.dark:
        return const Color(0xFF705848);
      case BarcodianType.steel:
        return const Color(0xFFB8B8D0);
      case BarcodianType.fairy:
        return const Color(0xFFEE99AC);
      case BarcodianType.normal:
        return const Color(0xFFA8A878);
      case BarcodianType.data:
        return Colors.blueGrey.shade400;
      case BarcodianType.metal:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barcodian.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: barcodian.types
                          .map((type) => BarcodianBadge(type: type))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Image.network(
                barcodian.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
