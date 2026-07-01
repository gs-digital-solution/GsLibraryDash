// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';

class PaymentMethod {
  String? id;
  RxString? name;
  RxString? ussdCode;
  String? serviceCode;
  String? cashIn;
  String? provider;
  Country? country;
  RxBool? isActivated;
  RxInt? priority;
  String? createdAt;
  String? updatedAt;

  PaymentMethod({
    this.id,
    this.name,
    this.ussdCode,
    this.serviceCode,
    this.cashIn,
    this.provider,
    this.country,
    this.isActivated,
    this.priority,
    this.createdAt,
    this.updatedAt,
  });

  PaymentMethod copyWith({
    String? id,
    RxString? name,
    RxString? ussdCode,
    String? serviceCode,
    String? cashIn,
    String? provider,
    Country? country,
    RxBool? isActivated,
    RxInt? priority,
    String? createdAt,
    String? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      ussdCode: ussdCode ?? this.ussdCode,
      serviceCode: serviceCode ?? this.serviceCode,
      cashIn: cashIn ?? this.cashIn,
      provider: provider ?? this.provider,
      country: country ?? this.country,
      isActivated: isActivated ?? this.isActivated,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name?.value,
      'country': country!.id,
      'ussdCode': ussdCode?.value.toString(),
      'serviceCode': serviceCode,
      'cashIn': cashIn,
      'provider': provider ?? 'touchpay',
      'IsActivated': isActivated?.value,
      'priority': priority?.value,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? RxString(map['name']) : null,
      ussdCode: map['ussdCode'] != null ? RxString(map['ussdCode']) : null,
      serviceCode: map['serviceCode'] != null ? map['serviceCode'] : null,
      cashIn: map['cashIn'] != null ? map['cashIn'] : null,
      provider: map['provider'] != null
          ? map['provider'] as String
          : 'touchpay',
      country: map['country'] != null ? Country.fromMap(map['country']) : null,
      isActivated: map['IsActivated'] != null
          ? RxBool(map['IsActivated'])
          : null,
      priority: map['priority'] != null ? RxInt(map['priority']) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  factory PaymentMethod.fromMapCreated(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? RxString(map['name']) : null,
      ussdCode: map['ussdCode'] != null ? RxString(map['ussdCode']) : null,
      provider: map['provider'] != null
          ? map['provider'] as String
          : 'touchpay',
      isActivated: map['IsActivated'] != null
          ? RxBool(map['IsActivated'])
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentMethod(id: $id, name: $name, provider: $provider, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PaymentMethod other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
