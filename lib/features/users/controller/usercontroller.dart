import 'dart:html';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';
import 'package:gslibrarydashboard/features/users/services/userservice.dart';

class UserController extends GetxController with StateMixin<List<User>> {
  RxList<User> categoryList = <User>[].obs;
  final UserService homeService = Get.put(UserService());
  
  // Paramètres de pagination
  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;
  RxInt totalItems = 0.obs;
  RxInt totalPages = 0.obs;
  
  // Cache pour stocker les données de chaque page
  Map<int, List<User>> pageCache = <int, List<User>>{};

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
      Map<String, dynamic> result = await homeService.getCategories(
        page: currentPage.value,
        pageSize: pageSize.value,
      );

      List<User> users = result['users'];
      PaginationInfo pagination = result['pagination'];

      // Mettre à jour les informations de pagination
      totalItems.value = pagination.total;
      totalPages.value = pagination.numOfPages;

      // Stocker les données dans le cache
      pageCache[currentPage.value] = users;
      
      // Afficher les données de la page actuelle
      categoryList.value = users;

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

  void exportToExcelWeb() {
    // Créer une nouvelle feuille Excel
    var excel = Excel.createExcel();

    // Ajouter des données à la feuille
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow(
      [
        TextCellValue("ID"),
        TextCellValue("Prenom"),
        TextCellValue("Nom"),
        TextCellValue("Pays"),
        TextCellValue("Telephone"),
        TextCellValue("Date incription"),
      ],
    );

    for (var i = 0; i < categoryList.length; i++) {
      sheet.appendRow(
        [
          IntCellValue(i),
          TextCellValue(categoryList[i].firstname!),
          TextCellValue(categoryList[i].lastname!),
          TextCellValue("${categoryList[i].country!['name']}"),
          TextCellValue("(${categoryList[i].country!['countryCode']}) ${categoryList[i].phonenumber!}"),
          TextCellValue(categoryList[i].createdAt!.split("T").first),
        ],
      );
    }

    // Encoder les données au format Excel
    var fileBytes = excel.encode();

    // Créer un fichier pour le téléchargement
    final blob = Blob([fileBytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = Url.createObjectUrlFromBlob(blob);

    // Télécharger le fichier
    AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'users.xlsx'
      ..click();

    Url.revokeObjectUrl(url);
  }
}
