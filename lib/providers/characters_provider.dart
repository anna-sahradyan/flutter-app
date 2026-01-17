import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/character.dart';
import '../services/api_service.dart';

class CharactersProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  final List<Character> characters = [];
  final List<Character> favorites = [];

  int _page = 1;
  int _maxPage = 0;
  bool isLoading = false;

  CharactersProvider() {
    loadFavorites();
    loadCachedCharacters();
  }

  Future<void> loadCharacters() async {
    if (isLoading) return;
    if (_maxPage != 0 && _page > _maxPage) return;

    isLoading = true;
    notifyListeners();

    final box = Hive.box('characters');
    List<Character> fetched = [];

    try {
      final response = await _api.fetchCharactersWithInfo(_page);
      fetched = response.characters;
      _maxPage = response.maxPage;

      for (var c in fetched) {
        box.put(c.id, c.toMap());
      }
    } catch (_) {
      if (characters.isEmpty && box.isNotEmpty) {
        fetched = box.values
            .map((e) => Character.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    final ids = characters.map((e) => e.id).toSet();
    characters.addAll(fetched.where((c) => !ids.contains(c.id)));

    _page++;
    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(Character character) {
    final box = Hive.box('favorites');

    if (isFavorite(character)) {
      favorites.removeWhere((c) => c.id == character.id);
      box.delete(character.id);
    } else {
      favorites.add(character);
      box.put(character.id, character.toMap());
    }
    notifyListeners();
  }

  bool isFavorite(Character character) =>
      favorites.any((c) => c.id == character.id);

  void loadFavorites() {
    final box = Hive.box('favorites');
    favorites
      ..clear()
      ..addAll(
        box.values.map((e) => Character.fromJson(Map<String, dynamic>.from(e))),
      );
    notifyListeners();
  }

  void loadCachedCharacters() {
    final box = Hive.box('characters');
    characters
      ..clear()
      ..addAll(
        box.values.map((e) => Character.fromJson(Map<String, dynamic>.from(e))),
      );
    notifyListeners();
  }

  void sortFavoritesByName() {
    favorites.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void sortFavoritesByStatus() {
    favorites.sort((a, b) => a.status.compareTo(b.status));
    notifyListeners();
  }
}
