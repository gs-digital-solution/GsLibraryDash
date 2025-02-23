

class ExchangeRate{
  String?countryFrom;
  String?countryTo;
  double?rate;

  ExchangeRate({this.countryFrom,this.countryTo,this.rate});

  factory ExchangeRate.fromJson(Map<String,dynamic> json)=>ExchangeRate(
    countryFrom: json['currencyFrom'],
    countryTo: json['currencyTo'],
    rate: json['rate'],
  );

  Map<String,dynamic> toJson()=>{
    "currencyFrom":countryFrom,
    "currencyTo":countryTo,
    "rate":rate,
  };
}