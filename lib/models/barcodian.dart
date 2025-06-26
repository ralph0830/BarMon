// 바코디언(Barcodian) 데이터 모델
// 레퍼런스 이미지와 PRD를 기반으로 설계


enum BarcodianType {
  grass,
  poison,
  fire,
  water,
  electric,
  ground,
  rock,
  psychic,
  ice,
  bug,
  dragon,
  dark,
  steel,
  fairy,
  normal,
  // 특수 속성
  data,
  metal,
}

extension BarcodianTypeExtension on BarcodianType {
  String get displayName {
    switch (this) {
      case BarcodianType.grass:
        return 'Grass';
      case BarcodianType.poison:
        return 'Poison';
      case BarcodianType.fire:
        return 'Fire';
      case BarcodianType.water:
        return 'Water';
      case BarcodianType.electric:
        return 'Electric';
      case BarcodianType.ground:
        return 'Ground';
      case BarcodianType.rock:
        return 'Rock';
      case BarcodianType.psychic:
        return 'Psychic';
      case BarcodianType.ice:
        return 'Ice';
      case BarcodianType.bug:
        return 'Bug';
      case BarcodianType.dragon:
        return 'Dragon';
      case BarcodianType.dark:
        return 'Dark';
      case BarcodianType.steel:
        return 'Steel';
      case BarcodianType.fairy:
        return 'Fairy';
      case BarcodianType.normal:
        return 'Normal';
      case BarcodianType.data:
        return 'Data';
      case BarcodianType.metal:
        return 'Metal';
    }
  }
}

enum BarcodianRarity {
  normal,
  rare,
  epic,
  legend,
}

extension BarcodianRarityExtension on BarcodianRarity {
  String get displayName {
    switch (this) {
      case BarcodianRarity.normal:
        return '노멀';
      case BarcodianRarity.rare:
        return '레어';
      case BarcodianRarity.epic:
        return '에픽';
      case BarcodianRarity.legend:
        return '레전드';
    }
  }
}

class Barcodian {
  final String id;
  final String name;
  final List<BarcodianType> types;
  final String imageUrl;
  final int level;
  final int exp;
  final int attack;
  final int defense;
  final int hp;
  final int speed;
  final String species;
  final BarcodianRarity rarity;

  Barcodian({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.level,
    required this.exp,
    required this.attack,
    required this.defense,
    required this.hp,
    required this.speed,
    required this.species,
    required this.rarity,
  });
}
