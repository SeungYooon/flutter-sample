import 'package:dio/dio.dart';
import '../model/pokemon_item.dart';
import '../model/pokemon_detail.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<List<PokemonItem>> fetchPokemonList() async {
    final response = await dio.get(
      'https://pokeapi.co/api/v2/pokemon?limit=50',
    );

    if (response.statusCode == 200) {
      final List results = response.data['results'];
      return results.map((e) => PokemonItem.fromJson(e)).toList();
    } else {
      throw Exception('포켓몬 목록 로드 실패');
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(String name) async {
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$name');

    if (response.statusCode == 200) {
      return PokemonDetail.fromJson(response.data);
    } else {
      throw Exception('포켓몬 상세정보 로드 실패');
    }
  }

  Future<List<PokemonItem>> fetchPokemonListPaging(
    int offset,
    int limit,
  ) async {
    final response = await dio.get(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {'offset': offset, 'limit': limit},
    );

    if (response.statusCode == 200) {
      final List results = response.data['results'];
      return results.map((json) => PokemonItem.fromJson(json)).toList();
    } else {
      throw Exception('포켓몬 리스트 로드 실패');
    }
  }
}
