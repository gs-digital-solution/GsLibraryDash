import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class RetraitService extends getX.GetxService {
  Future<Map<String, dynamic>> getCommandes({
    int? page,
    int? pageSize,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['pageSize'] = pageSize;

      final response = await BaseService.dio.get('retraits', queryParameters: queryParams);

      print(response.data);

      if (response.statusCode == 200) {
        List<Retrait> list = (response.data['retraits'] as List)
            .map((e) => Retrait.fromJson(e))
            .toList();
            
        // Extraire les informations de pagination
        PaginationInfo paginationInfo = PaginationInfo.fromJson(response.data);

        print("numOfPages: ${paginationInfo.numOfPages}");
        print("total: ${paginationInfo.total}");
        print("currentPage: ${paginationInfo.currentPage}");
        print("pageSize: ${paginationInfo.pageSize}");
        
        return {
          'retraits': list,
          'pagination': paginationInfo,
        };
      } else {
        throw AppException(message: response.data['msg']);
      }
    } on DioException catch (e) {
      print(e.message);
      throw AppException(message: e.response!.data['msg']);
    }
  }

  Future<bool> createRetrait({Map<String, dynamic>? data}) async {
    try {
      final response =
          await BaseService.dio.post('retraits', data: json.encode(data));
      if (response.statusCode == 201) {
        return true;
      } else {
        throw AppException(message: response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw AppException(
            message:
                "Une erreur est survenue. Verifier votre connexion internet et ressayez");
      }
    }
  }
}
