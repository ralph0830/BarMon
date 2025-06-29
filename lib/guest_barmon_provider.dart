import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/barmon.dart';
import 'package:flutter/foundation.dart';

final guestBarmonProvider = StateNotifierProvider<GuestBarmonNotifier, List<BarMon>>((ref) => GuestBarmonNotifier());

class GuestBarmonNotifier extends StateNotifier<List<BarMon>> {
  GuestBarmonNotifier() : super([]) {
    _loadGuestBarmons();
  }

  Future<void> _loadGuestBarmons() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('guest_barmon_list');
    debugPrint('[DEBUG] _loadGuestBarmons: SharedPreferences 값: $jsonStr');
    if (jsonStr != null) {
      final List list = json.decode(jsonStr);
      state = list.map((e) => BarMon.fromJson(e)).toList();
      debugPrint('[DEBUG] _loadGuestBarmons: state 로드됨, 개수: ${state.length}');
      for (final b in state) {
        debugPrint('  - ${b.id} / ${b.name}');
      }
    }
  }

  Future<void> _saveGuestBarmons() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString('guest_barmon_list', jsonStr);
    debugPrint('[DEBUG] _saveGuestBarmons: 저장값: $jsonStr');
  }

  Future<void> addGuestBarmon(BarMon barMon) async {
    debugPrint('[DEBUG] addGuestBarmon 호출: 추가할 바몬: ${barMon.id} / ${barMon.name}');
    state = [...state, barMon];
    debugPrint('[DEBUG] addGuestBarmon: 추가 후 state:');
    for (final b in state) {
      debugPrint('  - ${b.id} / ${b.name}');
    }
    await _saveGuestBarmons();
  }

  Future<void> deleteGuestBarmon(String barmonId) async {
    state = state.where((e) => e.id != barmonId).toList();
    await _saveGuestBarmons();
  }
} 