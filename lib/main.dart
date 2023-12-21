import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/authController.dart';
import 'package:gslibrarydashboard/features/auth/auth/services/authservice.dart';
import 'package:gslibrarydashboard/features/auth/auth/states/authState.dart';
import 'package:gslibrarydashboard/features/auth/screens/login_page.dart';
import 'package:gslibrarydashboard/features/author/screens/addAuthorPage.dart';
import 'package:gslibrarydashboard/features/author/screens/authorPage.dart';
import 'package:gslibrarydashboard/features/books/pages/bookPage.dart';
import 'package:gslibrarydashboard/features/categories/screens/addCategoryPage.dart';
import 'package:gslibrarydashboard/features/categories/screens/categoryPage.dart';
import 'package:gslibrarydashboard/home/pages/homePage.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';
import 'package:gslibrarydashboard/utils/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  initialize();
  runApp(MyApp());
}

class MyApp extends GetWidget<AuthController> {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (provider) {
        ThemeController().setThemeStatusBar(context);
        return GetMaterialApp(
          title: 'GSLIBRARY',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          //
          scrollBehavior: AppScrollBehavior(),

          supportedLocales: [
            Locale("en", " "),
          ],
        
          getPages: [
            GetPage(name: '/LoginPage', page: ()=>LoginPage()),
            GetPage(name: '/HomePage', page: ()=>HomePage()),
            GetPage(name: '/HomePage/categories', page: ()=>CategoryScreen()),
            GetPage(name: '/HomePage/categories/add', page: ()=>AddCategoryScreen()),
            GetPage(name: '/HomePage/authors', page: ()=>AuthorScreen()),
            GetPage(name: '/HomePage/authors/add', page: ()=>AddAuthorScreen()),
            GetPage(name: '/HomePage/books', page: ()=>StoryScreen()),
            
          ],

          themeMode: provider.themeMode,
         // darkTheme: AppTheme.darkTheme,
         
           initialRoute: Get.find<AuthController>().state is Authenticated
              ? KeyUtil.homePage
              : KeyUtil.loginPage, 
          
        );
      },
      init: ThemeController(),
    );
  }
}

setScreenSize(
  BuildContext context,
) {
  ScreenUtil.init(context, designSize: Size(1440, 900));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}

void initialize() async {
  Get.lazyPut(
    () => AuthController(
      Get.put(
        AuthService(),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
