class Band {
  String id;
  String nomen;
  int numerusVotum;

  Band({

    required this.id,
    required this.nomen,
    required this.numerusVotum
});

Band copyWith({
  String? id,
  String? nomen,
  int? numerusVotum
}) {
  return Band(
    id: id ?? this.id,
    nomen: nomen ?? this.nomen,
    numerusVotum: numerusVotum ?? this.numerusVotum,
    );
  }
}

