class AdminUser {
  User? user;
  String? token;

  AdminUser({this.user, this.token});

  AdminUser.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phonenumber;
  String? role;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.phonenumber,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['role'] = this.role;
    return data;
  }
}
