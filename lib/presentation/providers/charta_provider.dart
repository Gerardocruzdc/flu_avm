import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';


final formNomenProvider = StateProvider<String>((ref) => ''); // Estado para el nombre del formulario


final formColorProvider = StateProvider<Color>((ref) => Colors.blue);

final markerPositumProvider = StateProvider<bool>((ref) => false); // Estado para controlar la posición del marcador  