// 바코디언 StateNotifierProvider 및 동적 추가/생성 로직
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/barcodian.dart';
import '../utils/barcodian_generator.dart';

class BarcodianListNotifier extends StateNotifier<List<Barcodian>> {
  BarcodianListNotifier() : super(_initialBarcodians);

  static final List<Barcodian> _initialBarcodians = [
    // 기존 목업 데이터 (원하면 비워도 됨)
    Barcodian(
      id: '001',
      name: '바코사우르',
      types: [BarcodianType.grass, BarcodianType.poison],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
      level: 5,
      exp: 120,
      attack: 49,
      defense: 49,
      hp: 45,
      speed: 45,
      species: '씨앗',
      rarity: BarcodianRarity.normal,
    ),
    Barcodian(
      id: '002',
      name: '바코이사우르',
      types: [BarcodianType.grass, BarcodianType.poison],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png',
      level: 16,
      exp: 300,
      attack: 62,
      defense: 63,
      hp: 60,
      speed: 60,
      species: '씨앗',
      rarity: BarcodianRarity.rare,
    ),
    Barcodian(
      id: '003',
      name: '바코플라워',
      types: [BarcodianType.grass, BarcodianType.poison],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png',
      level: 32,
      exp: 800,
      attack: 82,
      defense: 83,
      hp: 80,
      speed: 80,
      species: '씨앗',
      rarity: BarcodianRarity.epic,
    ),
    Barcodian(
      id: '004',
      name: '바코드래곤',
      types: [BarcodianType.fire],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png',
      level: 5,
      exp: 110,
      attack: 52,
      defense: 43,
      hp: 39,
      speed: 65,
      species: '도마뱀',
      rarity: BarcodianRarity.normal,
    ),
    Barcodian(
      id: '009',
      name: '바코토이즈',
      types: [BarcodianType.water],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png',
      level: 36,
      exp: 1000,
      attack: 83,
      defense: 100,
      hp: 79,
      speed: 78,
      species: '거북',
      rarity: BarcodianRarity.legend,
    ),
  ];

  void addBarcodianFromScan({
    required String barcode,
    required String accountId,
    bool isBusiness = false,
    String? businessPrefix,
  }) {
    final newBarcodian = generateBarcodian(
      barcode: barcode,
      accountId: accountId,
      isBusiness: isBusiness,
      businessPrefix: businessPrefix,
    );
    // 중복 방지(동일 id 존재 시 추가 안함)
    if (!state.any((b) => b.id == newBarcodian.id)) {
      state = [...state, newBarcodian];
    }
  }
}

final barcodianListProvider = StateNotifierProvider<BarcodianListNotifier, List<Barcodian>>(
  (ref) => BarcodianListNotifier(),
);
