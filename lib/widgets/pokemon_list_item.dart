import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/pokemon_item.dart';

class PokemonListItem extends StatefulWidget {
  final PokemonItem pokemon;
  final VoidCallback onTap;

  const PokemonListItem({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  State<PokemonListItem> createState() => _PokemonListItemState();
}

class _PokemonListItemState extends State<PokemonListItem> {
  final favoritesBox = Hive.box('favoritesBox');
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = favoritesBox.get(widget.pokemon.name, defaultValue: false);
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      favoritesBox.put(widget.pokemon.name, isFavorite);
    });
  }

  String getPokemonImageUrl() {
    final id = widget.pokemon.url.split(
      '/',
    )[widget.pokemon.url.split('/').length - 2];
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Image.network(getPokemonImageUrl(), width: 50, height: 50),
        title: Text(widget.pokemon.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: toggleFavorite,
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
