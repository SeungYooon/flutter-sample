import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/pokemon_item.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PokemonItem>> _futurePokemon;
  final favoritesBox = Hive.box('favoritesBox');

  @override
  void initState() {
    super.initState();
    _futurePokemon = ApiService.fetchPokemonList();
  }

  void toggleFavorite(String name) {
    setState(() {
      final current = favoritesBox.get(name, defaultValue: false);
      favoritesBox.put(name, !current);
    });
  }

  bool isFavorite(String name) {
    return favoritesBox.get(name, defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('포켓몬 리스트')),
      body: FutureBuilder<List<PokemonItem>>(
        future: _futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터 로드 실패: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('표시할 데이터가 없습니다.'));
          }

          final pokemonList = snapshot.data!;
          return ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              final id = index + 1; // 이미지 URL용 ID
              final imageUrl =
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(imageUrl, width: 50, height: 50),
                  title: Text(pokemon.name),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite(pokemon.name) ? Icons.star : Icons.star_border,
                      color: isFavorite(pokemon.name)
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    onPressed: () => toggleFavorite(pokemon.name),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(pokemonName: pokemon.name),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
