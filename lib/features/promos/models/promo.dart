import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';

class Promo {
  String? sId;
  String? code;
  int? discount;
  int? gain;
  int? usageLimit;
  int? timesUsed;
  RxBool? active;
  String? userId;
  Author?user;
  int? iV;

  Promo(
      {this.sId,
      this.code,
      this.discount,
      this.gain,
      this.usageLimit,
      this.timesUsed,
      this.active,
      this.userId,
      this.user,
      this.iV});

  Promo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    discount = json['discount'];
    gain = json['gain'];
    usageLimit = json['usageLimit'];
    timesUsed = json['timesUsed'];
    active = RxBool(json['active']);
    userId = json['userId'];
    iV = json['__v'];
  }

    Promo.fromJsonUser(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    discount = json['discount'];
    gain = json['gain'];
    usageLimit = json['usageLimit'];
    timesUsed = json['timesUsed'];
     active = RxBool(json['active']);
    user = Author.fromJson(json['userId']);
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['gain'] = this.gain;
    data['usageLimit'] = this.usageLimit;
    data['timesUsed'] = this.timesUsed;
    data['active'] = this.active;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    return data;
  }
}
