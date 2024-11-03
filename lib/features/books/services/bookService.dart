import 'dart:convert';

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
    bool? popular,
    bool? featured,
  }) async {
    FormData formData = FormData.fromMap({'files': []});

    //print(description);

    formData.files.add(MapEntry(
      'gratuite',
      await MultipartFile.fromBytes(
        gratuite!,
        filename: gratuiteFilename,
      ),
    ));
    if (payante!.isNotEmpty) {
      formData.files.add(MapEntry(
        'payante',
        await MultipartFile.fromBytes(
          payante,
          filename: payanteFilename,
        ),
      ));
    }
    formData.files.add(MapEntry(
      'avatar',
      await MultipartFile.fromBytes(
        avatar!,
        filename: filename,
      ),
    ));

    formData.fields.add(MapEntry("nom", nom!));
    formData.fields.add(MapEntry("author", topAuthors!.sId!));
    formData.fields.add(MapEntry("categories", categoryModel!.sId!));
    formData.fields.add(MapEntry("prix", prix!));
    formData.fields.add(MapEntry("pourcentage", pourcentage!));
    formData.fields.add(MapEntry("description", description!));
    formData.fields.add(MapEntry("popular", '$popular'));
    formData.fields.add(MapEntry("featured", '$featured'));
    //  formData.fields.add(MapEntry("status", '${true}'));
    //print(formData.fields);

    try {
      final response = await BaseService.dio.post(
        "books",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
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

  Future<Book> updateBook({
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
    Book? book,
    bool? popular,
    bool? featured,
  }) async {
    FormData formData = FormData.fromMap({});

    if (avatar!.isNotEmpty) {
      print("avatar");
      formData.files.add(MapEntry(
        'avatar',
        await MultipartFile.fromBytes(
          avatar,
          filename: filename,
        ),
      ));
    }

    if (gratuite!.isNotEmpty) {
      print("gratuite");
      formData.files.add(MapEntry(
        'gratuite',
        await MultipartFile.fromBytes(
          gratuite,
          filename: gratuiteFilename,
        ),
      ));
    }

    if (payante!.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'payante',
          await MultipartFile.fromBytes(
            payante,
            filename: payanteFilename,
          ),
        ),
      );
    }

    formData.fields.add(MapEntry("nom", nom!));
    formData.fields.add(MapEntry("author", topAuthors!.sId!));
    formData.fields.add(MapEntry("categories", categoryModel!.sId!));
    formData.fields.add(MapEntry("prix", prix!));
    formData.fields.add(MapEntry("pourcentage", pourcentage!));
    formData.fields.add(MapEntry("description", description!));
    formData.fields.add(MapEntry("popular", '$popular'));
    formData.fields.add(MapEntry("featured", '$featured'));
    print(formData.files);

    try {
      final response = await BaseService.dio.post(
        "books/${book!.sId}",
        data: formData,
        /* options: Options(
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ), */
      );
      print(response.data);
      if (response.statusCode == 201) {
        return Book.fromJson(response.data['book']);
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.error);
      print(e.error);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(message: e.response!.data['msg']);
      } else {
        throw AppException(
            message: "Verifier votre connexion internet et ressayez");
      }
    }
  }

  Future<Book> updateBookStatus({
    bool? status,
    Book? book,
  }) async {
    FormData formData = FormData.fromMap({});
    formData.fields.add(MapEntry("status", '$status'));
    try {
      final response =
          await BaseService.dio.post("books/${book!.sId}", data: formData);

      if (response.statusCode == 201) {
        return Book.fromJson(response.data['book']);
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.error);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(
          message: e.response!.data['msg'],
        );
      } else {
        throw AppException(
          message: "Verifier votre connexion internet et ressayez",
        );
      }
    }
  }

  Future<Book> updateBookPromotion({
    bool? hasPromo,
    Book? book,
    int?pourcentageReduction,
  }) async {
    Map<String,dynamic> promoData={
      "hasPromo": hasPromo,
    };
    if(pourcentageReduction!=null){
      promoData['pourcentageReduction']=pourcentageReduction;
    }
    try {
      final response = await BaseService.dio.post("books/promo/${book!.sId}",
          data: json.encode(promoData));

      if (response.statusCode == 201) {
        return Book.fromJson(response.data['book']);
      } else {
        throw AppException(message: "Une erreur est survenue");
      }
    } on DioException catch (e) {
      print(e.response!.data);
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(
          message: e.response!.data['msg'],
        );
      } else {
        throw AppException(
          message: "Verifier votre connexion internet et ressayez",
        );
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
