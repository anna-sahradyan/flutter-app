import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/character.dart';

class CharacterResponse {
  final List<Character> characters;
  final int maxPage;

  CharacterResponse({required this.characters, required this.maxPage});
}

class ApiService {
  static const _url = 'https://rickandmortyapi.com/api/character';

  Future<CharacterResponse> fetchCharactersWithInfo(int page) async {
    final response = await http.get(Uri.parse('$_url?page=$page'));

    if (response.statusCode != 200) {
      throw Exception('API error');
    }

    final data = json.decode(response.body);
    final characters = (data['results'] as List)
        .map((e) => Character.fromJson(e))
        .toList();

    return CharacterResponse(
      characters: characters,
      maxPage: data['info']['pages'],
    );
  }
}
