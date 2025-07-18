import 'package:flutter/material.dart';
import 'dart:math';
import 'base_page.dart';
import '../providers/barmon_provider.dart';
import '../models/barmon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/party_provider.dart';

class BattleArenaPage extends ConsumerStatefulWidget {
  final VoidCallback onMenu;
  const BattleArenaPage({Key? key, required this.onMenu}) : super(key: key);

  @override
  ConsumerState<BattleArenaPage> createState() => _BattleArenaPageState();
}

class _BattleArenaPageState extends ConsumerState<BattleArenaPage> {
  late List<BarMon> playerMains; // 메인 2마리
  BarMon? playerSupport; // 서포트 1마리
  int mainIdx = 0; // 현재 출전 중인 메인 바몬 인덱스
  late BarMon ai;
  late int playerHp;
  late int aiHp;
  late int supportCooldown;
  late int switchCooldown;
  List<String> logs = [];
  bool battleOver = false;
  String result = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initBattle();
      _initialized = true;
    }
  }

  void _initBattle() {
    final party = ref.read(partyProvider);
    final barmons = ref.read(barMonListProvider);
    // 파티에서 메인 2마리, 서포트 1마리 추출
    playerMains = [];
    playerSupport = null;
    if (party.isNotEmpty) {
      for (var i = 0; i < party.length && i < 2; i++) {
        final b = barmons.firstWhere((bm) => bm.id == party[i], orElse: () => barmons[0]);
        playerMains.add(b);
      }
      if (party.length > 2) {
        if (barmons.isNotEmpty) {
          playerSupport = barmons.firstWhere((bm) => bm.id == party[2], orElse: () => barmons[0]);
        } else {
          playerSupport = null;
        }
      }
    }
    if (playerMains.isEmpty) {
      setState(() {});
      return;
    }
    mainIdx = 0;
    ai = barmons[Random().nextInt(barmons.length)];
    playerHp = playerMains[mainIdx].hp;
    aiHp = ai.hp;
    supportCooldown = 0;
    switchCooldown = 0;
    logs = ['전투 시작!'];
    battleOver = false;
    result = '';
    setState(() {});
  }

  void _playerAttack() {
    if (battleOver) return;
    final random = Random();
    final playerDmg = max(10, playerMains[mainIdx].attack + random.nextInt(20) - 10);
    aiHp = max(0, aiHp - playerDmg);
    logs.insert(0, '내 바몬이 공격! ($playerDmg 데미지)');
    if (aiHp <= 0) {
      logs.insert(0, '승리! AI 바몬을 쓰러뜨렸습니다.');
      battleOver = true;
      result = '승리!';
      setState(() {});
      return;
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 600), _aiAttack);
  }

  void _aiAttack() {
    if (battleOver) return;
    final random = Random();
    final aiDmg = max(10, ai.attack + random.nextInt(20) - 10);
    playerHp = max(0, playerHp - aiDmg);
    logs.insert(0, 'AI 바몬이 반격! ($aiDmg 데미지)');
    if (playerHp <= 0) {
      logs.insert(0, '패배... 내 바몬이 쓰러졌습니다.');
      battleOver = true;
      result = '패배...';
    }
    setState(() {});
  }

  void _switchMain() {
    if (battleOver || switchCooldown > 0 || playerMains.length < 2) return;
    mainIdx = 1 - mainIdx;
    playerHp = playerMains[mainIdx].hp;
    switchCooldown = 10; // 10초 쿨타임
    logs.insert(0, '바몬 교체! (${playerMains[mainIdx].name} 출전)');
    setState(() {});
    _startSwitchCooldown();
  }

  void _startSwitchCooldown() async {
    while (switchCooldown > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        switchCooldown--;
      });
    }
  }

  void _useSupport() {
    if (battleOver || supportCooldown > 0 || playerSupport == null) return;
    logs.insert(0, '서포트 바몬 발동! (${playerSupport!.name}의 힐)');
    playerHp = min(playerMains[mainIdx].hp, playerHp + 30); // 임시: 30 회복
    supportCooldown = 15; // 15초 쿨타임
    setState(() {});
    _startSupportCooldown();
  }

  void _startSupportCooldown() async {
    while (supportCooldown > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        supportCooldown--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (playerMains.isEmpty) {
      return const Center(child: Text('파티에 바몬이 없습니다. 파티를 먼저 구성하세요.'));
    }
    final player = playerMains[mainIdx];
    return BasePage(
      title: '배틀 아레나',
      onMenu: widget.onMenu,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 상단: 바몬 이름, HP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _barmonInfo(player.name, playerHp, player.hp, isPlayer: true),
                _barmonInfo(ai.name, aiHp, ai.hp, isPlayer: false),
              ],
            ),
            const SizedBox(height: 16),
            // 중앙: 바몬 이미지(2마리, 교체)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _barmonImage(player),
                  const Icon(Icons.flash_on, size: 40, color: Colors.orange),
                  _barmonImage(ai),
                ],
              ),
            ),
            // 서포트 바몬 아이콘/쿨타임
            if (playerSupport != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield, color: Colors.green, size: 24),
                    const SizedBox(width: 4),
                    Text('서포트: ${playerSupport!.name}'),
                    const SizedBox(width: 8),
                    supportCooldown > 0
                        ? Text('쿨타임: $supportCooldown초', style: const TextStyle(color: Colors.red))
                        : ElevatedButton(
                            onPressed: _useSupport,
                            child: const Text('서포트 발동'),
                          ),
                  ],
                ),
              ),
            // 하단: 버튼/로그
            if (!battleOver) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _playerAttack,
                    child: const Text('공격'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: (switchCooldown == 0 && playerMains.length > 1) ? _switchMain : null,
                    child: switchCooldown > 0 ? Text('교체( $switchCooldown)') : const Text('교체'),
                  ),
                ],
              ),
            ],
            Text(result, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: _initBattle,
              child: const Text('재시작'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((255 * 0.05).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  reverse: true,
                  children: logs.take(10).map((e) => Text(e, key: ValueKey(e))).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barmonInfo(String name, int hp, int maxHp, {required bool isPlayer}) {
    return Column(
      crossAxisAlignment: isPlayer ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(isPlayer ? '내 바몬: $name' : 'AI: $name', style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: hp / maxHp,
            backgroundColor: Colors.grey[300],
            color: isPlayer ? Colors.blue : Colors.red,
          ),
        ),
        Text('$hp / $maxHp'),
      ],
    );
  }

  Widget _barmonImage(BarMon b) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(b.name, style: const TextStyle(fontSize: 14)),
    );
  }
} 