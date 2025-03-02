// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get.dart';

class Country {
  String? id;
  String? currency;
  RxString? name;
  RxString? countryCode;
  RxString? countryFlag;
  RxBool? isActivated;
  RxString? serviceCode;
  String? createdAt;
  String? updatedAt;

  Country({
    this.id,
    this.name,
    this.currency,
    this.countryCode,
    this.countryFlag,
    this.isActivated,
    this.serviceCode,
    this.createdAt,
    this.updatedAt,
  });

  Country copyWith({
    String? id,
    RxString? name,
    RxString? countryCode,
    RxString? countryFlag,
    RxBool? isActivated,
    RxString? serviceCode,
    String? createdAt,
    String? updatedAt,
  }) {
    return Country(
      id: id ?? this.id,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      countryFlag: countryFlag ?? this.countryFlag,
      isActivated: isActivated ?? this.isActivated,
      serviceCode: serviceCode ?? this.serviceCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name?.value,
      'currency': currency,
      'countryCode': countryCode?.value,
      'countryFlag': countryFlag?.value,
      'IsActivated': isActivated?.value,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? RxString(map['name']) : null,
      currency: map['currency'] ?? "",
      countryCode:
          map['countryCode'] != null ? RxString(map['countryCode']) : null,
      countryFlag:
          map['countryFlag'] != null ? RxString(map['countryFlag']) : null,
      isActivated:
          map['IsActivated'] != null ? RxBool(map['IsActivated']) : null,
      serviceCode:
          map['serviceCode'] != null ? RxString(map['serviceCode']) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Country(id: $id, name: $name, countryCode: $countryCode, countryFlag: $countryFlag, isActivated: $isActivated, serviceCode: $serviceCode, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Country other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.countryCode == countryCode &&
        other.countryFlag == countryFlag &&
        other.isActivated == isActivated &&
        other.serviceCode == serviceCode &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        countryCode.hashCode ^
        countryFlag.hashCode ^
        isActivated.hashCode ^
        serviceCode.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
