
class Pokemon {
  final int id;
  final String nomen;
  final int altitudo;
  final int pondus;
  final List<String> facultates;
  final String? faciemImaginem;

  Pokemon({
    required this.id,
    required this.nomen,
    required this.altitudo,
    required this.pondus,
    required this.facultates,
    this.faciemImaginem,

  });
}