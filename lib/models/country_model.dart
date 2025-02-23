
class CountryModel {
  String? name;
  String? countryCode;
  String? countryFalg;

  CountryModel({this.name, this.countryCode, this.countryFalg});

  CountryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    countryCode = json['countryCode'];
    countryFalg = json['countryFalg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['countryFalg'] = this.countryFalg;
    return data;
  }

  @override
  String toString() => 'CountryModel(name: $name, countryCode: $countryCode, countryFalg: $countryFalg)';
}
