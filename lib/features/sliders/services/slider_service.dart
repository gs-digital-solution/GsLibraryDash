import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/sliders/models/slider.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class SliderService extends getX.GetxService {
  Future<SliderModel> addCategory(
      {List<int>? avatar, String? filename, String? name}) async {
    FormData formData = FormData.fromMap({
      'avatar': await MultipartFile.fromBytes(avatar!, filename: filename),
    });

    try {
      final response =
          await BaseService.dio.post("sliders/", data: formData,options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),);
      if (response.statusCode == 201) {
        return SliderModel.fromJson(response.data['slider']);
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

  Future<SliderModel> updateCategory({
    List<int>? avatar,
    String? filename,
    SliderModel? model,
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
    try {
      final response =
          await BaseService.dio.put("sliders/${model!.sId}", data: formData,options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),);
      if (response.statusCode == 200) {
        return SliderModel.fromJson(response.data['slider']);
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
    SliderModel? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "sliders/${model!.sId}",
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

  Future<List<SliderModel>> getCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'sliders/', /* queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } */
      );

      if (response.statusCode == 200) {
        List<SliderModel> list = (response.data['sliders'] as List)
            .map((e) => SliderModel.fromJson(e))
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
