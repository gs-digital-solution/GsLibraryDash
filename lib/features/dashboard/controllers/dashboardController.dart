import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/dashboard/models/dashboardData.dart';
import 'package:gslibrarydashboard/features/dashboard/models/stat.dart';
import 'package:gslibrarydashboard/features/dashboard/services/statService.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';

class DashboardController extends GetxController {
  final StatService statService = Get.put(StatService());

  Future<Stat> getStatAdmin() async {
    return statService.getStat();
  }

  List<DashBoardData> getDashboardData() {
    return [
      DashBoardData(
          icon: 'dashboard_category_icon.svg',
          title: 'Commandes',
          backgroundColor: Color(0XFFFFEDE9),
          buttonColor: primaryColor,   
          ),
      DashBoardData(
          icon: 'dashboard_category_icon.svg',
          title: 'Paiement',
          backgroundColor: Color(0XFFFFEDE9),
          buttonColor: primaryColor,   
          ),
      DashBoardData(
        icon: 'dashboard_homeslider_slider.svg',
        title: 'Montant restant',
        backgroundColor: Color(0XFFD8F1E4),
        buttonColor: Color(0XFF36CB79),
      ),
      DashBoardData(
        icon: 'dashboard_featured_books_icon.svg',
        title: 'Featured Books',
        backgroundColor: Color(0XFFFFF6D4),
        buttonColor: Color(0XFFFFAE35),
        isFeatured: true,
      ),
      DashBoardData(
        icon: 'dashboard_populer_books_icon.svg',
        title: 'Populer Books',
        backgroundColor: Color(0XFFF3E7FF),
        buttonColor: Color(0XFFA67CFF),
        isPopular: true,
      ),
    ];
  }
}
