import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';

final itemProvider = StateNotifierProvider.family<ItemNotifier, Item, String>((ref, userId) => ItemNotifier(userId));

class ItemNotifier extends StateNotifier<Item> {
  ItemNotifier(String userId) : super(Item(userId: userId));

  void useFilm() {
    if (state.film > 0) {
      state = Item(userId: state.userId, film: state.film - 1, specialFilm: state.specialFilm);
    }
  }

  void useSpecialFilm() {
    if (state.specialFilm > 0) {
      state = Item(userId: state.userId, film: state.film, specialFilm: state.specialFilm - 1);
    }
  }

  void addFilm(int count) {
    state = Item(userId: state.userId, film: state.film + count, specialFilm: state.specialFilm);
  }

  void addSpecialFilm(int count) {
    state = Item(userId: state.userId, film: state.film, specialFilm: state.specialFilm + count);
  }
} 