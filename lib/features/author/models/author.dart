class TopAuthors {
  Avatar? avatar;
  String? sId;
  String? lastname;
  String? firstname;
  String? email;
  String? phonenumber;
  String? role;
  bool? isActivated;
  bool? status;
  String? description;
  String? designation;
  int? solde;
  String? createdAt;
  String? updatedAt;
  int? iV;

  TopAuthors(
      {this.avatar,
      this.sId,
      this.lastname,
      this.firstname,
      this.email,
      this.phonenumber,
      this.role,
      this.isActivated,
      this.status,
      this.description,
      this.designation,
      this.solde,
      this.createdAt,
      this.updatedAt,
      this.iV});

  TopAuthors.fromJson(Map<String, dynamic> json) {
    avatar =
        json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    sId = json['_id'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    role = json['role'];
    isActivated = json['isActivated'];
    status = json['status'];
    description = json['description'];
    designation = json['designation'];
    solde = json['solde'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.avatar != null) {
      data['avatar'] = this.avatar!.toJson();
    }
    data['_id'] = this.sId;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['role'] = this.role;
    data['isActivated'] = this.isActivated;
    data['status'] = this.status;
    data['description'] = this.description;
    data['designation'] = this.designation;
    data['solde'] = this.solde;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Avatar {
  String? url;
  String? name;

  Avatar({this.url, this.name});

  Avatar.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}
