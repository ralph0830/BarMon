import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/barmon.dart';

final guestBarmonProvider = StateNotifierProvider<GuestBarmonNotifier, List<BarMon>>((ref) => GuestBarmonNotifier());

class GuestBarmonNotifier extends StateNotifier<List<BarMon>> {
  GuestBarmonNotifier() : super([]) {
    _loadGuestBarmons();
  }

  Future<void> _loadGuestBarmons() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('guest_barmon_list');
    if (jsonStr != null) {
      final List list = json.decode(jsonStr);
      state = list.map((e) => BarMon.fromJson(e)).toList();
    }
  }

  Future<void> _saveGuestBarmons() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString('guest_barmon_list', jsonStr);
  }

  Future<void> addGuestBarmon(BarMon barMon) async {
    state = [...state, barMon];
    await _saveGuestBarmons();
  }

  Future<void> deleteGuestBarmon(String barmonId) async {
    state = state.where((e) => e.id != barmonId).toList();
    await _saveGuestBarmons();
  }
} 