import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class PartnerService extends getX.GetxService {
  
  // Récupérer la liste des partenaires
  Future<List<Partner>> getPartners({
    int? page,
    int? pageSize,
    String? status,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['limit'] = pageSize;
      if (status != null) queryParams['status'] = status;

      final response = await BaseService.dio.get(
        'partners/',
        queryParameters: queryParams,
      );
      print(response.data);

      if (response.statusCode == 200) {
        List<Partner> list = (response.data['data']['partners'] as List)
            .map((e) => Partner.fromJson(e))
            .toList();
        return list;
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.response!.data);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Créer un nouveau partenaire
  Future<Partner> createPartner({
    required String name,
    required String email,
    String? description,
    required String startDate,
    required String endDate,
    int? maxUsers,
    List<String>? allowedCategories,
    List<String>? allowedBooks,
    double? commission,
    required ContactPerson contactPerson,
    String? webhookUrl,
    PartnerSettings? settings,
  }) async {
    try {
      Map<String, dynamic> partnerData = {
        'name': name,
        'email': email,
        'startDate': startDate,
        'endDate': endDate,
        'contactPerson': contactPerson.toJson(),
      };

      if (description != null) partnerData['description'] = description;
      if (maxUsers != null) partnerData['maxUsers'] = maxUsers;
      if (allowedCategories != null) partnerData['allowedCategories'] = allowedCategories;
      if (allowedBooks != null) partnerData['allowedBooks'] = allowedBooks;
      if (commission != null) partnerData['commission'] = commission;
      if (webhookUrl != null) partnerData['webhookUrl'] = webhookUrl;
      if (settings != null) partnerData['settings'] = settings.toJson();

      final response = await BaseService.dio.post(
        'partners/',
        data: json.encode(partnerData),
      );

      if (response.statusCode == 201) {
        return Partner.fromJson(response.data['data']['partner']);
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Mettre à jour un partenaire
  Future<Partner> updatePartner({
    required String partnerId,
    String? name,
    String? email,
    String? description,
    String? startDate,
    String? endDate,
    int? maxUsers,
    List<String>? allowedCategories,
    List<String>? allowedBooks,
    double? commission,
    ContactPerson? contactPerson,
    String? webhookUrl,
    PartnerSettings? settings,
  }) async {
    try {
      Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (description != null) updateData['description'] = description;
      if (startDate != null) updateData['startDate'] = startDate;
      if (endDate != null) updateData['endDate'] = endDate;
      if (maxUsers != null) updateData['maxUsers'] = maxUsers;
      if (allowedCategories != null) updateData['allowedCategories'] = allowedCategories;
      if (allowedBooks != null) updateData['allowedBooks'] = allowedBooks;
      if (commission != null) updateData['commission'] = commission;
      if (contactPerson != null) updateData['contactPerson'] = contactPerson.toJson();
      if (webhookUrl != null) updateData['webhookUrl'] = webhookUrl;
      if (settings != null) updateData['settings'] = settings.toJson();

      final response = await BaseService.dio.patch(
        'partners/$partnerId',
        data: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        return Partner.fromJson(response.data['data']['partner']);
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.response!.data);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Désactiver un partenaire (mise à jour du statut)
  Future<Partner> deactivatePartner({
    required String partnerId,
    String status = 'inactive',
  }) async {
    try {
      Map<String, dynamic> statusData = {
        'status': status,
      };

      final response = await BaseService.dio.patch(
        'partners/$partnerId',
        data: json.encode(statusData),
      );

      if (response.statusCode == 200) {
        return Partner.fromJson(response.data['data']['partner']);
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Supprimer un partenaire
  Future<bool> deletePartner({
    required String partnerId,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        'partners/$partnerId',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Régénérer l'API key d'un partenaire
  Future<Partner> regenerateApiKey({
    required String partnerId,
  }) async {
    try {
      final response = await BaseService.dio.patch(
        'partners/$partnerId/regenerate-api-key',
      );

      if (response.statusCode == 200) {
        return Partner.fromJson(response.data['data']['partner']);
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Récupérer un partenaire par ID
  Future<Partner> getPartnerById({
    required String partnerId,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'partners/$partnerId',
      );

      if (response.statusCode == 200) {
        return Partner.fromJson(response.data['partner']);
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }

  // Mettre à jour le solde d'un partenaire
  Future<Partner> updatePartnerBalance({
    required String partnerId,
    required double balance,
  }) async {
    try {
      Map<String, dynamic> balanceData = {
        'balance': balance,
      };

      final response = await BaseService.dio.patch(
        'partners/$partnerId/balance',
        data: json.encode(balanceData),
      );

      if (response.statusCode == 200) {
        return Partner.fromJson(response.data['partner']);
      } else {
        throw AppException(message: response.data['msg'] ?? "Une erreur est survenue");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg'] ?? "Une erreur est survenue");
      } else {
        throw AppException(message: "Vérifiez votre connexion internet et réessayez");
      }
    }
  }
}
