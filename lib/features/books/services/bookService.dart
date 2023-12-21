import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class BookService extends GetxService {
  Future<List<Book>> getCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'books/admin', /* queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } */
      );

      if (response.statusCode == 201) {
        List<Book> list = (response.data['books'] as List)
            .map((e) => Book.fromJson(e))
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