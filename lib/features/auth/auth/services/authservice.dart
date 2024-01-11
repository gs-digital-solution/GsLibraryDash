import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gslibrarydashboard/features/auth/auth/api/authApi.dart';
import 'package:gslibrarydashboard/features/auth/auth/model/adminUser.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';
import 'package:gslibrarydashboard/utils/prefData.dart';

class AuthService extends AuthApi {
  @override
  Future<AdminUser?> getCurrentUser() async {
    AdminUser? user = await PrefData().getAdminUser();
    return user;
  }

  @override
  Future<AdminUser> login({String? email, String? password}) async {
    Map<String, dynamic> loginData = {
      "email": email,
      "password": password,
    };
    //print(loginData);
    try {
      final response = await BaseService.dio.post(
        'auth/login',
        data: json.encode(loginData),
      );
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        AdminUser adminUser = AdminUser.fromJson(response.data);
        await PrefData.setAdminUser(adminUser);
        return adminUser;
      } else {
        print(response.statusMessage);
        throw AuthException(
            message: response.data["msg"] + "${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AuthException(message: e.response!.data['msg']);
      } else {
        throw AuthException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await PrefData.removeUser();
  }
}

class AuthException implements Exception {
  final String? message;
  AuthException({this.message});
}
