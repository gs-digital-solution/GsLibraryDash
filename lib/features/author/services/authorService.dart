import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class AuthorService extends getX.GetxService {
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
      print(response.data);
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

  Future<TopAuthors> addAuthor({
    List<int>? avatar,
    String? filename,
    String? name,
    String? firstname,
    String? lastname,
    String? email,
    String? phonenumber,
    String? password,
    String? designation,
    String? description,
    bool? status,
  }) async {
    FormData formData = FormData.fromMap({
      'avatar': await MultipartFile.fromBytes(avatar!, filename: filename),
    });

    formData.fields.add(MapEntry("firstname", firstname!));
    formData.fields.add(MapEntry("lastname", firstname));
    formData.fields.add(MapEntry("email", email!));
    formData.fields.add(MapEntry("phonenumber", phonenumber!));
    formData.fields.add(MapEntry("password", password!));
    formData.fields.add(MapEntry("description", description!));
    formData.fields.add(MapEntry("designation", designation!));
    formData.fields.add(MapEntry("status", '${status}'));

    print(formData.fields);

    try {
      final response = await BaseService.dio.post(
        "auth/partner/",
        data: formData,
        options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),
      );
      if (response.statusCode == 201) {
        return TopAuthors.fromJson(response.data['author']);
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

  Future<TopAuthors> updateAuthor(
      {List<int>? avatar,
      String? filename,
      String? name,
      String? firstname,
      String? lastname,
      String? email,
      String? phonenumber,
      String? password,
      String? designation,
      String? description,
      bool? status,
      TopAuthors? topAuthors}) async {
    FormData formData = FormData.fromMap({});

    if (avatar!.isNotEmpty) {
      formData.files.add(MapEntry(
        'avatar',
        await MultipartFile.fromBytes(
          avatar,
          filename: filename,
        ),
      ));
    }

    if (password!.isNotEmpty) {
      formData.fields.add(MapEntry("password", password));
    }

    formData.fields.add(MapEntry("firstname", firstname!));
    formData.fields.add(MapEntry("status", '${topAuthors!.status!}'));
    formData.fields.add(MapEntry("lastname", lastname!));
    formData.fields.add(MapEntry("email", email!));

    formData.fields.add(MapEntry("phonenumber", phonenumber!));
    formData.fields.add(MapEntry("description", description!));
    formData.fields.add(MapEntry("designation", designation!));

    print(formData.fields);
    print(formData.files);

    try {
      final response = await BaseService.dio.patch(
        "users/updateUser/${topAuthors.sId}",
        data: formData,
        options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        return TopAuthors.fromJson(response.data['user']);
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.message);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw AppException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }

  Future<bool> deleteCategory({
    TopAuthors? model,
  }) async {
    try {
      final response = await BaseService.dio.delete(
        "users/${model!.sId}",
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
