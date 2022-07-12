import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_state.freezed.dart';

@freezed
class PokemonState with _$PokemonState {
  const factory PokemonState({
    required String id,
    required String number,
    required String name,
    required String classification,
    required String image,
    required double fleeRate,
    required int maxHP,
    required int maxCP,
    required List<String> types,
    required List<String> resistant,
    required List<String> weaknesses,
    required Map<String, String> height,
    required Map<String, String> weight,
    required Map<String, dynamic> evolutionRequirements,
    required List<PokemonEvolutionState> evolutions,
    required PokemonAttackState attack,
  }) = _PokemonState;
}

@freezed
class PokemonEvolutionState with _$PokemonEvolutionState {
  const factory PokemonEvolutionState({
    required String id,
    required String number,
    required String name,
    required String classification,
    required String image,
    required int maxHP,
    required int maxCP,
  }) = _PokemonEvolutionState;
}

@freezed
class PokemonAttackState with _$PokemonAttackState {
  const factory PokemonAttackState({
    required List<PokemonAttackFastState> fast,
    required List<PokemonAttackSpecialState> special,
  }) = _PokemonAttackState;
}

@freezed
class PokemonAttackFastState with _$PokemonAttackFastState {
  const factory PokemonAttackFastState({
    required Map<String, dynamic> attack,
  }) = _PokemonAttackFastState;
}

@freezed
class PokemonAttackSpecialState with _$PokemonAttackSpecialState {
  const factory PokemonAttackSpecialState({
    required Map<String, dynamic> attack,
  }) = _PokemonAttackSpecialState;
}
