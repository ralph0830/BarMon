// 바코디언 속성 뱃지 위젯
import 'package:flutter/material.dart';
import '../models/barcodian.dart';

class BarcodianBadge extends StatelessWidget {
  final BarcodianType type;
  const BarcodianBadge({super.key, required this.type});

  Color get typeColor {
    switch (type) {
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
        return Colors.blueGrey;
      case BarcodianType.metal:
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
        type.displayName,
        style: TextStyle(
          color: typeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
