
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/auth/auth/model/adminUser.dart';


abstract class AuthApi extends GetxService {
  Future<AdminUser?> getCurrentUser();
  Future<void> signOut();
  Future<AdminUser> login({String? email, String? password});
}