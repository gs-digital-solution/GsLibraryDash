import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/authController.dart';
import 'package:gslibrarydashboard/features/auth/auth/states/authState.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

class HomeController extends GetxController {


  @override
  void onInit(){
    super.onInit();
     BaseService.dio.options.headers["Authorization"] = 'Bearer ${(authController.state as Authenticated).user!.token}';
  }

  final AuthController authController = Get.find();
  
  Rx<AdminMenuItem>? selectedItem = AdminMenuItem(
    title: 'Dashboard',
    icon: Icons.dashboard,
    route: '/',
  ).obs;
}
