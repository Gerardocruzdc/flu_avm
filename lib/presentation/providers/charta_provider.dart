import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


final formNomenProvider = StateProvider<String>((ref) => ''); // Estado para el nombre del formulario


final formColorProvider = StateProvider<Color>((ref) => Colors.blue);

final markerPositumProvider = StateProvider<bool>((ref) => false); // Estado para controlar la posición del marcador  

final Position initialisMarkerPositio = Position(-122.467895, 37.800126); // Coordenadas de ejemplo para el marcador 
final coordsMarkerProvider = StateProvider<Position>((ref) => initialisMarkerPositio); // Estado para la posición del marcador