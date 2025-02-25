import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/payment_methods/models/payment_method.dart';
import 'package:gslibrarydashboard/features/payment_methods/services/payment_method_service.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';

class PaymentMethodController extends GetxController
    with StateMixin<List<PaymentMethod>> {
  @override
  void onInit() {
    super.onInit();
    getCountries();
  }

  RxList<PaymentMethod> countries = <PaymentMethod>[].obs;
  final PaymentMethodService countryService = Get.put(PaymentMethodService());
  final HomeController homeController = Get.find();

  TextEditingController name = TextEditingController();
  TextEditingController ussCode = TextEditingController();
  TextEditingController priority = TextEditingController();

  TextEditingController countryName = TextEditingController();
  RxString countryId = ''.obs;
  RxString countryCode = ''.obs;

  RxBool isLoading = false.obs;

  PaymentMethod? country;

  void setPromo(PaymentMethod mypromo) {
    print(mypromo.priority!);
    name.text = mypromo.name!.value;
    ussCode.text = mypromo.ussdCode!.value;
    priority.text =
        mypromo.priority != null ? mypromo.priority!.value.toString() : "";
    countryName.text = mypromo.country!.name!.value;
    countryId.value = mypromo.country!.id!;
    homeController.selectedItem!.value = AdminMenuItem(
      title: 'Nouvelle Methode de paiement',
      icon: Icons.add,
      route: '/paymentMethods/add',
    );
    country = mypromo;
  }

  void clearData() {
    name.clear();
    countryName.clear();
    ussCode.clear();
    priority.clear();
    countryCode.value = '';
    countryId.value = '';
    country = null;
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

    PaymentMethod country = PaymentMethod(
      name: RxString(name.text),
      ussdCode: RxString(ussCode.text.toString()),
      priority: RxInt(int.parse(priority.text)),
      country: Country(id: countryId.value),
      isActivated: RxBool(true),
    );
    print(country.toMap());
    try {
      
          await countryService.createCountry(country: country);

      Fluttertoast.showToast(
          msg: "Methode de paiement Ajoutee", backgroundColor: Colors.green);
      getCountries();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updatePromo({PaymentMethod? promo}) async {
    isLoading.value = true;
    try {
      PaymentMethod myCountry = PaymentMethod(
        id: promo!.id,
        name: RxString(name.text),
        ussdCode: RxString(ussCode.text.toString()),
        priority: RxInt(int.parse(priority.text)),
        country: Country(id: countryId.value),
        isActivated: promo.isActivated,
      );
       await countryService.updateCountry(
        country: myCountry,
      );

      Fluttertoast.showToast(
          msg: "Methode de paiement mise a jour",
          backgroundColor: Colors.green);
      getCountries();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updatePromoStatus({PaymentMethod? promo}) async {
    isLoading.value = true;
    try {
       await countryService.updateCountry(
        country: promo,
      );

      Fluttertoast.showToast(
          msg: "Status mis a jour", backgroundColor: Colors.green);
      getCountries();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> deleteCountry({PaymentMethod? model}) async {
    try {
      await countryService.deleteCategory(
        model: model,
      );
      int index = countries.indexWhere((element) => element.id == model!.id);
      countries.removeAt(index);

      Fluttertoast.showToast(
          msg: "Methode de paiement supprimee", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (_) {
      isLoading.value = false;
    }
  }
}
