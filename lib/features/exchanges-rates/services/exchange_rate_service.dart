import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/models/exchange_rate.dart';

import '../../../home/services/baseService.dart';

class ExchangeRateService extends getx.GetxService {
  Future<bool> createExchangeRate({ExchangeRate? exchangeRate}) async {
    try {
      final response = await BaseService.dio
          .post('exchanges-rates/', data: json.encode(exchangeRate?.toJson()));

      if (response.statusCode == 201) {
        return true;
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['message']);
    }
  }

  Future<bool> updateExchangeRate({ExchangeRate? exchangeRate}) async {
    try {
      final response = await BaseService.dio
          .put('exchanges-rates/', data: json.encode(exchangeRate?.toJson()));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['message']);
    }
  }

  Future<List<ExchangeRate>> getExchangeRates() async {
    try {
      final response = await BaseService.dio.get(
        'exchanges-rates/',
      );

      print(response.data);

      if (response.statusCode == 200) {
        List<ExchangeRate> list = (response.data as List)
            .map((e) => ExchangeRate.fromJson(e))
            .toList();
        return list;
      } else {
        throw AppException(message: response.data['message']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['message']);
    }
  }

  /// Delete Country
  Future<bool> deleteExchangeRate({
    ExchangeRate? exchangeRate,
  }) async {
    try {
      final response = await BaseService.dio.delete("exchanges-rates/",
          data: json.encode(exchangeRate?.toJson()));
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
