// 바몬 생성 유틸리티 (시드/능력치/속성/희귀도 등)
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/barmon.dart';

// 비즈니스 바코드 예시 패턴 (prefix, DB 등으로 확장 가능)
bool isBusinessBarcode(String barcode) {
  return barcode.startsWith('BIZ_') || barcode.startsWith('EVENT_');
}

String generateSeed({
  required String barcode,
  required String accountId,
  bool isBusiness = false,
  String? businessPrefix,
}) {
  final input = isBusiness
      ? '${businessPrefix ?? "BIZ_"}$barcode'
      : '$accountId|$barcode';
  final hash = sha256.convert(utf8.encode(input)).toString();
  return hash; // 64자리 16진수
}

BarMon generateBarMon({
  required String barcode,
  required String accountId,
  bool isBusiness = false,
  String? businessPrefix,
}) {
  final seed = generateSeed(
    barcode: barcode,
    accountId: accountId,
    isBusiness: isBusiness,
    businessPrefix: businessPrefix,
  );
  // 해시값에서 능력치/속성/희귀도/종족 등 추출 (예시)
  int hex(String s) => int.parse(s, radix: 16);
  // 종족 결정 (0~15)
  final speciesIdx = hex(seed.substring(0, 2)) % 8;
  final speciesList = ['씨앗', '도마뱀', '거북', '벌레', '용', '고양이', '늑대', '로봇'];
  final species = speciesList[speciesIdx];
  // 속성 결정 (2개)
  final typeIdx1 = hex(seed.substring(2, 4)) % BarMonType.values.length;
  final typeIdx2 = hex(seed.substring(4, 6)) % BarMonType.values.length;
  final types = typeIdx1 == typeIdx2
      ? [BarMonType.values[typeIdx1]]
      : [BarMonType.values[typeIdx1], BarMonType.values[typeIdx2]];
  // 희귀도
  final rarityIdx = hex(seed.substring(6, 8)) % BarMonRarity.values.length;
  final rarity = BarMonRarity.values[rarityIdx];
  // 능력치
  final attack = 30 + hex(seed.substring(8, 10)) % 71; // 30~100
  final defense = 30 + hex(seed.substring(10, 12)) % 71;
  final hp = 50 + hex(seed.substring(12, 14)) % 101; // 50~150
  final speed = 20 + hex(seed.substring(14, 16)) % 81; // 20~100
  const level = 1;
  const exp = 0;
  // id는 seed 앞 12자리
  final id = seed.substring(0, 12);
  // 이름(임시: 종족+속성)
  final name = '${species}_${types.map((t) => t.displayName).join('_')}';
  return BarMon(
    id: id,
    name: name,
    engName: name, // 임시: 영문명은 name과 동일하게
    types: types,
    level: level,
    exp: exp,
    attack: attack,
    defense: defense,
    hp: hp,
    speed: speed,
    agility: 50, // 임시값
    luck: 50,    // 임시값
    species: species,
    rarity: rarity,
    nature: '밸런스형', // 임시값
    trait: '기본',     // 임시값
    potential: 50,    // 임시값
    starGrade: 1,     // 임시값
    attribute: getAttributeFromType(types.first),
  );
}

String getAttributeFromType(BarMonType type) {
  switch (type) {
    case BarMonType.fire: return '불';
    case BarMonType.water: return '물';
    case BarMonType.electric: return '전기';
    case BarMonType.ground: return '땅';
    case BarMonType.ice: return '얼음';
    case BarMonType.poison: return '독';
    case BarMonType.steel: return '철';
    case BarMonType.fairy: return '빛';
    case BarMonType.dark: return '어둠';
    case BarMonType.grass: return '식물';
    default: return '';
  }
}
