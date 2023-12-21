import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class CategoryService extends GetxService {
  Future<List<CategoryModel>> getCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'categories/', /* queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } */
      );

      if (response.statusCode == 200) {
        List<CategoryModel> list = (response.data['categories'] as List)
            .map((e) => CategoryModel.fromJson(e))
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