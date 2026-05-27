import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';

class BienvenidaScreen extends ConsumerWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool esTenebris = ref.watch(estTenebrisModusProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Cabecera(
                esTenebris: esTenebris,
                onToggle: () => ref
                    .read(estTenebrisModusProvider.notifier)
                    .update((state) => !esTenebris),
              ),
              const Spacer(),
              _SeccionImagenesWS(esTenebris: esTenebris),
              const Spacer(),
              const _SeccionTexto(),
              const Spacer(),
              const _SeccionCards(),
              const Spacer(),
              const _SeccionStats(),
              const Spacer(),
              const _BotonComenzar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  final bool esTenebris;
  final VoidCallback onToggle;

  const _Cabecera({required this.esTenebris, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ColorFiltered(
            colorFilter: esTenebris
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            child: Image.asset(
              'assets/icon/icon.png',
              height: 36,
              width: 36,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Flu Avm',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: onToggle,
          icon: Icon(
            esTenebris ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          ),
        ),
      ],
    );
  }
}

class _SeccionImagenesWS extends StatelessWidget {
  final bool esTenebris;

  const _SeccionImagenesWS({required this.esTenebris});

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;

    final wsBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: colorum.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'WS',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorum.primary,
          fontSize: 13,
        ),
      ),
    );

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 58),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  esTenebris ? 'assets/images/mobil_nocturno.png' : 'assets/images/movil.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                flex: 5,
                child: Image.asset(
                  esTenebris ? 'assets/images/puntos_nocturno.png' : 'assets/images/puntos.png',
                  height: 25,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                flex: 3,
                child: Image.asset(
                  esTenebris ? 'assets/images/servidor_nocturno.png' : 'assets/images/servidor.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        wsBadge,
      ],
    );
  }
}

class _SeccionTexto extends StatelessWidget {
  const _SeccionTexto();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(38),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 8, color: Colors.green),
              SizedBox(width: 6),
              Text(
                'CONECTADO',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'WebSockets en vivo',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Aprende a construir apps con datos en tiempo real en Flutter. Dos ejemplos prácticos te esperan dentro.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SeccionCards extends StatelessWidget {
  const _SeccionCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TarjetaItem(
            imagen: 'assets/images/mapa.jpg',
            titulo: 'Mapas',
            subtitulo: 'Ubicación en tiempo real',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TarjetaItem(
            imagen: 'assets/images/votaciones.jpg',
            titulo: 'Votaciones',
            subtitulo: 'Gráfico que se actualiza',
          ),
        ),
      ],
    );
  }
}

class _TarjetaItem extends StatelessWidget {
  final String imagen;
  final String titulo;
  final String subtitulo;

  const _TarjetaItem({
    required this.imagen,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagen,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitulo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionStats extends StatelessWidget {
  const _SeccionStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatChip(numero: '0', etiqueta: 'PANTALLAS')),
        const SizedBox(width: 8),
        Expanded(child: _StatChip(numero: '0', etiqueta: 'WEBSOCKETS')),
        const SizedBox(width: 8),
        Expanded(child: _StatChip(numero: 'GC', etiqueta: 'GERARDO CRUZ')),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String numero;
  final String etiqueta;

  const _StatChip({required this.numero, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colorum.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            numero,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: colorum.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            style: const TextStyle(fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BotonComenzar extends StatelessWidget {
  const _BotonComenzar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => context.go('/home'),
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Comenzar'),
      ),
    );
  }
}