import 'package:flu_avm/config/config.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus {
  // ignore: constant_identifier_names
  Online,
  Offline,
  Connecting
}

final bandsProvider = StateNotifierProvider<BandsNotifier, BandsState>((ref) {
  return BandsNotifier();
});

class BandsState {
  final ServerStatus serverStatus;
  final IO.Socket socket;
  final List<Band> bands;

  BandsState({
    required this.serverStatus,
    required this.socket,
    required this.bands
  });

  BandsState copyWith({
    ServerStatus? serverStatus,
    IO.Socket? socket,
    List<Band>? bands
  }) => BandsState(
    serverStatus: serverStatus ?? this.serverStatus,
    socket: socket ?? this.socket,
    bands: bands ?? this.bands
  );
}

class BandsNotifier extends StateNotifier<BandsState> {
  BandsNotifier() 
  : super(BandsState(
    serverStatus: ServerStatus.Connecting,
    socket: IO.io(
      'http://192.168.1.27:3000',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()),
    bands: []
    
  )) {

    _initConfig();
  }

  void _initConfig() {
    state.socket.onConnect(( _ ) {
      state = state.copyWith(serverStatus: ServerStatus.Online);
    });

    state.socket.onDisconnect(( _ ) {
      state = state.copyWith(serverStatus: ServerStatus.Offline);
    });
  }

}


/*
class BandsNotifier extends StateNotifier<List<Band>>{
  BandsNotifier() : super([
    Band(id: '1', nomen: 'The Doors', numerusVotum: 5),
    Band(id: '2', nomen: 'Led Zeppelin', numerusVotum: 1),
    Band(id: '3', nomen: 'Pink Floyd', numerusVotum: 2),
    Band(id: '4', nomen: 'Queen', numerusVotum: 5)
    
    ]);

  void addereBand(Band band){
    state = [...state, band];
  }
  void delereBand(Band band){
    state = state.where((b) => b.id != band.id).toList();
  }
  void addereVotum(Band band){
    state = state.map((b) {
      return b.id == band.id ? b.copyWith(numerusVotum: b.numerusVotum + 1) : b;
    }).toList();
  }

}

*/