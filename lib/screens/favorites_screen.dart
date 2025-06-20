import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/pokemon_detail.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favoritesBox = Hive.box('favoritesBox');

  @override
  Widget build(BuildContext context) {
    final favoriteNames = favoritesBox.keys
        .where((key) => favoritesBox.get(key) == true)
        .map((key) => key.toString())
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('즐겨찾기')),
      body: favoriteNames.isEmpty
          ? const Center(child: Text('즐겨찾기한 포켓몬이 없습니다.'))
          : ListView.builder(
              itemCount: favoriteNames.length,
              itemBuilder: (context, index) {
                final name = favoriteNames[index];
                return FutureBuilder<PokemonDetail>(
                  future: ApiService.fetchPokemonDetail(name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('로딩 중...'),
                        leading: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return ListTile(
                        title: Text(name),
                        subtitle: const Text('이미지 불러오기 실패'),
                      );
                    }

                    final detail = snapshot.data!;
                    return ListTile(
                      leading: Image.network(
                        detail.imageUrl,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(detail.name),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailScreen(pokemonName: detail.name),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
