import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/characters_provider.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<CharactersProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadCharacters();
    });

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        provider.loadCharacters();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharactersProvider>();

    if (provider.characters.isEmpty && provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _controller,
      itemCount: provider.characters.length + (provider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= provider.characters.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final character = provider.characters[index];

        return CharacterCard(
          character: character,
          isFavorite: provider.isFavorite(character),
          onFavoriteTap: () => provider.toggleFavorite(character),
        );
      },
    );
  }
}
