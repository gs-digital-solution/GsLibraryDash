import 'package:get/get.dart';

class Partner {
  String? sId;
  String? name;
  String? email;
  String? description;
  String? apiKey;
  String? status;
  String? startDate;
  String? endDate;
  int? maxUsers;
  int? currentUsers;
  List<String>? allowedCategories;
  List<String>? allowedBooks;
  double? commission;
  double? balance;
  ContactPerson? contactPerson;
  String? webhookUrl;
  PartnerSettings? settings;
  Map<String, dynamic>? createdBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Partner({
    this.sId,
    this.name,
    this.email,
    this.description,
    this.apiKey,
    this.status,
    this.startDate,
    this.endDate,
    this.maxUsers,
    this.currentUsers,
    this.allowedCategories,
    this.allowedBooks,
    this.commission,
    this.balance,
    this.contactPerson,
    this.webhookUrl,
    this.settings,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Partner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    description = json['description'];
    apiKey = json['apiKey'];
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    maxUsers = json['maxUsers'];
    currentUsers = json['currentUsers'];
    if (json['allowedCategories'] != null) {
      allowedCategories = <String>[];
      json['allowedCategories'].forEach((v) {
        allowedCategories!.add(v.toString());
      });
    }
    if (json['allowedBooks'] != null) {
      allowedBooks = <String>[];
      json['allowedBooks'].forEach((v) {
        allowedBooks!.add(v.toString());
      });
    }
    commission = json['commission']?.toDouble();
    balance = json['balance']?.toDouble();
    contactPerson = json['contactPerson'] != null
        ? ContactPerson.fromJson(json['contactPerson'])
        : null;
    webhookUrl = json['webhookUrl'];
    settings = json['settings'] != null
        ? PartnerSettings.fromJson(json['settings'])
        : null;
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['description'] = description;
    data['apiKey'] = apiKey;
    data['status'] = status;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['maxUsers'] = maxUsers;
    data['currentUsers'] = currentUsers;
    if (allowedCategories != null) {
      data['allowedCategories'] = allowedCategories;
    }
    if (allowedBooks != null) {
      data['allowedBooks'] = allowedBooks;
    }
    data['commission'] = commission;
    data['balance'] = balance;
    if (contactPerson != null) {
      data['contactPerson'] = contactPerson!.toJson();
    }
    data['webhookUrl'] = webhookUrl;
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ContactPerson {
  String? name;
  String? phone;

  ContactPerson({this.name, this.phone});

  ContactPerson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}

class PartnerSettings {
  RxBool? canPurchase;
  RxBool? canViewCategories;
  RxBool? canViewBooks;
  RxBool? canViewPurchases;

  PartnerSettings({
    this.canPurchase,
    this.canViewCategories,
    this.canViewBooks,
    this.canViewPurchases,
  });

  PartnerSettings.fromJson(Map<String, dynamic> json) {
    canPurchase = RxBool(json['canPurchase']);
    canViewCategories = RxBool(json['canViewCategories']);
    canViewBooks = RxBool(json['canViewBooks']);
    canViewPurchases = RxBool(json['canViewPurchases']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['canPurchase'] = canPurchase!.value;
    data['canViewCategories'] = canViewCategories!.value;
    data['canViewBooks'] = canViewBooks!.value;
    data['canViewPurchases'] = canViewPurchases!.value;
    return data;
  }
}

// Énumération pour le statut du partenaire
enum PartnerStatus {
  active,
  inactive,
  suspended,
}

extension PartnerStatusExtension on PartnerStatus {
  String get value {
    switch (this) {
      case PartnerStatus.active:
        return 'active';
      case PartnerStatus.inactive:
        return 'inactive';
      case PartnerStatus.suspended:
        return 'suspended';
    }
  }

  static PartnerStatus fromString(String value) {
    switch (value) {
      case 'active':
        return PartnerStatus.active;
      case 'inactive':
        return PartnerStatus.inactive;
      case 'suspended':
        return PartnerStatus.suspended;
      default:
        return PartnerStatus.active;
    }
  }
}
