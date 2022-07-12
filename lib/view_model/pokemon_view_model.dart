import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../state/pokemon_state.dart';

final pokemonProvider =
    StateNotifierProvider.autoDispose<PokemonStateNotifier, List<PokemonState>>(
        (ref) {
  return PokemonStateNotifier([])..getPokemonData();
});

class PokemonStateNotifier extends StateNotifier<List<PokemonState>> {
  PokemonStateNotifier(List<PokemonState> state) : super(state);

  ///
  void getPokemonData() async {
    HttpLink link = HttpLink("https://graphql-pokemon2.vercel.app/");

    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );

    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql("""
                
query {
  pokemons(first:1000) {
    id,
    number,
    name,
    classification,
    types,
    resistant,
    weaknesses,
    fleeRate,
    maxCP,
    maxHP,
    image,
    
    weight {
      minimum
      maximum
    },
    
    height {
      minimum
      maximum
    },
    
    attacks{
      fast{
        name
        type
        damage
      },
      
      special{
        name
        type
        damage
      }
    },
    
    evolutions {
      id
      number
      name
      classification
      image
      maxHP
      maxCP
    },
        
    evolutionRequirements {
      amount
      name
    },
    
  }
}
 
"""),
      ),
    );

    List<PokemonState> list = [];

    if (queryResult.data!['pokemons'] != null) {
      for (var i = 0; i < queryResult.data!['pokemons'].length; i++) {
        //---------------------------------------------//

        List<String> types = [];
        for (var j = 0;
            j < queryResult.data!['pokemons'][i]['types'].length;
            j++) {
          types.add(queryResult.data!['pokemons'][i]['types'][j] ?? "");
        }

        List<String> resistant = [];
        for (var j = 0;
            j < queryResult.data!['pokemons'][i]['resistant'].length;
            j++) {
          resistant.add(queryResult.data!['pokemons'][i]['resistant'][j] ?? "");
        }

        List<String> weaknesses = [];
        for (var j = 0;
            j < queryResult.data!['pokemons'][i]['weaknesses'].length;
            j++) {
          weaknesses
              .add(queryResult.data!['pokemons'][i]['weaknesses'][j] ?? "");
        }

        //---------------------------------------------//

        Map<String, String> height = {};
        height['minimum'] =
            queryResult.data!['pokemons'][i]['height']['minimum'] ?? "";
        height['maximum'] =
            queryResult.data!['pokemons'][i]['height']['maximum'] ?? "";

        Map<String, String> weight = {};
        weight['minimum'] =
            queryResult.data!['pokemons'][i]['weight']['minimum'] ?? "";
        weight['maximum'] =
            queryResult.data!['pokemons'][i]['weight']['maximum'] ?? "";

        Map<String, dynamic> evolutionRequirements = {};

        if (queryResult.data!['pokemons'][i]['evolutionRequirements'] != null) {
          evolutionRequirements['name'] = queryResult.data!['pokemons'][i]
                  ['evolutionRequirements']['name'] ??
              "";
          evolutionRequirements['amount'] = queryResult.data!['pokemons'][i]
                  ['evolutionRequirements']['amount'] ??
              "";
        }

        //---------------------------------------------//

        List<PokemonEvolutionState> evolutions = [];

        if (queryResult.data!['pokemons'][i]['evolutions'] != null) {
          for (var j = 0;
              j < queryResult.data!['pokemons'][i]['evolutions'].length;
              j++) {
            evolutions.add(
              PokemonEvolutionState(
                id: queryResult.data!['pokemons'][i]['evolutions'][j]['id'] ??
                    "",
                number: queryResult.data!['pokemons'][i]['evolutions'][j]
                        ['number'] ??
                    "",
                name: queryResult.data!['pokemons'][i]['evolutions'][j]
                        ['name'] ??
                    "",
                classification: queryResult.data!['pokemons'][i]['evolutions']
                        [j]['classification'] ??
                    "",
                image: queryResult.data!['pokemons'][i]['evolutions'][j]
                        ['image'] ??
                    "",
                maxHP: queryResult.data!['pokemons'][i]['evolutions'][j]
                        ['maxHP'] ??
                    0,
                maxCP: queryResult.data!['pokemons'][i]['evolutions'][j]
                        ['maxCP'] ??
                    0,
              ),
            );
          }
        }

        //---------------------------------------------//

        /////////////////////////////////////////////////////////
        List<PokemonAttackFastState> pokemonAttackFastState = [];
        for (var j = 0;
            j < queryResult.data!['pokemons'][i]['attacks']['fast'].length;
            j++) {
          Map<String, dynamic> fast = {};
          fast['name'] = queryResult.data!['pokemons'][i]['attacks']['fast'][j]
                  ['name'] ??
              "";
          fast['type'] = queryResult.data!['pokemons'][i]['attacks']['fast'][j]
                  ['type'] ??
              "";
          fast['damage'] = queryResult.data!['pokemons'][i]['attacks']['fast']
                  [j]['damage'] ??
              "";

          pokemonAttackFastState.add(
            PokemonAttackFastState(attack: fast),
          );
        }

        //

        List<PokemonAttackSpecialState> pokemonAttackSpecialState = [];
        for (var j = 0;
            j < queryResult.data!['pokemons'][i]['attacks']['special'].length;
            j++) {
          Map<String, dynamic> special = {};
          special['name'] = queryResult.data!['pokemons'][i]['attacks']
                  ['special'][j]['name'] ??
              "";
          special['type'] = queryResult.data!['pokemons'][i]['attacks']
                  ['special'][j]['type'] ??
              "";
          special['damage'] = queryResult.data!['pokemons'][i]['attacks']
                  ['special'][j]['damage'] ??
              "";

          pokemonAttackSpecialState.add(
            PokemonAttackSpecialState(attack: special),
          );
        }

        /////////////////////////////////////////////////////////

        list.add(
          PokemonState(
            id: queryResult.data!['pokemons'][i]['id'] ?? "",
            number: queryResult.data!['pokemons'][i]['number'] ?? "",
            name: queryResult.data!['pokemons'][i]['name'] ?? "",
            classification:
                queryResult.data!['pokemons'][i]['classification'] ?? "",
            image: queryResult.data!['pokemons'][i]['image'] ?? "",
            fleeRate: queryResult.data!['pokemons'][i]['fleeRate'] ?? "",
            maxHP: queryResult.data!['pokemons'][i]['maxHP'] ?? 0,
            maxCP: queryResult.data!['pokemons'][i]['maxCP'] ?? 0,
            types: types,
            resistant: resistant,
            weaknesses: weaknesses,
            height: height,
            weight: weight,
            evolutionRequirements: evolutionRequirements,
            evolutions: evolutions,
            attack: PokemonAttackState(
              fast: pokemonAttackFastState,
              special: pokemonAttackSpecialState,
            ),
          ),
        );
      }
    }

    state = list;
  }
}
