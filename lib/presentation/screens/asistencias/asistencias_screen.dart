import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../config/entities/turno.dart';
import '../../providers/providers.dart';

class AsistenciasScreen extends ConsumerStatefulWidget {
  const AsistenciasScreen({super.key});

  @override
  ConsumerState<AsistenciasScreen> createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends ConsumerState<AsistenciasScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _loadingGps = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _elapsed = Duration.zero);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _onBotonPressed() async {
    final notifier = ref.read(turnosProvider.notifier);
    final isWorking = ref.read(turnosProvider).isWorking;

    if (!isWorking) {
      setState(() => _loadingGps = true);
      String ubicacion;
      try {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) throw Exception('GPS desactivado');
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.deniedForever) {
          throw Exception('Permiso denegado permanentemente');
        }
        final pos = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high),
        );
        ubicacion =
            '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      } catch (_) {
        ubicacion = 'Ubicación no disponible';
      } finally {
        if (mounted) setState(() => _loadingGps = false);
      }
      notifier.iniciarTurno(ubicacion);
      _startTimer();
    } else {
      _stopTimer();
      await notifier.terminarTurno(_elapsed);
      setState(() => _elapsed = Duration.zero);
    }
  }

  void _showDiaSheet(BuildContext context, int weekday, List<Turno> turnos) {
    final turnosDia = turnos.where((t) => t.diaSemana == weekday).toList();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) =>
          _DiaTurnosSheet(weekday: weekday, turnos: turnosDia),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(turnosProvider);
    final colorum = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Asistencias')),
      body: Column(
        children: [
          _ResumenSemanalWidget(
            horasSemanales: state.horasSemanales +
                (state.isWorking ? _elapsed : Duration.zero),
          ),
          _SemanaWidget(
            diasConTurno: state.diasConTurno,
            onTap: (wd) => _showDiaSheet(context, wd, state.turnos),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.isWorking == false && state.turnos.isEmpty
                ? Center(
                    child: Text(
                      'Sin turnos registrados',
                      style: TextStyle(color: colorum.onSurfaceVariant),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (state.isWorking)
                        _TurnoActivoCard(
                          startTime: state.startTime!,
                          ubicacion: state.ubicacion,
                          elapsed: _elapsed,
                        ),
                      ...state.turnos
                          .map((t) => _TurnoCompletadoCard(turno: t)),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _loadingGps ? null : _onBotonPressed,
                icon: _loadingGps
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(state.isWorking
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_outlined),
                label: Text(
                  _loadingGps
                      ? 'Obteniendo ubicación...'
                      : state.isWorking
                          ? 'Terminar turno'
                          : 'Empezar turno',
                ),
                style: state.isWorking
                    ? FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade700)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Resumen semanal ──────────────────────────────────────────────────────────

class _ResumenSemanalWidget extends ConsumerWidget {
  final Duration horasSemanales;

  const _ResumenSemanalWidget({required this.horasSemanales});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(turnosProvider);
    final notifier = ref.read(turnosProvider.notifier);
    final colorum = Theme.of(context).colorScheme;
    final h = horasSemanales.inHours;
    final m = (horasSemanales.inMinutes % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Horas esta semana',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorum.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${h}h ${m}m',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colorum.onSurface,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.grid_view_rounded),
            style: IconButton.styleFrom(
              backgroundColor: colorum.secondaryContainer,
              foregroundColor: colorum.onSecondaryContainer,
            ),
            onSelected: (value) async {
              switch (value) {
                case 'deshacer':
                  await notifier.deshacerUltimoTurno();
                case 'rehacer':
                  await notifier.rehacerTurno();
                case 'reset':
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Resetear semana'),
                      content: const Text(
                          '¿Eliminar todos los turnos de esta semana?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Resetear'),
                        ),
                      ],
                    ),
                  );
                  if (confirmar == true) await notifier.resetSemana();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'deshacer',
                enabled: state.puedeDeshacer,
                child: const ListTile(
                  leading: Icon(Icons.undo_rounded),
                  title: Text('Deshacer último turno'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'rehacer',
                enabled: state.puedeRehacer,
                child: const ListTile(
                  leading: Icon(Icons.redo_rounded),
                  title: Text('Rehacer'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'reset',
                child: ListTile(
                  leading: Icon(Icons.delete_sweep_outlined,
                      color: Colors.red.shade700),
                  title: Text('Reset de semana',
                      style: TextStyle(color: Colors.red.shade700)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Semana ──────────────────────────────────────────────────────────────────

const _diasSemana = [
  (1, 'L'),
  (2, 'M'),
  (3, 'X'),
  (4, 'J'),
  (5, 'V'),
  (6, 'S'),
  (7, 'D'),
];

const _nombresDia = [
  'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
];

class _SemanaWidget extends StatelessWidget {
  final Set<int> diasConTurno;
  final void Function(int weekday)? onTap;

  const _SemanaWidget({required this.diasConTurno, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;
    final hoy = DateTime.now().weekday;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _diasSemana.map((dia) {
          final weekday = dia.$1;
          final letra = dia.$2;
          final completado = diasConTurno.contains(weekday);
          final esHoy = weekday == hoy;

          return InkWell(
            onTap: () => onTap?.call(weekday),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Text(
                    letra,
                    style: TextStyle(
                      fontWeight: esHoy ? FontWeight.bold : FontWeight.normal,
                      color: esHoy ? colorum.primary : colorum.onSurface,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: completado ? colorum.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: esHoy ? colorum.primary : colorum.outlineVariant,
                        width: esHoy ? 2 : 1,
                      ),
                    ),
                    child: completado
                        ? Icon(Icons.check, size: 16, color: colorum.onPrimary)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Bottom sheet día ─────────────────────────────────────────────────────────

class _DiaTurnosSheet extends StatelessWidget {
  final int weekday;
  final List<Turno> turnos;

  const _DiaTurnosSheet({required this.weekday, required this.turnos});

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;
    final total = turnos.fold(Duration.zero, (acc, t) => acc + t.duracion);
    final h = total.inHours;
    final m = (total.inMinutes % 60).toString().padLeft(2, '0');

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nombresDia[weekday - 1],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  turnos.isEmpty
                      ? 'Sin turnos registrados'
                      : 'Total: ${h}h ${m}m',
                  style: TextStyle(
                      color: colorum.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: turnos.isEmpty
                ? Center(
                    child: Text(
                      'No trabajaste este día',
                      style: TextStyle(color: colorum.onSurfaceVariant),
                    ),
                  )
                : ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    children:
                        turnos.map((t) => _TurnoCompletadoCard(turno: t)).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta turno activo ─────────────────────────────────────────────────────

class _TurnoActivoCard extends StatelessWidget {
  final DateTime startTime;
  final String ubicacion;
  final Duration elapsed;

  const _TurnoActivoCard({
    required this.startTime,
    required this.ubicacion,
    required this.elapsed,
  });

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;

    return Card(
      color: colorum.primaryContainer,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colors.green.shade400),
                const SizedBox(width: 6),
                Text(
                  'TURNO EN CURSO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorum.onPrimaryContainer,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _formatDuration(elapsed),
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: colorum.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 10),
            _InfoRow(
                Icons.calendar_today_outlined,
                _formatFecha(startTime),
                colorum.onPrimaryContainer),
            const SizedBox(height: 4),
            _InfoRow(
                Icons.access_time_outlined,
                'Inicio: ${_formatHora(startTime)}',
                colorum.onPrimaryContainer),
            const SizedBox(height: 4),
            _InfoRow(
                Icons.location_on_outlined, ubicacion, colorum.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}

// ─── Tarjeta turno completado ─────────────────────────────────────────────────

class _TurnoCompletadoCard extends StatelessWidget {
  final Turno turno;

  const _TurnoCompletadoCard({required this.turno});

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatFecha(turno.inicio),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorum.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDuration(turno.duracion),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: colorum.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(Icons.login, 'Entrada: ${_formatHora(turno.inicio)}',
                colorum.onSurface),
            const SizedBox(height: 3),
            _InfoRow(Icons.logout, 'Salida:  ${_formatHora(turno.fin)}',
                colorum.onSurface),
            const SizedBox(height: 3),
            _InfoRow(Icons.location_on_outlined, turno.ubicacion,
                colorum.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ─── Helper row ──────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow(this.icon, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color.withAlpha(178)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color.withAlpha(217)),
          ),
        ),
      ],
    );
  }
}

// ─── Helpers de formato ───────────────────────────────────────────────────────

String _formatDuration(Duration d) {
  final h = d.inHours.toString().padLeft(2, '0');
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

String _formatFecha(DateTime dt) {
  const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const meses = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return '${dias[dt.weekday - 1]} ${dt.day} ${meses[dt.month - 1]} ${dt.year}';
}

String _formatHora(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
