import 'package:flutter/material.dart';


class MenuItem{
  final String titulus;
  final String subtitulus;
  final String link;
  final IconData icon;

  MenuItem({
    required this.titulus,
    required this.subtitulus,
    required this.link,
    required this.icon
  });
}

final appMenuItems = <MenuItem>[
  MenuItem(
    titulus: 'Contador',
    subtitulus: 'Introduccion a Riverpod',
    link: '/numerator-river',
    icon: Icons.add
  ),
  MenuItem(
    titulus: 'Bandas Musicales',
    subtitulus: 'Graficos Pie Char y votaciones',
    link: '/bands',
    icon: Icons.music_note_outlined
  ),

  MenuItem (
    titulus: 'Mapa',
    subtitulus: 'Localizacion de usuarios',
    link: '/charta',
    icon: Icons.map_outlined
  ),

  MenuItem (
    titulus: 'PokeApi',
    subtitulus: 'Peticiones http a una Api',
    link: '/request',
    icon: Icons.catching_pokemon
  )


];