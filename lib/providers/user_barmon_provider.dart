import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/barmon.dart';

final userBarmonProvider = StateNotifierProvider<UserBarmonNotifier, List<BarMon>>((ref) => UserBarmonNotifier());

class UserBarmonNotifier extends StateNotifier<List<BarMon>> {
  UserBarmonNotifier() : super([]);

  final _client = Supabase.instance.client;

  Future<void> fetchUserBarmons(String userId) async {
    final response = await _client
        .from('user_barmon')
        .select()
        .eq('user_id', userId)
        .order('created_at')
        .withConverter<List<Map<String, dynamic>>>((data) => List<Map<String, dynamic>>.from(data));
    state = response
        .map((json) => BarMon.fromJson(json))
        .toList();
  }

  Future<void> addUserBarmon(BarMon barMon, String userId) async {
    final data = barMon.toJson();
    data['user_id'] = userId;
    data['created_at'] = DateTime.now().toIso8601String();
    await _client.from('user_barmon').insert(data);
    await fetchUserBarmons(userId);
  }

  Future<void> deleteUserBarmon(String barmonId, String userId) async {
    await _client
        .from('user_barmon')
        .delete()
        .eq('id', barmonId);
    await fetchUserBarmons(userId);
  }
} 