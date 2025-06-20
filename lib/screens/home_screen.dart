import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'detail_screen.dart';
import '../providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final notifier = ref.read(pokemonListProvider.notifier);
      final state = ref.read(pokemonListProvider);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !notifier.isLoading &&
          notifier.hasMore) {
        notifier.fetchPokemon();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pokemonListAsync = ref.watch(pokemonListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('포켓몬 리스트')),
      body: pokemonListAsync.when(
        data: (list) {
          return ListView.builder(
            controller: _scrollController,
            itemCount:
                list.length +
                (ref.read(pokemonListProvider.notifier).hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= list.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final pokemon = list[index];
              final id = index + 1;
              final imageUrl =
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

              final isFavorite = ref
                  .read(pokemonListProvider.notifier)
                  .isFavorite(pokemon.name);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(imageUrl, width: 50, height: 50),
                  title: Text(pokemon.name),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => ref
                        .read(pokemonListProvider.notifier)
                        .toggleFavorite(pokemon.name),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('에러 발생: $error')),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
