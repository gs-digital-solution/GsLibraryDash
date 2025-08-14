import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class UserService extends getX.GetxService {
  Future<Map<String, dynamic>> getCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['pageSize'] = pageSize;

      final response = await BaseService.dio.get('users/', queryParameters: queryParams);

      if (response.statusCode == 200) {
        List<User> list = (response.data['allusers'] as List)
            .map((e) => User.fromJson(e))
            .toList();
         print(response.data);   
        // Extraire les informations de pagination
        PaginationInfo paginationInfo = PaginationInfo.fromJson(response.data);
        
        return {
          'users': list,
          'pagination': paginationInfo,
        };
      } else {
        throw AppException(message: response.data['msg']);
      }
    } on DioException catch (e) {
      throw AppException(message: e.response!.data['msg']);
    }
  }
}
