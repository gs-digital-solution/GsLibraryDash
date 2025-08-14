import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';
import 'package:gslibrarydashboard/features/commandes/services/commandeService.dart';

class CommandeController extends GetxController
    with StateMixin<List<Commande>> {
  RxList<Commande> categoryList = <Commande>[].obs;
  final CommandeService homeService = Get.put(CommandeService());
  RxBool loadingPurchase = false.obs;

  String oldCategory = '';
  
  // Paramètres de pagination
  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;
  RxInt totalItems = 0.obs;
  RxInt totalPages = 0.obs;
  
  // Cache pour stocker les données de chaque page
  Map<int, List<Commande>> pageCache = <int, List<Commande>>{};
  
  // Filtres
  RxString selectedStatus = 'all'.obs;
  RxString searchQuery = ''.obs;

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
        status: selectedStatus.value,
        search: searchQuery.value,
      );

      List<Commande> commandes = result['commandes'];
      PaginationInfo pagination = result['pagination'];

      // Mettre à jour les informations de pagination
      totalItems.value = pagination.total;
      totalPages.value = pagination.numOfPages;

      // Stocker les données dans le cache
      pageCache[currentPage.value] = commandes;
      
      // Afficher les données de la page actuelle
      categoryList.value = commandes;

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

  // Filtrer par statut
  void filterByStatus(String status) {
    selectedStatus.value = status;
    pageCache.clear(); // Vider le cache car le filtre a changé
    fetchCategoryData(refresh: true);
  }

  // Rechercher
  void search(String query) {
    searchQuery.value = query;
    pageCache.clear(); // Vider le cache car la recherche a changé
    fetchCategoryData(refresh: true);
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
