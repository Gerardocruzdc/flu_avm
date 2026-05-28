import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/entities/turno.dart';

class TurnosState {
  final bool isWorking;
  final DateTime? startTime;
  final String ubicacion;
  final List<Turno> turnos;

  const TurnosState({
    this.isWorking = false,
    this.startTime,
    this.ubicacion = '',
    this.turnos = const [],
  });

  Set<int> get diasConTurno => turnos.map((t) => t.diaSemana).toSet();

  Duration get horasSemanales {
    final ahora = DateTime.now();
    final inicioSemana = DateTime(
        ahora.year, ahora.month, ahora.day - (ahora.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 7));
    return turnos
        .where((t) =>
            !t.inicio.isBefore(inicioSemana) && t.inicio.isBefore(finSemana))
        .fold(Duration.zero, (acc, t) => acc + t.duracion);
  }

  TurnosState copyWith({
    bool? isWorking,
    DateTime? startTime,
    String? ubicacion,
    List<Turno>? turnos,
  }) =>
      TurnosState(
        isWorking: isWorking ?? this.isWorking,
        startTime: startTime ?? this.startTime,
        ubicacion: ubicacion ?? this.ubicacion,
        turnos: turnos ?? this.turnos,
      );
}

class TurnosNotifier extends StateNotifier<TurnosState> {
  static const _prefsKey = 'turnos_v1';

  TurnosNotifier() : super(const TurnosState()) {
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    final List decoded = jsonDecode(raw);
    final turnos = decoded
        .map((e) => Turno.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    state = state.copyWith(turnos: turnos);
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.turnos.map((t) => t.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void iniciarTurno(String ubicacion) {
    state = state.copyWith(
      isWorking: true,
      startTime: DateTime.now(),
      ubicacion: ubicacion,
    );
  }

  Future<void> terminarTurno(Duration elapsed) async {
    if (state.startTime == null) return;
    final turno = Turno(
      inicio: state.startTime!,
      fin: DateTime.now(),
      duracion: elapsed,
      ubicacion: state.ubicacion,
      diaSemana: state.startTime!.weekday,
    );
    final nuevosTurnos = [turno, ...state.turnos];
    state = TurnosState(turnos: nuevosTurnos);
    await _guardar();
  }
}

// ignore: deprecated_member_use
final turnosProvider =
    StateNotifierProvider<TurnosNotifier, TurnosState>((ref) => TurnosNotifier());
