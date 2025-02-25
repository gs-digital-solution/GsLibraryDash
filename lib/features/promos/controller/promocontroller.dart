import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/promos/models/promo.dart';
import 'package:gslibrarydashboard/features/promos/services/promoservice.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';

class PromoController extends GetxController with StateMixin<List<Promo>> {
  TextEditingController code = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController gain = TextEditingController();

  Promo? promo;
  RxBool isLoading = false.obs;
  RxList<Promo> categoryList = <Promo>[].obs;
  final PromoService homeService = Get.put(PromoService());
  final HomeController homeController = Get.find();

  String oldCategory = '';
  RxString category = 'text'.obs;
  RxString slider = ''.obs;
  RxString author = ''.obs;

  PromoController({this.promo});

  List<int>? avatar;
  RxString? filename = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  setAllCategoryDate(Promo? category) {
    if (category != null) {
      promo = category;
    }
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await homeService.getCategories();
      print(categoryList.length);
      if (categoryList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(categoryList, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  clearData() {
    code.clear();
    discount.clear();
    gain.clear();

    promo = null;
    isLoading = false.obs;

    oldCategory = '';
  }

  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
      return '';
    }
  }

  bool isSvg = false;

  void setPromo(Promo mypromo) {
    code.text = mypromo.code!.toUpperCase();
    discount.text = mypromo.discount.toString();
    gain.text = mypromo.gain.toString();

    homeController.selectedItem!.value = AdminMenuItem(
      title: 'ajouter un code promo',
      icon: Icons.add,
      route: '/promos/add',
    );
    promo=mypromo;
  }

  Future<void> addCategory({User? user}) async {
    isLoading.value = true;
    try {
       await homeService.addPromo(
        code: code.text,
        discount: int.parse(discount.text),
        gain: int.parse(gain.text),
        userId: user!.sId,
      );

      Fluttertoast.showToast(
          msg: "Code Promo ajoutee", backgroundColor: Colors.green);
      fetchCategoryData();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updatePromo({Author? user, Promo? promo}) async {
    isLoading.value = true;
    try {
       await homeService.updatePromo(
          code: code.text,
          discount: int.parse(discount.text),
          promo: promo,
          gain: int.parse(gain.text),
          userId: promo!.userId,
          active: promo.active!.value);

      Fluttertoast.showToast(
          msg: "Code Promo Mis a jour", backgroundColor: Colors.green);
      fetchCategoryData();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  void genererChaine() {
    const caracteres =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    code.text = List.generate(
            6, (index) => caracteres[random.nextInt(caracteres.length)])
        .join()
        .toUpperCase();
  }

  Future<void> updatePromoStatus({Author? user, Promo? promo}) async {
    isLoading.value = true;
    try {
       await homeService.updatePromo(
          code: promo!.code,
          discount: promo.discount,
          promo: promo,
          gain: promo.gain,
          userId: promo.user!.sId,
          active: promo.active!.value);

      Fluttertoast.showToast(
          msg: "Status du Code promo mis a jour",
          backgroundColor: Colors.green);
      fetchCategoryData();
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  ///Definir la premiere categorie

  Future<void> deleteCategory({Promo? model}) async {
    try {
      await homeService.deletePromo(
        model: model,
      );
      int index =
          categoryList.indexWhere((element) => element.sId == model!.sId);
      categoryList.removeAt(index);

      Fluttertoast.showToast(
          msg: "Code promo supprime", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (_) {
      isLoading.value = false;
    }
  }
}
