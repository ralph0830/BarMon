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

  factory BarMon.fromJson(Map<String, dynamic> json) {
    return BarMon(
      id: json['id'] as String,
      name: json['name'] as String,
      engName: json['eng_name'] as String,
      types: (json['types'] as List<dynamic>).map((e) => BarMonType.values.firstWhere((t) => t.name.toLowerCase() == (e as String).toLowerCase(), orElse: () => BarMonType.normal)).toList(),
      imageUrl: json['image_url'] as String,
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
    'image_url': imageUrl,
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
