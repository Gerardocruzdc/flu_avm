import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class InformaUsoris extends StatelessWidget {

  final String nomen;
  final Position positio;
  final Color color;

  const InformaUsoris({
    super.key,
    required this.nomen,
    required this.positio,
    required this.color,
  });


  @override
  Widget build(BuildContext context) {
    //return Text(nomen, style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.bold),);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
        borderRadius: BorderRadius.circular(10),

        
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            nomen.isEmpty ? '__' : nomen,
            style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),
          Text('Lat: ${positio.lat.toStringAsFixed(5)}', style: TextStyle(color: Colors.black),),
          Text('Lng: ${positio.lng.toStringAsFixed(5)}', style: TextStyle(color: Colors.black),),

        ]
      ),
    );
  }
}