import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class CountryService extends GetxService {
  /// get All country
  Future<List<Country>> getCountries({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'countries/',
      );

      print(response.data);

      if (response.statusCode == 200) {
        List<Country> list = (response.data['countries'] as List)
            .map((e) => Country.fromMap(e))
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

  Future<Country> createCountry({Country? country}) async {
    try {
      final response = await BaseService.dio
          .post('countries/', data: json.encode(country?.toMap()));

      if (response.statusCode == 201) {
        return Country.fromMap(response.data['country']);
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['message']);
    }
  }

  ///Update Country
  Future<Country> updateCountry({Country? country}) async {
    try {
      final response = await BaseService.dio
          .put('countries/${country!.id}', data: json.encode(country.toMap()));

      if (response.statusCode == 200) {
        return Country.fromMap(response.data['country']);
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['message']);
    }
  }

  /// Delete Country
  Future<bool> deleteCategory({
    Country? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "countries/${model!.id}",
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
