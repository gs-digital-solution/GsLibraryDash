import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/features/retraits/services/retraitService.dart';

class RetraitController extends GetxController with StateMixin<List<Retrait>> {
  RxList<Retrait> categoryList = <Retrait>[].obs;
  final RetraitService homeService = Get.put(RetraitService());

  TopAuthors? topAuthors;
  TextEditingController authController = TextEditingController();
  TextEditingController amount = TextEditingController();
  RxBool loading = false.obs;
  String oldCategory = '';

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await homeService.getCommandes(page: 0, pageSize: 0);
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

  Future<void> createRetrait({BuildContext? context}) async {
    loading.value = true;
    try {
      Map<String, dynamic> retraitData = {
        "author": topAuthors!.sId,
        "montant": amount.text,
      };
       await homeService.createRetrait(data: retraitData);
      showCustomToast(context: context!, message: "paiement enregistre");
      loading.value = false;
      topAuthors = null;
      amount.clear();
    } on AppException catch (e) {
      loading.value = false;
      showCustomToast(context: context!, message: e.message!);
    }
  }
}
