import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';

import 'package:gslibrarydashboard/home/services/baseService.dart';

class UserService extends getX.GetxService {
  Future<List<User>> getCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get('users/', /* queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } */);

      if (response.statusCode == 200) {
        List<User> list = (response.data['allusers'] as List)
            .map((e) => User.fromJson(e))
            .toList();
        return list;
      } else {
        throw AppException(message: response.data['msg']);
      }
    } on DioException catch (e) {
      throw AppException(message: e.response!.data['msg']);
    }
  }
}
