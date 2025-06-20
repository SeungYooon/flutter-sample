class PokemonDetail {
  final String name;
  final int id;
  final List<String> types;
  final Map<String, int> stats;
  final String imageUrl;

  PokemonDetail({
    required this.name,
    required this.id,
    required this.types,
    required this.stats,
    required this.imageUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      name: json['name'],
      id: json['id'],
      types: (json['types'] as List)
          .map((e) => e['type']['name'] as String)
          .toList(),
      stats: Map.fromEntries(
        (json['stats'] as List).map(
          (e) => MapEntry(e['stat']['name'], e['base_stat']),
        ),
      ),
      imageUrl: json['sprites']['front_default'] ?? '',
    );
  }
}
