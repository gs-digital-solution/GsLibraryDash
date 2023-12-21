import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/authController.dart';
import 'package:gslibrarydashboard/features/auth/auth/states/authState.dart';
import 'package:gslibrarydashboard/features/auth/screens/login_page.dart';
import 'package:gslibrarydashboard/features/author/screens/addAuthorPage.dart';
import 'package:gslibrarydashboard/features/author/screens/authorPage.dart';
import 'package:gslibrarydashboard/features/categories/screens/addCategoryPage.dart';
import 'package:gslibrarydashboard/features/categories/screens/categoryPage.dart';
import 'package:gslibrarydashboard/home/pages/homePage.dart';

var appRoutes = {
  KeyUtil.homePage: (context) => HomePage(),
  KeyUtil.loginPage: (context) => LoginPage(),
};

Widget? getPageWidget(RouteSettings settings) {
  if (settings.name == null) {
    return null;
  }
  final uri = Uri.parse(settings.name!);
  switch (uri.path) {
    case '/':
      return Get.find<AuthController>().state is Authenticated
          ? HomePage()
          : LoginPage();
    case '/category':
      return CategoryScreen();
    case '/addcategory':
      return AddCategoryScreen();
    case '/authors':
      return AuthorScreen();
    case '/addauthor':
      return AddAuthorScreen();
  }
  return null;
}

class KeyUtil {
  static const String homePage = '/HomePage';
  static const String loginPage = '/LoginPage';
}
