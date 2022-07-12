import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/pokemon_state.dart';

import '../view_model/pokemon_view_model.dart';

class PokemonListScreen extends ConsumerWidget {
  const PokemonListScreen({Key? key}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonState = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphQL Pokemon"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          var pokemon = pokemonState[index];
          return dispPokemon(pokemon: pokemon);
        },
        separatorBuilder: (context, index) => Container(),
        itemCount: pokemonState.length,
      ),
    );
  }

  ///
  Widget dispPokemon({required PokemonState pokemon}) {
    return Card(
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(pokemon.image),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(pokemon.classification),
                      Wrap(
                        children: pokemon.types
                            .map((val) => Text('[$val] '))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Text('${pokemon.maxHP} / ${pokemon.maxCP}'),
                      Text(
                        '${pokemon.height['minimum']} - ${pokemon.height['maximum']}',
                      ),
                      Text(
                        '${pokemon.weight['minimum']} - ${pokemon.weight['maximum']}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (pokemon.attack.fast.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Attack(fast)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: pokemon.attack.fast.map((val) {
                        return Row(
                          children: [
                            Expanded(child: Text(val.attack['name'])),
                            Expanded(
                              child: Text(
                                '${val.attack['type']} / ${val.attack['damage']}',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            if (pokemon.attack.special.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Attack(special)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: pokemon.attack.special.map((val) {
                        return Row(
                          children: [
                            Expanded(child: Text(val.attack['name'])),
                            Expanded(
                              child: Text(
                                '${val.attack['type']} / ${val.attack['damage']}',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            if (pokemon.resistant.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'resistant',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: pokemon.resistant
                          .map((val) => Text('[$val] '))
                          .toList(),
                    ),
                  ],
                ),
              ),
            if (pokemon.weaknesses.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'weaknesses',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: pokemon.weaknesses
                          .map((val) => Text('[$val] '))
                          .toList(),
                    ),
                  ],
                ),
              ),
            if (pokemon.evolutions.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'evolutions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        '${pokemon.evolutionRequirements['name']}(${pokemon.evolutionRequirements['amount']})'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: pokemon.evolutions.map((val) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(val.image),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(val.name),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
