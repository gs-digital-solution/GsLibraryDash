import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';
import 'package:gslibrarydashboard/features/retraits/services/retraitService.dart';

class RetraitController extends GetxController with StateMixin<List<Retrait>> {
  RxList<Retrait> categoryList = <Retrait>[].obs;
  final RetraitService homeService = Get.put(RetraitService());

  TopAuthors? topAuthors;
  TextEditingController authController = TextEditingController();
  TextEditingController amount = TextEditingController();
  RxBool loading = false.obs;
  String oldCategory = '';
  
  // Paramètres de pagination
  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;
  RxInt totalItems = 0.obs;
  RxInt totalPages = 0.obs;
  
  // Cache pour stocker les données de chaque page
  Map<int, List<Retrait>> pageCache = <int, List<Retrait>>{};

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
      Map<String, dynamic> result = await homeService.getCommandes(
        page: currentPage.value,
        pageSize: pageSize.value,
      );

      List<Retrait> retraits = result['retraits'];
      PaginationInfo pagination = result['pagination'];

      // Mettre à jour les informations de pagination
      totalItems.value = pagination.total;
      totalPages.value = pagination.numOfPages;

      // Stocker les données dans le cache
      pageCache[currentPage.value] = retraits;
      
      // Afficher les données de la page actuelle
      categoryList.value = retraits;

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

  Future<void> createRetrait({BuildContext? context}) async {
    loading.value = true;
    try {
      Map<String, dynamic> retraitData = {
        "author": topAuthors!.sId,
        "montant": int.parse(amount.text),
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
