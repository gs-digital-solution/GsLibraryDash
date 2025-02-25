import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/history/models/history.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class HistoryService extends getX.GetxService {
  /// Fonction pour supprimer une category
  Future<bool> deleteCategory({
    History? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "history/${model!.sId}",
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

  Future<List<History>> getCategories(
      {int? page, int? pageSize, String? userId}) async {
    try {
      final response = await BaseService.dio.get('history/', queryParameters: {
        "userId": userId,
      });

      if (response.statusCode == 200) {
        List<History> list = (response.data['promos'] as List)
            .map((e) => History.fromJson(e))
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
