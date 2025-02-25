import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

import '../models/payment_method.dart';

class PaymentMethodService extends GetxService {
  /// get All country
  Future<List<PaymentMethod>> getCountries({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'paymentMethods/',
      );

      print(response.data);

      if (response.statusCode == 200) {
        List<PaymentMethod> list = (response.data['paymentMethods'] as List)
            .map((e) => PaymentMethod.fromMap(e))
            .toList();
        return list;
      } else {
        throw AppException(message: response.data['msg']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['message']);
    }
  }

  Future<PaymentMethod> createCountry({PaymentMethod? country}) async {

    print(country!.toMap());
    try {
      final response = await BaseService.dio
          .post('paymentMethods/', data: json.encode(country.toMap()));

      if (response.statusCode == 201) {
        return PaymentMethod.fromMapCreated(response.data['paymentMethod']);
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.error);
      throw AppException(message: e.response!.data['message']);
    }
  }

  ///Update Country
  Future<PaymentMethod> updateCountry({PaymentMethod? country}) async {
    try {
      print(country!.toMap());
      final response = await BaseService.dio
          .put('paymentMethods/${country.id}', data: json.encode(country.toMap()));
      



      if (response.statusCode == 200) {
        return PaymentMethod.fromMapCreated(response.data['paymentMethod']);
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.type);
      throw AppException(message: e.response!.data['message']);
    }
  }

  /// Delete Country
  Future<bool> deleteCategory({
    PaymentMethod? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "paymentMethods/${model!.id}",
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['message']);
      } else {
        throw AppException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }
}
