import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';

class Book {
  Gratuite? gratuite;
  Gratuite? payante;
  String? sId;
  String? nom;
  String? description;
  int? prix;
  int? pourcentage;
  TopAuthors? author;
  List<CategoryModel>? categories;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Avatar?avatar;

  Book(
      {this.gratuite,
      this.payante,
      this.sId,
      this.nom,
      this.description,
      this.prix,
      this.pourcentage,
      this.author,
      this.categories,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.avatar,
      this.iV});

  Book.fromJson(Map<String, dynamic> json) {
    gratuite = json['gratuite'] != null
        ? new Gratuite.fromJson(json['gratuite'])
        : null;
    payante =
        json['payante'] != null ? new Gratuite.fromJson(json['payante']) : null;
    sId = json['_id'];
    nom = json['nom'];
    description = json['description'];
        avatar =
        json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    prix = json['prix'];
    pourcentage = json['pourcentage'];
    author =
        json['author'] != null ? new TopAuthors.fromJson(json['author']) : null;
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(new CategoryModel.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

    Book.fromJsonCommande(Map<String, dynamic> json) {
    gratuite = json['gratuite'] != null
        ? new Gratuite.fromJson(json['gratuite'])
        : null;
    payante =
        json['payante'] != null ? new Gratuite.fromJson(json['payante']) : null;
    sId = json['_id'];
    nom = json['nom'];
    description = json['description'];
        avatar =
        json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    prix = json['prix'];
    pourcentage = json['pourcentage'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gratuite != null) {
      data['gratuite'] = this.gratuite!.toJson();
    }
    if (this.payante != null) {
      data['payante'] = this.payante!.toJson();
    }
    data['_id'] = this.sId;
    data['nom'] = this.nom;
    data['description'] = this.description;
    data['prix'] = this.prix;
    data['pourcentage'] = this.pourcentage;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Gratuite {
  String? url;
  String? name;

  Gratuite({this.url, this.name});

  Gratuite.fromJson(Map<String, dynamic> json) {
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


