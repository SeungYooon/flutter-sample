import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pokemon_item.dart';
import '../model/pokemon_detail.dart';

class ApiService {
  static Future<List<PokemonItem>> fetchPokemonList() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body)['results'];
      return results.map((e) => PokemonItem.fromJson(e)).toList();
    } else {
      throw Exception('포켓몬 목록 로드 실패');
    }
  }

  static Future<PokemonDetail> fetchPokemonDetail(String name) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PokemonDetail.fromJson(json);
    } else {
      throw Exception('포켓몬 상세정보 로드 실패');
    }
  }
}
