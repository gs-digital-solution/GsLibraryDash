class Stat {
  double? montant;
  double? commande;
  double? retrait;

  Stat({this.montant, this.commande, this.retrait});

  Stat.fromJson(Map<String, dynamic> json) {
    montant = json['montant'];
    commande = json['commande'];
    retrait = json['retrait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['montant'] = this.montant;
    data['commande'] = this.commande;
    data['retrait'] = this.retrait;
    return data;
  }
}
