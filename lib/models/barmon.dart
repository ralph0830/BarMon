// 바몬(Barcodian) 데이터 모델
// 레퍼런스 이미지와 PRD를 기반으로 설계

import 'package:flutter/material.dart';

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
  superRare,
  superSpecialRare,
  legendary,
}

extension BarMonRarityExtension on BarMonRarity {
  String get displayName {
    switch (this) {
      case BarMonRarity.normal:
        return 'N';
      case BarMonRarity.rare:
        return 'R';
      case BarMonRarity.superRare:
        return 'SR';
      case BarMonRarity.superSpecialRare:
        return 'SSR';
      case BarMonRarity.legendary:
        return 'L';
    }
  }

  Color get color {
    switch (this) {
      case BarMonRarity.normal:
        return const Color(0xFFB0BEC5);
      case BarMonRarity.rare:
        return const Color(0xFF42A5F5);
      case BarMonRarity.superRare:
        return const Color(0xFFAB47BC);
      case BarMonRarity.superSpecialRare:
        return const Color(0xFFFFA000);
      case BarMonRarity.legendary:
        return const Color(0xFFFFD600);
    }
  }

  static BarMonRarity fromString(String value) {
    switch (value.toLowerCase().replaceAll('_', ' ')) {
      case 'normal':
      case 'n':
        return BarMonRarity.normal;
      case 'rare':
      case 'r':
        return BarMonRarity.rare;
      case 'super rare':
      case 'superrare':
      case 'sr':
        return BarMonRarity.superRare;
      case 'super special rare':
      case 'superspecialrare':
      case 'ssr':
        return BarMonRarity.superSpecialRare;
      case 'legendary':
      case 'l':
        return BarMonRarity.legendary;
      default:
        return BarMonRarity.normal;
    }
  }
}

class BarMon {
  final String id;
  final String name;
  final String engName; // 영문명
  final List<BarMonType> types;
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

  // 숫자 id → UUID 매핑 테이블
  static const Map<String, String> _idToUuid = {
    "1": "2a401cec-0ff6-4f8b-9864-d55cb73b2fe7",
    "2": "b90a0ec0-2b6c-442e-a1b8-49475bc2e64a",
    "3": "507f6679-c08c-487b-a8ea-73a65b60370b",
    "4": "875d2833-3f08-489c-a009-e1dfaa364b51",
    "5": "c746f519-107f-4791-b00f-b5150676e6a0",
    "6": "d3d0e03c-7ae9-40bf-bcf7-cbff35e6d960",
    "7": "9ef1ec2b-eb02-4283-a10f-a55cbb13766f",
    "8": "3d37d8af-6171-4a5a-802b-c4f1797c96c6",
    "9": "0615d8ae-dcf1-4513-bb2c-44a55ab99506",
    "10": "29023384-a4b5-4ca6-9ef6-57535c88fbe1",
    "11": "29e28876-adff-45b7-87ac-364526e18f11",
    "12": "ce5c8ef5-ebe5-488e-8aeb-59b9a9661baa",
    "13": "fa77d243-1be5-4238-9d63-fab2c06bc553",
    "14": "c150591a-b033-4d64-adc9-af6365c2d64f",
    "15": "f534a3e4-c281-457f-a5dc-fe915823beb1",
    "16": "3b94192f-b682-4a24-8485-94f7cc3eb400",
    "17": "c415d263-0ada-45bb-be1f-9458629655f7",
    "18": "10f415a9-bcf8-44fa-a1af-a97ec694501a",
    "19": "3217c801-5e86-449d-ad9b-fe70ae578a5a",
    "20": "f0c4f30d-624d-4387-b9e0-8ad49e13c308"
  };

  String get portraitImageUrl {
    final folder = _idToUuid[id] ?? id;
    return 'assets/images/portrait/ /portrait.png'.replaceFirst('\u0000', folder);
  }

  String get fullImageUrl {
    final folder = _idToUuid[id] ?? id;
    return 'assets/images/portrait/ /full.png'.replaceFirst('\u0000', folder);
  }

  String get imageUrl => portraitImageUrl;

  BarMon({
    required this.id,
    required this.name,
    required this.engName,
    required this.types,
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

  factory BarMon.fromJson(Map<String, dynamic> json) {
    return BarMon(
      id: json['id'] as String,
      name: json['name'] as String,
      engName: json['eng_name'] as String,
      types: (json['types'] as List<dynamic>).map((e) => BarMonType.values.firstWhere((t) => t.name.toLowerCase() == (e as String).toLowerCase(), orElse: () => BarMonType.normal)).toList(),
      level: json['level'] as int,
      exp: json['exp'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      hp: json['hp'] as int,
      speed: json['speed'] as int,
      agility: json['agility'] as int,
      luck: json['luck'] as int,
      species: json['species'] as String,
      rarity: BarMonRarityExtension.fromString(json['rarity'] as String),
      nature: json['nature'] as String,
      trait: json['trait'] as String,
      potential: json['potential'] as int,
      starGrade: json['star_grade'] as int,
      attribute: json['attribute'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'eng_name': engName,
    'types': types.map((e) => e.name).toList(),
    'level': level,
    'exp': exp,
    'attack': attack,
    'defense': defense,
    'hp': hp,
    'speed': speed,
    'agility': agility,
    'luck': luck,
    'species': species,
    'rarity': rarity.name,
    'nature': nature,
    'trait': trait,
    'potential': potential,
    'star_grade': starGrade,
    'attribute': attribute,
  };
}
