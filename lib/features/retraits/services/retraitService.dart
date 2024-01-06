import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class RetraitService extends getX.GetxService {
  Future<List<Retrait>> getCommandes({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await BaseService.dio.get(
        'retraits',  queryParameters: {
        "page": page,
        "pageSize": pageSize,
      } 
      );

      print(response.data);

      if (response.statusCode == 200) {
        List<Retrait> list = (response.data['commandes'] as List)
            .map((e) => Retrait.fromJson(e))
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
