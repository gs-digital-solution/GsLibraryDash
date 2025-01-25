import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/features/categories/services/categoryService.dart';
import 'package:gslibrarydashboard/features/history/models/history.dart';
import 'package:gslibrarydashboard/features/history/services/history_service.dart';
import 'package:image_picker/image_picker.dart';

class HistoryController extends GetxController with StateMixin<List<History>> {

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData(userId: userId);
  }

  
  RxList<History> categoryList = <History>[].obs;
  String?userId;
  final HistoryService homeService = Get.put(HistoryService());

  HistoryController({this.userId});
  

  Future<void> fetchCategoryData({String? userId}) async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await homeService.getCategories(userId: userId);

      if (categoryList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(categoryList, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  Future<void> deleteCategory({History? model}) async {
    try {
      await homeService.deleteCategory(
        model: model,
      );
      int index =
          categoryList.indexWhere((element) => element.sId == model!.sId);
      categoryList.removeAt(index);
        change(categoryList, status: RxStatus.success());
      Fluttertoast.showToast(
          msg: "categorie Supprime", backgroundColor: Colors.green);
    } on AppException catch (e) {
    } finally {}
  }
}
