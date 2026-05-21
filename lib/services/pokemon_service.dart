import 'package:dio/dio.dart';

class PokemonService {

  static getPokemon<String>(String pokemonId) {

    final dio = Dio();

    try {
      final responsio = dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonId');

    } catch (e) {

      print('Error fetching pokemon data: $e'); 
    }

}

}