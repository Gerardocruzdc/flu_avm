import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonScreen extends StatelessWidget {

  final String pokemonId;

  const PokemonScreen({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nombre del Pokemon'),
      ),
      body: Center(
        child: Text('Datos del pokemon $pokemonId', style: GoogleFonts.russoOne(fontSize: 22), ),
      ),
    );
  }
}