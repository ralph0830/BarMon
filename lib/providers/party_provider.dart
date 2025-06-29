import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final partyProvider = StateNotifierProvider<PartyNotifier, List<String>>(
  (ref) => PartyNotifier(),
);

class PartyNotifier extends StateNotifier<List<String>> {
  PartyNotifier() : super([]);

  final _client = Supabase.instance.client;

  // 파티 불러오기
  Future<void> fetchParty(String userId) async {
    final data = await _client
        .from('user_party')
        .select('party_ids')
        .eq('user_id', userId)
        .maybeSingle();
    if (data != null && data['party_ids'] != null) {
      state = List<String>.from(data['party_ids']);
    } else {
      state = [];
    }
  }

  // 파티 저장
  Future<void> saveParty(String userId, List<String> partyIds) async {
    await _client.from('user_party').upsert({
      'user_id': userId,
      'party_ids': partyIds,
      'updated_at': DateTime.now().toIso8601String(),
    });
    state = partyIds;
  }
} 