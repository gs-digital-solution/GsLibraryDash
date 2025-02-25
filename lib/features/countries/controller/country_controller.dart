import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/countries/services/countries_service.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';

class CountryController extends GetxController with StateMixin<List<Country>> {
  @override
  void onInit() {
    super.onInit();
    getCountries();
  }

  RxList<Country> countries = <Country>[].obs;
  final CountryService countryService = Get.put(CountryService());
  final HomeController homeController = Get.find();

  TextEditingController name = TextEditingController();

  TextEditingController serviceCode = TextEditingController();
  RxString countryFlag = ''.obs;
  RxString countryCode = ''.obs;

  String currency = "XAF";

  RxBool isLoading = false.obs;

  Country? country;

  void setPromo(Country mypromo) {
    name.text = mypromo.name!.value;
    currency = mypromo.currency!;
    countryCode.value = mypromo.countryCode!.value;
    countryFlag.value = mypromo.countryFlag!.value;
    serviceCode.text = mypromo.serviceCode!.value;

    homeController.selectedItem!.value = AdminMenuItem(
      title: 'ajouter un pays',
      icon: Icons.add,
      route: '/countries/add',
    );
    country = mypromo;
  }

  void clearData() {
    name.clear();
    serviceCode.clear();
    countryCode.value = '';
    countryFlag.value = '';
  }

  Future<void> getCountries() async {
    change(null, status: RxStatus.loading());
    try {
      countries.value = await countryService.getCountries();
      if (countries.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(countries, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  Future<void> addCategory() async {
    isLoading.value = true;

    Country country = Country(
      name: RxString(name.text),
      currency: currency,
      countryCode: countryCode,
      countryFlag: countryFlag,
      isActivated: RxBool(true),
      serviceCode: RxString(serviceCode.text),
    );
    try {
       await countryService.createCountry(country: country);

      Fluttertoast.showToast(
          msg: "Pays Ajouter", backgroundColor: Colors.green);
      getCountries();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updatePromo({Country? promo}) async {
    isLoading.value = true;
    Country country = Country(
      id: promo!.id,
      name: RxString(name.text),
      currency: currency,
      countryCode: countryCode,
      countryFlag: countryFlag,
      isActivated: RxBool(true),
      serviceCode: RxString(serviceCode.text),
    );
    try {
      await countryService.updateCountry(
        country: country,
      );

      Fluttertoast.showToast(
          msg: "Code Promo Mis a jour", backgroundColor: Colors.green);
      getCountries();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updatePromoStatus({Country? promo}) async {
    isLoading.value = true;
    try {
       await countryService.updateCountry(
        country: promo,
      );

      Fluttertoast.showToast(
          msg: "Status du Pays promo mis a jour",
          backgroundColor: Colors.green);
      getCountries();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> deleteCountry({Country? model}) async {
    try {
      await countryService.deleteCategory(
        model: model,
      );
      int index = countries.indexWhere((element) => element.id == model!.id);
      countries.removeAt(index);

      Fluttertoast.showToast(
          msg: "Pays supprimee", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (_) {
      isLoading.value = false;
    }
  }
}
