import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pokemon_detail.dart';
import '../providers.dart'; // ApiService provider 선언 위치

class DetailScreen extends ConsumerStatefulWidget {
  final String pokemonName;

  const DetailScreen({super.key, required this.pokemonName});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late Future<PokemonDetail> _futureDetail;

  @override
  void initState() {
    super.initState();
    final apiService = ref.read(apiServiceProvider);
    _futureDetail = apiService.fetchPokemonDetail(widget.pokemonName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pokemonName)),
      body: FutureBuilder<PokemonDetail>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('상세 정보 로드 실패: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('데이터가 없습니다.'));
          }

          final detail = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (detail.imageUrl.isNotEmpty)
                  Image.network(detail.imageUrl, width: 150, height: 150),
                const SizedBox(height: 16),
                Text(
                  detail.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('ID: ${detail.id}'),
                const SizedBox(height: 8),
                Text('Types: ${detail.types.join(', ')}'),
                const SizedBox(height: 16),
                const Text(
                  'Stats',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: detail.stats.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key.toUpperCase()),
                            Text(entry.value.toString()),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
