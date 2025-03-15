import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/dashboard/models/stat.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class StatService extends getX.GetxService {
  Future<Stat> getStat({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get('users/admin/stats');

      print(response.data);

      if (response.statusCode == 200) {
        return Stat.fromJson(response.data);
      } else {
        throw AppException(
          message: "Verifier votre connecion internet et ressayez",
        );
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(
          message: "Verifier votre connecion internet et ressayez");
    }
  }

  Future<bool> createRetraitAdmin({
    String? montant,
    String? serviceId,
    String? amountToPay,
    String? receiver,
    String? password,
  }) async {
    Map<String, dynamic> retraitData = {
      "montant": int.parse(montant!),
      "serviceId": serviceId,
      "amountToPay": amountToPay,
      "receiver": receiver,
      "password": password,
    };
    try {
      final response = await BaseService.dio
          .post('retraits/admin/withdraw', data: json.encode(retraitData));

      print(response.data);

      if (response.statusCode == 201) {
        return true;
      } else {
        throw AppException(
            message: "Verifier votre connecion internet et ressayez");
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(
        message: e.message,
      );
    }
  }
}
