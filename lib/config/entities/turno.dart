class Turno {
  final DateTime inicio;
  final DateTime fin;
  final Duration duracion;
  final String ubicacion;
  final int diaSemana;

  Turno({
    required this.inicio,
    required this.fin,
    required this.duracion,
    required this.ubicacion,
    required this.diaSemana,
  });

  factory Turno.fromJson(Map<String, dynamic> json) => Turno(
        inicio: DateTime.parse(json['inicio']),
        fin: DateTime.parse(json['fin']),
        duracion: Duration(seconds: json['duracionSegundos']),
        ubicacion: json['ubicacion'],
        diaSemana: json['diaSemana'],
      );

  Map<String, dynamic> toJson() => {
        'inicio': inicio.toIso8601String(),
        'fin': fin.toIso8601String(),
        'duracionSegundos': duracion.inSeconds,
        'ubicacion': ubicacion,
        'diaSemana': diaSemana,
      };
}
