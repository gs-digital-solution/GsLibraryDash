class CategoryModel {
  Avatar? avatar;
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CategoryModel(
      {this.avatar,
      this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    avatar =
        json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.avatar != null) {
      data['avatar'] = this.avatar!.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
