

import 'package:gslibrarydashboard/features/commandes/model/user.dart';

class TransfertDevice {
  String? sId;
  String? newDeviceId;
  String? motif;
  int? restoreLimit;
  int? status;
  User? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  TransfertDevice(
      {this.sId,
      this.newDeviceId,
      this.motif,
      this.restoreLimit,
      this.status,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV});

  TransfertDevice.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    newDeviceId = json['newDeviceId'];
    motif = json['motif'];
    restoreLimit = json['restoreLimit'];
    status = json['status'];
    user =
        json['userId'] != null ? User.fromJson(json['userId']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['newDeviceId'] = newDeviceId;
    data['motif'] = motif;
    data['restoreLimit'] = restoreLimit;
    data['status'] = status;
    if (user != null) {
      data['userId'] = user!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}


