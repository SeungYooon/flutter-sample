import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/pokemon_item.dart';
import '../services/api_service.dart';

class PokemonListViewModel
    extends StateNotifier<AsyncValue<List<PokemonItem>>> {
  final ApiService apiService;
  final Box favoritesBox;

  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isLoading = false;

  final List<PokemonItem> _pokemonList = [];

  PokemonListViewModel(this.apiService, this.favoritesBox)
    : super(const AsyncLoading()) {
    fetchPokemon();
  }

  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  Future<void> fetchPokemon() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    try {
      final newItems = await apiService.fetchPokemonListPaging(_offset, _limit);
      _pokemonList.addAll(newItems);
      _offset += _limit;
      if (newItems.length < _limit) _hasMore = false;
      state = AsyncData(_pokemonList);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoading = false;
    }
  }

  void toggleFavorite(String name) {
    final current = favoritesBox.get(name, defaultValue: false);
    favoritesBox.put(name, !current);
    // UI에 반영시키려면 강제로 state 갱신
    state = AsyncData(List.from(_pokemonList));
  }

  bool isFavorite(String name) {
    return favoritesBox.get(name, defaultValue: false);
  }
}
