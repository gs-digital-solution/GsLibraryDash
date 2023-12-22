import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<AdminMenuItem>? selectedItem = AdminMenuItem(
    title: 'Liste des categories',
    icon: Icons.list,
    route: '/HomePage',
  ).obs;
}
