import 'package:dio/dio.dart';

class BaseService {
  static Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      baseUrl: "https://arcane-cove-19506-d9cc2939854a.herokuapp.com/api/v1/",
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}