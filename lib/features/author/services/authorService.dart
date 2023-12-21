import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class AuthorService extends GetxService {


  Future<List<TopAuthors>> getAuthors({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'users/partners', /* queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } */
      );

      if (response.statusCode == 200) {
        List<TopAuthors> list = (response.data['allusers'] as List)
            .map((e) => TopAuthors.fromJson(e))
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