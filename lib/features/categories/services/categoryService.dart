import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class CategoryService extends getX.GetxService {
  Future<CategoryModel> addCategory(
      {List<int>? avatar, String? filename, String? name}) async {
    FormData formData = FormData.fromMap({
      'avatar': await MultipartFile.fromBytes(avatar!, filename: filename),
    });
    formData.fields.add(MapEntry("name", name!));

    try {
      final response =
          await BaseService.dio.post("categories/", data: formData);
      if (response.statusCode == 201) {
        return CategoryModel.fromJson(response.data['category']);
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

  Future<CategoryModel> updateCategory({
    List<int>? avatar,
    String? filename,
    String? name,
    CategoryModel? model,
  }) async {
    FormData formData = FormData.fromMap({});
    if (avatar!=null) {
      formData.files.add(MapEntry(
        'avatar',
        await MultipartFile.fromBytes(
          avatar,
          filename: filename,
        ),
      ));
    }
    formData.fields.add(MapEntry("name", name ?? model!.name!));
    print(formData.fields);
    try {
      final response =
          await BaseService.dio.put("categories/${model!.sId}", data: formData);
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data['category']);
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

  /// Fonction pour supprimer une category
  Future<bool> deleteCategory({
    CategoryModel? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "categories/${model!.sId}",
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
