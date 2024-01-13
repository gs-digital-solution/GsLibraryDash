import 'package:dio/dio.dart';

class BaseService {
  static Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      baseUrl: "https://api.gslibrary2024.com/api/v1/",
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}