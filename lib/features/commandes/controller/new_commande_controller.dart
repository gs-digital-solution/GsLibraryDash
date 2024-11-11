import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/books/services/bookService.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/commandes/services/commandeService.dart';

class NewCommandeController extends GetxController
    with StateMixin<List<User>> {
  RxList<User> categoryList = <User>[].obs;
  final CommandeService homeService = Get.put(CommandeService());
   final BookService bookService = Get.put(BookService());
  RxBool loadingPurchase = false.obs;
  User?searchUser;
  Book?searchBook;
  TextEditingController searchUserController = TextEditingController();
  TextEditingController searchBookController = TextEditingController();

  String oldCategory = '';

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await homeService.getUsers(page: 0, pageSize: 0);
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

  Future<List<Book>> getBooks() async{
    return await bookService.getCategories();
  }

  Future<bool> createCommande(
      {Book? book, User? user, BuildContext? context}) async {
   // double amount = book!.prix! - ((book.prix! * book.pourcentage!) / 100);
    
    Map<String, dynamic> paymentData = {
      "author": "${book!.author!.sId}",
      "book": "${book.sId}",
      "montant": book.prix,
      "user":user!.sId,
      "deviceId": user.deviceId,
      "pourcentage":book.pourcentage
    };
    loadingPurchase.value = true;

    try {
      await homeService.createCommande(
        paymentData: paymentData,
      );
      searchBookController.clear();
      searchUserController.clear();

      loadingPurchase.value = false;
         showCustomToast(message: 'Commande cree avec sucess', context: context!);
      return true;
    } on AppException catch (e) {
      loadingPurchase.value = false;
      showCustomToast(message: e.message!, context: context!);
      return false;
    }
  }
}
