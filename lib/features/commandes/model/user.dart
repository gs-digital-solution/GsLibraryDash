class User {
  String? sId;
  String? lastname;
  String? firstname;
  String? phonenumber;
  String? deviceId;
  String? role;
  bool? isActivated;
  bool? status;
  int? solde;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User(
      {this.sId,
      this.lastname,
      this.firstname,
      this.phonenumber,
      this.deviceId,
      this.role,
      this.isActivated,
      this.status,
      this.solde,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    phonenumber = json['phonenumber'];
    deviceId = json['deviceId'];
    role = json['role'];
    isActivated = json['isActivated'];
    status = json['status'];
    solde = double.parse(json['solde'].toString()).toInt();
   createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['phonenumber'] = this.phonenumber;
    data['deviceId'] = this.deviceId;
    data['role'] = this.role;
    data['isActivated'] = this.isActivated;
    data['status'] = this.status;
    data['solde'] = this.solde;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
