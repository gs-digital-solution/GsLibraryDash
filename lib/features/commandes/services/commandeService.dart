import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class CommandeService extends getX.GetxService {
  Future<List<Commande>> getCommandes({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get('commandes', queryParameters: {
        "page": page,
        "pageSize": pageSize,
      });

      print(response.data);

      if (response.statusCode == 200) {
        List<Commande> list = (response.data['commandes'] as List)
            .map((e) => Commande.fromJson(e))
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

    Future<List<User>> getUsers({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get('users', queryParameters: {
        "page": page,
        "pageSize": pageSize,
      });

      print(response.data);

      if (response.statusCode == 200) {
        List<User> list = (response.data['allusers'] as List)
            .map((e) => User.fromJson(e))
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

  Future<bool> deleteBook({
    Book? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "books/${model!.sId}",
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

  Future<bool> createCommande({
    Map<String, dynamic>? paymentData,
  }) async {
    try {
      final response = await BaseService.dio.post(
        "commandes/admin",
        data: json.encode(paymentData),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw AppException(message: "Verifier votre connection internet et ressayez-svp");
      } else if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw Exception(e.message);
      }
    }
  }

    Future<bool> confirmOrder({
    Commande?commande,
  }) async {
    print(commande);
    try {
      final response = await BaseService.dio.post(
        "commandes/activate/${commande!.sId}",
      
      );
      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(message: response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw AppException(message: "Verifier votre connection internet et ressayez-svp");
      } else if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
