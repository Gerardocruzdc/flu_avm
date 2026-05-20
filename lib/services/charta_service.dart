import 'package:flu_avm/config/config.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

// Contrato Socket.IO con el backend:
// - Cliente emite 'CLIENT_REGISTER': { nomen, color (hex), lng, lat }
// - Cliente emite 'CLIENT_MOVE': { lng, lat }
// - Servidor emite 'CLIENT_JOINED': { id, nomen, color, lng, lat }
// - Servidor emite 'CLIENT_LEFT': { id }
// - Servidor emite 'CLIENT_MOVED': { id, lng, lat }
// - Servidor emite 'GET_CLIENTS': [ { id, nomen, color, lng, lat }, ... ]

class ChartaService {

  IO.Socket? _socket;

  final Map<String, Usor> _usores = {};

  late final StreamController<List<Usor>> _usoresController;

  ChartaService() {
    _usoresController = StreamController<List<Usor>>.broadcast();
    conectare();
  }

  void conectare(){

    _socket = IO.io(
      'http://192.168.1.27:3200',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()

    );

    _socket!.onConnect((_) {
      _socket!.on('CLIENT_JOINED', (payload) {
          final usor = Usor.fromJson(Map<String, dynamic>.from(payload));
          _usores[usor.id] = usor;
          _usoresListemRenovare();

      });

      _socket!.on('CLIENT_LEFT', (payload) {
        final id = payload['id'] as String;
        _usores.remove(id);
        _usoresListemRenovare();
      });

      _socket!.on('CLIENT_MOVED', (payload) {
        final map = Map<String, dynamic>.from(payload);
        final id = map['id'] as String;
        final lng = (map['lng'] as double);
        final lat = (map['lat'] as double);

        _usores[id] = _usores[id]!.copyWith(
          positio: Position(lng, lat)
        );
        _usoresListemRenovare();
      });

      _socket!.on('GET_CLIENTS', (payload) {

        _usores.clear();
        for (var item in payload) {
          final usor = Usor.fromJson(item);
          _usores[usor.id] = usor;
        }
        _usoresListemRenovare();

      });

    });

    _socket!.connect();

  }

  void _usoresListemRenovare() {
    _usoresController.add(List.from(_usores.values));
  }

  void finire(){
    _socket!.disconnect();
    _socket?.dispose();
    _socket = null;

    _usores.clear();
    _usoresController.add([]);
    _usoresController.close();
    

  }

}