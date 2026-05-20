import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChartaService {

  IO.Socket? _socket;

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

      });

      _socket!.on('CLIENT_LEFT', (payload) {

      });

      _socket!.on('CLIENT_MOVED', (payload) {

      });

      _socket!.on('GET_CLIENTS', (payload) {

      });

    });

    _socket!.connect();

  }

  void finire(){
    _socket!.disconnect();
    _socket?.dispose();
    _socket = null;

  }

}