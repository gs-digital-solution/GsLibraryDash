import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/authController.dart';
import 'package:gslibrarydashboard/features/auth/auth/services/authservice.dart';
import 'package:gslibrarydashboard/features/auth/auth/states/authState.dart';
import 'package:gslibrarydashboard/features/auth/screens/login_page.dart';
import 'package:gslibrarydashboard/features/author/screens/addAuthorPage.dart';
import 'package:gslibrarydashboard/features/author/screens/authorPage.dart';
import 'package:gslibrarydashboard/features/books/pages/addBook.dart';
import 'package:gslibrarydashboard/features/books/pages/bookPage.dart';
import 'package:gslibrarydashboard/features/categories/screens/categoryPage.dart';
import 'package:gslibrarydashboard/home/pages/homePage.dart';
import 'package:gslibrarydashboard/home/pages/privacy.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';
import 'package:gslibrarydashboard/features/partners/screens/partnerPage.dart';
import 'package:gslibrarydashboard/features/partners/screens/addPartnerPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  initialize();
  runApp(MyApp());
}

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
    case '/categories':
      return CategoryScreen();
    case '/categories/add':
      return CategoryScreen();
    case '/authors':
      return AuthorScreen();
    case '/authors/add':
      return AddAuthorScreen();
    case '/books':
      return StoryScreen();
    case '/books/add':
      return AddStoryScreen();
    case '/partners':
      return PartnerPage();
    case '/partners/add':
      return AddPartnerPage();
  }
  return null;
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
          locale: Locale('fr', "FR"),
          //
          scrollBehavior: AppScrollBehavior(),
          localizationsDelegates: [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: [
            Locale("fr", "FR"),
          ],
          routes: {
            '/': (_) => Get.find<AuthController>().state is Authenticated
                ? HomePage()
                : LoginPage(),
            /*   '/categories': (_) => CategoryScreen(),
            '/categories/add': (_) => AddCategoryScreen(),
            '/authors': (_) => AuthorScreen(),
            '/authors/add': (_) => AddAuthorScreen(),
            '/books': (_) => StoryScreen(),
            '/books/add': (_) => AddStoryScreen(),
            '/transactions/commandes': (_) => CommandePage(),
            '/transactions/paiements': (_) => RetraitPage(),
            '/transactions/add': (_) => NewRetrait(), */
            '/privacy': (_) => TermsAndConditionScreen(),
          },
          /* onGenerateRoute: (settings) {
            switch (settings.name) {
              case 'privacy':
              return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => TermsAndConditionScreen(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              });
                
                
              default:
               return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => Get.find<AuthController>().state is Authenticated
                ? HomePage()
                : LoginPage(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              });
            }
          },  */
          // initialRoute: '/',

          /* getPages: [
            GetPage(
                name: '/',
                page: () => Get.find<AuthController>().state is Authenticated
                    ? HomePage()
                    : LoginPage()),
            GetPage(name: '/privacy', page: () => TermsAndConditionScreen()),
          ], */

          themeMode: provider.themeMode,
          // darkTheme: AppTheme.darkTheme,

          /* initialRoute: Get.find<AuthController>().state is Authenticated
              ? KeyUtil.homePage
              : KeyUtil.loginPage, */
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
