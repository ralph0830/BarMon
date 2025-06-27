// 바몬 카드 위젯 (리스트용)
import 'package:flutter/material.dart';
import '../models/barmon.dart';

class BarMonCard extends StatelessWidget {
  final BarMon barMon;
  final VoidCallback? onTap;
  const BarMonCard({super.key, required this.barMon, this.onTap});

  Color get cardColor {
    // 첫 번째 타입 기준으로 카드 배경색 결정
    switch (barMon.types.first) {
      case BarMonType.grass:
        return const Color(0xFF78C850);
      case BarMonType.poison:
        return const Color(0xFFA040A0);
      case BarMonType.fire:
        return const Color(0xFFF08030);
      case BarMonType.water:
        return const Color(0xFF6890F0);
      case BarMonType.electric:
        return const Color(0xFFF8D030);
      case BarMonType.ground:
        return const Color(0xFFE0C068);
      case BarMonType.rock:
        return const Color(0xFFB8A038);
      case BarMonType.psychic:
        return const Color(0xFFF85888);
      case BarMonType.ice:
        return const Color(0xFF98D8D8);
      case BarMonType.bug:
        return const Color(0xFFA8B820);
      case BarMonType.dragon:
        return const Color(0xFF7038F8);
      case BarMonType.dark:
        return const Color(0xFF705848);
      case BarMonType.steel:
        return const Color(0xFFB8B8D0);
      case BarMonType.fairy:
        return const Color(0xFFEE99AC);
      case BarMonType.normal:
        return const Color(0xFFA8A878);
      case BarMonType.data:
        return Colors.blueGrey.shade400;
      case BarMonType.metal:
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
            // 왼쪽: portrait 이미지
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  barMon.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            // 오른쪽: 정보
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          barMon.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          barMon.rarity.displayName,
                          style: TextStyle(
                            color: barMon.rarity.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      barMon.species,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatIconText(label: 'HP', value: barMon.hp, icon: Icons.favorite),
                        const SizedBox(width: 12),
                        _StatIconText(label: '공격', value: barMon.attack, icon: Icons.flash_on),
                        const SizedBox(width: 12),
                        _StatIconText(label: '방어', value: barMon.defense, icon: Icons.shield),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatIconText extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  const _StatIconText({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 2),
        Text('$label $value', style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }
}
