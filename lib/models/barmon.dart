// 바몬(Barcodian) 데이터 모델
// 레퍼런스 이미지와 PRD를 기반으로 설계


enum BarMonType {
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

extension BarMonTypeExtension on BarMonType {
  String get displayName {
    switch (this) {
      case BarMonType.grass:
        return 'Grass';
      case BarMonType.poison:
        return 'Poison';
      case BarMonType.fire:
        return 'Fire';
      case BarMonType.water:
        return 'Water';
      case BarMonType.electric:
        return 'Electric';
      case BarMonType.ground:
        return 'Ground';
      case BarMonType.rock:
        return 'Rock';
      case BarMonType.psychic:
        return 'Psychic';
      case BarMonType.ice:
        return 'Ice';
      case BarMonType.bug:
        return 'Bug';
      case BarMonType.dragon:
        return 'Dragon';
      case BarMonType.dark:
        return 'Dark';
      case BarMonType.steel:
        return 'Steel';
      case BarMonType.fairy:
        return 'Fairy';
      case BarMonType.normal:
        return 'Normal';
      case BarMonType.data:
        return 'Data';
      case BarMonType.metal:
        return 'Metal';
    }
  }
}

enum BarMonRarity {
  normal,
  rare,
  epic,
  legend,
}

extension BarMonRarityExtension on BarMonRarity {
  String get displayName {
    switch (this) {
      case BarMonRarity.normal:
        return '노멀';
      case BarMonRarity.rare:
        return '레어';
      case BarMonRarity.epic:
        return '에픽';
      case BarMonRarity.legend:
        return '레전드';
    }
  }
}

class BarMon {
  final String id;
  final String name;
  final String engName; // 영문명
  final List<BarMonType> types;
  final String imageUrl;
  final int level;
  final int exp;
  final int attack;
  final int defense;
  final int hp;
  final int speed;
  final int agility; // 민첩
  final int luck;    // 행운
  final String species;
  final BarMonRarity rarity;
  final String nature;    // 성격
  final String trait;     // 성향
  final int potential;    // 잠재력
  final int starGrade;    // 별 등급(1~6)
  final String attribute; // 속성(타입과 별개, ex: '불', '물', '철', '야수형' 등)

  BarMon({
    required this.id,
    required this.name,
    required this.engName,
    required this.types,
    required this.imageUrl,
    required this.level,
    required this.exp,
    required this.attack,
    required this.defense,
    required this.hp,
    required this.speed,
    required this.agility,
    required this.luck,
    required this.species,
    required this.rarity,
    required this.nature,
    required this.trait,
    required this.potential,
    required this.starGrade,
    required this.attribute,
  });
}
