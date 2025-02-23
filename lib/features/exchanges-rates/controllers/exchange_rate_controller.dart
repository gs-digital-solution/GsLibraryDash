import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/models/exchange_rate.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/services/exchange_rate_service.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';

class ExchangeRateController extends GetxController
    with StateMixin<List<ExchangeRate>> {
  RxList<ExchangeRate> exchangeRates = <ExchangeRate>[].obs;
  final ExchangeRateService _exchangeRateService =
      Get.put(ExchangeRateService());

  TextEditingController countryFrom = TextEditingController();
  TextEditingController countryTo = TextEditingController();
  TextEditingController rate = TextEditingController();
  RxBool loading = false.obs;

  final HomeController homeController = Get.find();

  ExchangeRate? exchangeRate;

  @override
  void onInit() {
    super.onInit();
    getExchangeRates();
  }

  void setPromo(ExchangeRate exchange) {
    countryFrom.text = exchange.countryFrom!;
    countryTo.text = exchange.countryTo!;
    rate.text = exchange.rate.toString();

    homeController.selectedItem!.value = AdminMenuItem(
      title: "ajouter un taux d'echange",
      icon: Icons.add,
      route: '/exchanges-rates/add',
    );
    exchangeRate = exchange;
  }

  void clearData() {
    countryFrom.clear();
    countryTo.clear();
    rate.clear();
  }

  Future<void> getExchangeRates() async {
    change(null, status: RxStatus.loading());
    try {
      exchangeRates.value = await _exchangeRateService.getExchangeRates();
      if (exchangeRates.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(exchangeRates, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  Future<void> createExchangeRate() async {
    loading.value = true;
    ExchangeRate exchangeRate = ExchangeRate(
      countryFrom: countryFrom.text.toUpperCase().trim(),
      countryTo: countryTo.text.toUpperCase().toString(),
      rate: double.parse(rate.text),
    );
    print(exchangeRate.toJson());
    try {
      bool value = await _exchangeRateService.createExchangeRate(
          exchangeRate: exchangeRate);
      loading.value = false;
      clearData();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("Taux d'echanges ajouter avec success"),
        ),
      );
      getExchangeRates();
    } on AppException catch (e) {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  Future<void> updateExchangeRate() async {
    loading.value = true;
    ExchangeRate exchangeRate = ExchangeRate(
      countryFrom: countryFrom.text.toLowerCase().trim(),
      countryTo: countryTo.text.toUpperCase().toString(),
      rate: double.parse(rate.text),
    );
    try {
      bool value = await _exchangeRateService.updateExchangeRate(
          exchangeRate: exchangeRate);
      loading.value = false;
      clearData();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("Taux d'echanges mis a jour avec success"),
        ),
      );
      getExchangeRates();
    } on AppException catch (e) {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  Future<void> deleteExchangeRate({ExchangeRate? exchangeRate}) async {
    try {
      bool value = await _exchangeRateService.deleteExchangeRate(
          exchangeRate: exchangeRate);
      int index = exchangeRates.indexWhere(
        (element) =>
            element.countryFrom == exchangeRate!.countryFrom &&
            element.countryTo == exchangeRate.countryTo,
      );
      exchangeRates.removeAt(index);

      int indexR = exchangeRates.indexWhere(
        (element) =>
            element.countryFrom == exchangeRate!.countryTo &&
            element.countryTo == exchangeRate.countryFrom,
      );
      exchangeRates.removeAt(indexR);

      getExchangeRates();

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("Taux d'echange supprimee"),
        ),
      );
    } on AppException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }
}
