import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ChartaScreen extends ConsumerStatefulWidget {
  const ChartaScreen({super.key});

  @override
  ConsumerState<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends ConsumerState<ChartaScreen> {

  CircleAnnotationManager? _circleAnnotationManager;

  void _initializeCircleAnnotations(MapboxMap mapboxMap) {

    mapboxMap.annotations.createCircleAnnotationManager().then((manager) {
      _circleAnnotationManager = manager;
      _addeVelRenovareMarker();
    });
    // Aquí puedes agregar cualquier configuración adicional para el mapa si es necesario
  }

  Future<void> _addeVelRenovareMarker() async {
    final manager = _circleAnnotationManager;
    if (manager == null) return;

    final placed = ref.read(markerPositumProvider);
    if ( !placed ) {
      await manager.deleteAll(); // Eliminar marcadores existentes antes de agregar uno nuevo
      return;
    } // Evitar agregar el marcador si ya está colocado 

    final situs = Position(-122.467895, 37.800126);
    final color = ref.read(formColorProvider);
    
    final optiones = CircleAnnotationOptions(
      geometry: Point(coordinates: situs),
      circleColor: color.toARGB32(),
      circleRadius: 14.0,
      circleStrokeColor: Colors.white.toARGB32(),
      circleStrokeWidth: 2,
      isDraggable: true,
      ); 
      
      try {
        await manager.create(optiones);
      } catch (e) {
        debugPrint('Error al agregar el marcador: $e ');
      }// Coordenadas de ejemplo
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<bool>(markerPositumProvider, (prev, next) {
      if (next == true) {
        _addeVelRenovareMarker(); // Agregar el marcador cuando se actualice el estado a true
      } 
    });

    return Scaffold(
      appBar : AppBar(
        title: Text('Mapas'),
        ),

      body: Stack(

        fit:StackFit.expand,
        children: [
            MapWidget(

              key: const ValueKey('main_map'),
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: Position(-122.467895, 37.800126),
                ),
                zoom: 14.5,
              ),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: (controller) {
                _initializeCircleAnnotations(controller);
              },
            ),
          
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ComplereForm()
            )
          )
        ],
      )
       );
    }
  }