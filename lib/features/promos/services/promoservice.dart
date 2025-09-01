import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/promos/models/promo.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class PromoService extends getX.GetxService {
///mettre a jour un code promo
  Future<Promo> updatePromo({
    bool? active,
    String? code,
    int? discount,
    int? gain,
    String? userId,
    String? partnerId,
    String? type,
    Promo? promo,
  }) async {
    Map<String, dynamic> postData = {
      "code": code,
      "discount": discount,
      "gain": gain,
      "active": active,
    };
    
    // Ajouter userId ou partnerId selon le type
    if (type == 'partner') {
      postData['partnerId'] = partnerId;
      postData['type'] = 'partner';
    } else {
      postData['userId'] = userId;
      postData['type'] = 'user';
    }
  print(postData);
    try {
      final response = await BaseService.dio.post(
        "promos/${promo!.sId}",
        data: json.encode(postData),
        options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        return Promo.fromJson(response.data['promo']);
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.message);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw AppException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }

///Ajouter un code promo
    Future<Promo> addPromo({
    bool? active,
    String? code,
    int? discount,
    int? gain,
    String? userId,
    String? partnerId,
    String? type,
  }) async {
    Map<String, dynamic> postData = {
      "code": code,
      "discount": discount,
      "gain": gain,
    };
    
    // Ajouter userId ou partnerId selon le type
    if (type == 'partner') {
      postData['partnerId'] = partnerId;
      postData['type'] = 'partner';
    } else {
      postData['userId'] = userId;
      postData['type'] = 'user';
    }

    print(postData);

    try {
      final response = await BaseService.dio.post(
        "promos/",
        data: json.encode(postData),
        options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),
      );
      print(response.data);
      if (response.statusCode == 201) {
        return Promo.fromJson(response.data['promo']);
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw AppException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }



  /// Fonction pour supprimer une promotion
  Future<bool> deletePromo({
    Promo? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "promos/${model!.sId}",
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw AppException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }

  Future<List<Promo>> getCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'promos/', /* queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } */
      );

      if (response.statusCode == 200) {
        List<Promo> list = (response.data['promos'] as List)
            .map((e) => Promo.fromJsonUser(e))
            .toList();
        return list;
      } else {
        throw AppException(message: response.data['msg']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['msg']);
    }
  }
}
