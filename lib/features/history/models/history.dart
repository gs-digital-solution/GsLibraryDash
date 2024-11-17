class History {
  String? sId;
  String? deviceId;

  String? createdAt;
  String? updatedAt;
  int? iV;

  History(
      {this.sId,
      this.deviceId,

      this.createdAt,
      this.updatedAt,
      this.iV});

  History.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    deviceId = json['deviceId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['deviceId'] = this.deviceId;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}


