import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class BookService extends getX.GetxService {
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

  Future<Book> addAuthor({
    List<int>? avatar,
    String? filename,
    List<int>? payante,
    String? payanteFilename,
    List<int>? gratuite,
    String? gratuiteFilename,
    String? nom,
    String? prix,
    String? pourcentage,
    TopAuthors? topAuthors,
    CategoryModel? categoryModel,
    String? description,
    bool? status,
  }) async {
    FormData formData = FormData.fromMap({
      'avatar': await MultipartFile.fromBytes(avatar!, filename: filename),
    });

    formData.files.add(MapEntry(
      'gratuite',
      await MultipartFile.fromBytes(
        gratuite!,
        filename: gratuiteFilename,
      ),
    ));
    formData.files.add(MapEntry(
      'payante',
      await MultipartFile.fromBytes(
        payante!,
        filename: payanteFilename,
      ),
    ));

    formData.fields.add(MapEntry("nom", nom!));
    formData.fields.add(MapEntry("author", topAuthors!.sId!));
    formData.fields.add(MapEntry("categories", categoryModel!.sId!));
    formData.fields.add(MapEntry("prix", prix!));
    formData.fields.add(MapEntry("pourcentage", pourcentage!));
    formData.fields.add(MapEntry("description", description!));
  //  formData.fields.add(MapEntry("status", '${true}'));
    print(filename);
    print(gratuiteFilename);
    print(payanteFilename);
    print(formData.files);

    try {
      final response = await BaseService.dio.post("books", data: formData);
      print(response.data);
      if (response.statusCode == 201) {
        return Book.fromJson(response.data['book']);
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
      print("check");
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

    formData.fields
        .add(MapEntry("fisrtname", firstname ?? topAuthors!.firstname!));
    formData.fields.add(MapEntry("status", '${topAuthors!.status!}'));
    formData.fields.add(MapEntry("lastname", lastname ?? topAuthors.lastname!));
    formData.fields.add(MapEntry("email", email ?? topAuthors.email!));

    formData.fields
        .add(MapEntry("phonenumber", phonenumber ?? topAuthors.phonenumber!));
    formData.fields
        .add(MapEntry("description", description ?? topAuthors.description!));
    formData.fields
        .add(MapEntry("designation", designation ?? topAuthors.designation!));

    print(formData.fields);
    print(formData.files);

    try {
      final response = await BaseService.dio
          .patch("users/updateUser/${topAuthors.sId}", data: formData);
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
