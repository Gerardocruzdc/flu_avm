
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Usor {

  final String id;
  final String nomen;
  final String colorHex;
  final Position positio;
  
  const Usor({

    required this.id,
    required this.nomen,
    required this.colorHex,
    required this.positio

  });

  static Usor fromJson(Map<String, dynamic> json){  
    
    final lng = (json['lng'] as double?) ?? 0.0;
    final lat = (json['lat'] as double?) ?? 0.0;
    final nomen = json['nomen'] as String? ?? '';

    return Usor(
    id: json['id'] as String? ?? '',
    nomen: nomen,
    colorHex: json['color'] as String? ?? '#FF0000',
    positio: Position(lng, lat)
  );

  }

    Usor copyWith({
    String? id,
    String? nomen,
    String? colorHex,
    Position? positio
  }) {
    return Usor(
      id: id ?? this.id,
      nomen: nomen ?? this.nomen,
      colorHex: colorHex ?? this.colorHex,
      positio: positio ?? this.positio
    );}

}