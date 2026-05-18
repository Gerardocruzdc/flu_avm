import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ChartaScreen extends StatefulWidget {
  const ChartaScreen({super.key});

  @override
  State<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends State<ChartaScreen> {

  void _initializeCircleAnnotations(MapboxMap mapboxMap) {
    // Aquí puedes agregar cualquier configuración adicional para el mapa si es necesario
  }

  @override
  Widget build(BuildContext context) {
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