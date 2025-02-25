import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/commandes/services/commandeService.dart';

class CommandeController extends GetxController
    with StateMixin<List<Commande>> {
  RxList<Commande> categoryList = <Commande>[].obs;
  final CommandeService homeService = Get.put(CommandeService());
  RxBool loadingPurchase = false.obs;

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

  Future<bool> createCommande(
      {Book? book, User? user, BuildContext? context}) async {
    double amount = book!.prix! - (book.prix! * book.pourcentage!) / 100;

    Map<String, dynamic> paymentData = {
      "author": "${book.author!.sId}",
      "book": "${book.sId}",
      "montant": amount.toInt(),
      "deviceId": user!.deviceId,
    };
    loadingPurchase.value = true;

    try {
      await homeService.createCommande(
        paymentData: paymentData,
      );

      loadingPurchase.value = false;
      return true;
    } on AppException catch (e) {
      loadingPurchase.value = false;
      showCustomToast(message: e.message!, context: context!);
      return false;
    }
  }

  Future<bool> confirmOrder({Commande? commande, BuildContext? context}) async {
    try {
      await homeService.confirmOrder(
        commande: commande,
      );
      showCustomToast(
          message:
              "commande active et disponible dans les commandes utilisateurs",
          context: context!);
      return true;
    } on AppException catch (e) {
      loadingPurchase.value = false;
      showCustomToast(message: e.message!, context: context!);
      return false;
    }
  }
}
