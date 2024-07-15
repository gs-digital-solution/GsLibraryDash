import 'package:gslibrarydashboard/features/investors/models/investor.dart';

class InvestorWithSolde {
  Investor? investor;
  double? solde;

  InvestorWithSolde({this.investor, this.solde});
  InvestorWithSolde.fromJson(Map<String, dynamic> json) {
    investor = Investor.fromJson(json['investisseur']);
    solde = json['solde'] != null ? json['solde'] : 0;
  }
}
