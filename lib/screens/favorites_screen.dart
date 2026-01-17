import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/characters_provider.dart';
import '../widgets/character_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _sort = 'Имя';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharactersProvider>();

    if (provider.favorites.isEmpty) {
      return const Center(
        child: Text(
          'Нет избранных персонажей',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: DropdownButton<String>(
            value: _sort,
            items: const [
              DropdownMenuItem(value: 'Имя', child: Text('По имени')),
              DropdownMenuItem(value: 'Статус', child: Text('По статусу')),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _sort = value);
              value == 'Имя'
                  ? provider.sortFavoritesByName()
                  : provider.sortFavoritesByStatus();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final character = provider.favorites[index];
              return CharacterCard(
                character: character,
                isFavorite: true,
                onFavoriteTap: () => provider.toggleFavorite(character),
              );
            },
          ),
        ),
      ],
    );
  }
}
