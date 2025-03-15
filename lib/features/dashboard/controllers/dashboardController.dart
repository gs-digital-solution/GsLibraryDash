import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/dashboard/models/dashboardData.dart';
import 'package:gslibrarydashboard/features/dashboard/models/stat.dart';
import 'package:gslibrarydashboard/features/dashboard/services/statService.dart';
import 'package:gslibrarydashboard/features/payment_methods/models/payment_method.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

class DashboardController extends GetxController {
  final StatService statService = Get.put(StatService());

  TextEditingController amount = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  Country? country;
  PaymentMethod? paymentMethod;

  RxBool isLoading = false.obs;

  RxString message = ''.obs;

  List<CashIn> cashIns = [
    CashIn(name: "Orange Money", cashIn: "CASHINOMCMPART2"),
    CashIn(name: "MTN MOBILE MONEY", cashIn: "CASHINMTNCMPART"),
  ];

  CashIn selectedCashIn =
      CashIn(name: "Orange Money", cashIn: "CASHINOMCMPART2");

  Future<Stat> getStatAdmin() async {
    return statService.getStat();
  }

  Future<void> initRetraitAdmin() async {
    message.value = '';
    isLoading.value = true;
    try {
      await statService.createRetraitAdmin(
        amountToPay: amount.text,
        montant: amount.text,
        serviceId: selectedCashIn.cashIn,
        receiver: phoneNumber.text,
        password: password.text,
      );
      amount.clear();
      password.clear();
      phoneNumber.clear();
      Get.back();
      isLoading.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            "Retrait effectue avec success",
            style: TextStyle(
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    } on AppException catch (e) {
      isLoading.value = false;
      message.value = e.message!;
    }
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

class CashIn {
  String? name;
  String? cashIn;
  CashIn({this.name, this.cashIn});
}
