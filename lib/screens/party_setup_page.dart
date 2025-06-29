import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/barmon_provider.dart';
import '../providers/party_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PartySetupPage extends ConsumerStatefulWidget {
  const PartySetupPage({Key? key}) : super(key: key);
  @override
  ConsumerState<PartySetupPage> createState() => _PartySetupPageState();
}

class _PartySetupPageState extends ConsumerState<PartySetupPage> {
  List<String> selectedIds = [];

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(partyProvider.notifier).fetchParty(user.id).then((_) {
          setState(() {
            selectedIds = List<String>.from(ref.read(partyProvider));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final barmons = ref.watch(barMonListProvider); // 내 바몬 리스트 Provider
    return Scaffold(
      appBar: AppBar(title: const Text('파티 구성')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: barmons.length,
                itemBuilder: (context, idx) {
                  final barmon = barmons[idx];
                  final selected = selectedIds.contains(barmon.id);
                  return ListTile(
                    leading: Image.asset(barmon.imageUrl, width: 40, errorBuilder: (c, e, s) => const Icon(Icons.catching_pokemon)),
                    title: Text(barmon.name),
                    subtitle: Text('Lv.${barmon.level}'),
                    trailing: Checkbox(
                      value: selected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            if (selectedIds.length < 3) {
                              selectedIds.add(barmon.id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('최대 3마리만 선택할 수 있습니다.')),
                              );
                            }
                          } else {
                            selectedIds.remove(barmon.id);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final user = Supabase.instance.client.auth.currentUser;
                  if (user != null) {
                    await ref.read(partyProvider.notifier).saveParty(user.id, selectedIds);
                  }
                  if (!mounted) return;
                  Navigator.of(this.context).pop();
                },
                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 