import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/models/transfert.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class TransfertService extends GetxService {
  Future<List<TransfertDevice>> getTransfertBookRequest(
      {String? userId}) async {

    try {
      final response = await BaseService.dio.get("restores/");
      print(response.data);
      if (response.statusCode == 200) {
        List<TransfertDevice> list = (response.data['promos'] as List)
            .map((e) => TransfertDevice.fromJson(e))
            .toList();
        return list;
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    } on AppException catch (e) {
      print(e.message);
      throw AppException(
          message: "une erreur est survenue. Ressayez plus tard");
    }
  }

  Future<bool> askForBookkTransfert(
      {String? reason, String? userId, String? newDeviceId}) async {
    Map<String, dynamic> formData = {
      "newDeviceId": newDeviceId,
      "userId": userId,
      "motif": reason,
    };

    try {
      final response =
          await BaseService.dio.post("restores/", data: json.encode(formData));
      print(response.data);
      if (response.statusCode == 201) {
        return true;
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['message']);
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    }
  }

  Future<bool> validateTransfert({String? id, String? deviceId,String?userId}) async {
    Map<String, dynamic> formData = {
      "deviceId": deviceId,
      "userId":userId
    };

    try {
      final response = await BaseService.dio
          .post("restores/validate/$id", data: json.encode(formData));
      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    } on DioException catch (e) {
      print(e.error);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['message']??"Une erreur est survenue");
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    }
  }

  Future<bool> cancelTransfertBook({String? id}) async {
    Map<String, dynamic> formData = {
      "status": -1,
    };
    try {
      final response = await BaseService.dio
          .post("restores/$id", data: json.encode(formData));
      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['message']);
      } else {
        throw AppException(
            message: "une erreur est survenue. Ressayez plus tard");
      }
    }
  }
}
