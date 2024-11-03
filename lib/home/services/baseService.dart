import 'package:dio/dio.dart';

class BaseService {
  static Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(minutes:5),
      receiveTimeout: Duration(minutes: 5),
      //baseUrl: "https://api.groupesiewe.com/api/v1/",
      baseUrl:"https://test.gslibrary2024.com/api/v1/",
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}