// 바몬 속성 뱃지 위젯
import 'package:flutter/material.dart';
import '../models/barmon.dart';

class BarMonBadge extends StatelessWidget {
  final BarMonType barMonType;
  const BarMonBadge({super.key, required this.barMonType});

  Color get typeColor {
    switch (barMonType) {
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
        return Colors.blueGrey;
      case BarMonType.metal:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.15),
        border: Border.all(color: typeColor, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        barMonType.displayName,
        style: TextStyle(
          color: typeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
