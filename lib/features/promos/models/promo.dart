import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';

class Promo {
  String? sId;
  String? code;
  int? discount;
  int? gain;
  int? usageLimit;
  int? timesUsed;
  RxBool? active;
  String? userId;
  String? partnerId;
  Author?user;
  Partner? partner;
  String? type = 'user';
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
      this.partner,
      this.partnerId,
      this.type,
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
    partnerId = json['partnerId'];
    type = json['type'] ?? 'user'; // Par défaut 'user'
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
    //userId = json['userId'];
    partner = json['partnerId'] != null ? Partner.fromJson(json['partnerId']) : null;
    type = json['type'] ?? 'user'; // Par défaut 'user'
    user =json['userId']!=null ? Author.fromJson(json['userId']) : null;
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
    data['partnerId'] = this.partnerId;
    data['type'] = this.type;
    data['__v'] = this.iV;
    return data;
  }
}
