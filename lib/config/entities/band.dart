class Band {
  String id;
  String nomen;
  int numerusVotum;

  Band({

    required this.id,
    required this.nomen,
    required this.numerusVotum
});
}

List <Band> bands = [
  Band(id: '1', nomen: 'The Doors', numerusVotum: 5),
  Band(id: '2', nomen: 'Led Zeppelin', numerusVotum: 1),
  Band(id: '3', nomen: 'Pink Floyd', numerusVotum: 2),
  Band(id: '4', nomen: 'Queen', numerusVotum: 5),
];