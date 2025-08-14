import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/services/transfert_service.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';

import '../../auth/auth/controller/authController.dart';
import '../models/transfert.dart';

class TransfertDemandController extends GetxController
    with StateMixin<List<TransfertDevice>> {
  RxList<TransfertDevice> categoryList = <TransfertDevice>[].obs;

  final TransfertService categoryService = Get.put(TransfertService());
  final AuthController authController = Get.find();
  
  // Paramètres de pagination
  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;
  RxInt totalItems = 0.obs;
  RxInt totalPages = 0.obs;
  
  // Cache pour stocker les données de chaque page
  Map<int, List<TransfertDevice>> pageCache = <int, List<TransfertDevice>>{};

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData({bool refresh = false}) async {
    if (refresh) {
      categoryList.clear();
      pageCache.clear(); // Vider le cache lors d'un refresh
    }

    // Vérifier si les données de la page actuelle sont déjà en cache
    if (pageCache.containsKey(currentPage.value)) {
      categoryList.value = pageCache[currentPage.value]!;
      change(categoryList, status: RxStatus.success());
      return;
    }

    change(null, status: RxStatus.loading());
    try {
      Map<String, dynamic> result = await categoryService.getTransfertBookRequest(
        page: currentPage.value,
        pageSize: pageSize.value,
      );

      List<TransfertDevice> transferts = result['transferts'];
      PaginationInfo pagination = result['pagination'];

      // Mettre à jour les informations de pagination
      totalItems.value = pagination.total;
      totalPages.value = pagination.numOfPages;

      // Stocker les données dans le cache
      pageCache[currentPage.value] = transferts;
      
      // Afficher les données de la page actuelle
      categoryList.value = transferts;

      if (categoryList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(categoryList, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  // Changer de page
  Future<void> changePage(int page) async {
    if (page < 1 || page > totalPages.value) return;
    
    currentPage.value = page;
    await fetchCategoryData(refresh: false);
  }

  // Changer le nombre d'éléments par page
  Future<void> changePageSize(int size) async {
    pageSize.value = size;
    currentPage.value = 1; // Retour à la première page
    pageCache.clear(); // Vider le cache car la taille de page a changé
    await fetchCategoryData(refresh: false);
  }

  Future<void> validateTransfert(
      {TransfertDevice? transfertDevice, BuildContext? context}) async {
    try {
       await categoryService.validateTransfert(
        id: transfertDevice!.sId,
        deviceId: transfertDevice.newDeviceId,
        userId: transfertDevice.user!.sId,
      );

      int index = categoryList
          .indexWhere((element) => element.sId == transfertDevice.sId);
      categoryList[index].status!.value = 1;
      change(categoryList, status: RxStatus.success());
      showCustomToast(
          context: context!, message: "Transfert effectué avec succès.");
    } on AppException catch (e) {
      showCustomToast(context: context!, message: e.message!);
    }
  }

  Future<void> cancelTransfert(
      {TransfertDevice? transfertDevice, BuildContext? context}) async {
    try {
      await categoryService.cancelTransfertBook(
        id: transfertDevice!.sId,
      );
   
      int index = categoryList
          .indexWhere((element) => element.sId == transfertDevice.sId);
      categoryList[index].status!.value = -1;
      change(categoryList, status: RxStatus.success());
      showCustomToast(
          context: context!, message: "Demande de transfert Rejetée");
    } on AppException catch (e) {
      showCustomToast(context: context!, message: e.message!);
    }
  }
}
