import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class CommandeService extends getX.GetxService {
  Future<List<Commande>> getCommandes({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'commandes',  queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } 
      );

      print(response.data);

      if (response.statusCode == 200) {
        List<Commande> list = (response.data['commandes'] as List)
            .map((e) => Commande.fromJson(e))
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





  Future<bool> deleteBook({
    Book? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "books/${model!.sId}",
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
}
