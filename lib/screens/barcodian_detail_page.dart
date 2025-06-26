// 바코디언 상세 페이지
import 'package:flutter/material.dart';
import '../models/barcodian.dart';
import '../widgets/barcodian_badge.dart';

class BarcodianDetailPage extends StatelessWidget {
  final Barcodian barcodian;
  const BarcodianDetailPage({super.key, required this.barcodian});

  Color get mainColor {
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
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(barcodian.name),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: 120,
                color: Colors.white,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        barcodian.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ...barcodian.types.map((type) => BarcodianBadge(type: type)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '희귀도: ${barcodian.rarity.displayName}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Image.network(
                      barcodian.imageUrl,
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _InfoRow(label: '레벨', value: barcodian.level.toString()),
                  _InfoRow(label: '경험치', value: barcodian.exp.toString()),
                  _InfoRow(label: '공격력', value: barcodian.attack.toString()),
                  _InfoRow(label: '방어력', value: barcodian.defense.toString()),
                  _InfoRow(label: '체력', value: barcodian.hp.toString()),
                  _InfoRow(label: '속도', value: barcodian.speed.toString()),
                  _InfoRow(label: '종족', value: barcodian.species),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// 하단 웨이브 효과용 커스텀 클리퍼
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2, size.height, size.width, size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
