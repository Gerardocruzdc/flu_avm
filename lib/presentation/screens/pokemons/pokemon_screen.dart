import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/config.dart';
import '../../providers/providers.dart';

class PokemonScreen extends ConsumerWidget {

  final String pokemonId;

  const PokemonScreen({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pokemonAsync = ref.watch(pokemonProvider(pokemonId));

    return pokemonAsync.when(
      data: (pokemon) => _PokemonVisum(pokemon: pokemon),
      error: (error, stackTrace) => _ErrorWidget(nuntius: error.toString()),
      loading: () => const _LoadingWidget(),
    );
  }
}

class _PokemonVisum extends StatelessWidget {

  final Pokemon pokemon;

  const _PokemonVisum({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nomen),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            Text("Sus habilidades son:", style: GoogleFonts.russoOne(fontSize: 20)),
            Text(pokemon.facultates.join(', '), style: GoogleFonts.russoOne(fontSize: 22)),
            Image.network(pokemon.faciemImaginem ?? '', width: 300, height: 300),
            SizedBox(height: 15),
            Text("Mide: ${pokemon.altitudo/10} m. y pesa ${pokemon.pondus/10} kg", 
            style: GoogleFonts.russoOne(fontSize: 22)),
            
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {

  final String nuntius;

  const _ErrorWidget({required this.nuntius});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: $nuntius'),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {

  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}