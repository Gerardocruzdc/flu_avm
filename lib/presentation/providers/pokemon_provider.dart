import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/config.dart';
import '../../services/pokemon_service.dart';

final pokemonProvider = FutureProvider.family<Pokemon, String>((ref, id) async {

  final (pokemon, error) = await PokemonService.getPokemon(id);

  if (pokemon != null) return pokemon;
  else throw error;
 
});  