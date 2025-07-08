import 'dart:html';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/users/services/userservice.dart';

class UserController extends GetxController with StateMixin<List<User>> {
  RxList<User> categoryList = <User>[].obs;
  final UserService homeService = Get.put(UserService());

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value =
          await homeService.getCategories(page: 0, pageSize: 0);
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
