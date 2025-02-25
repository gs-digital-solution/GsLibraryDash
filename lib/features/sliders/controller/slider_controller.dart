import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/sliders/models/slider.dart';
import 'package:gslibrarydashboard/features/sliders/services/slider_service.dart';
import 'package:image_picker/image_picker.dart';

class SliderController extends GetxController
    with StateMixin<List<SliderModel>> {

  TextEditingController imageController = TextEditingController();
  Uint8List webImage = Uint8List(10);

  RxBool isImageOffline = false.obs;

  SliderModel? categoryModel;
  RxBool isLoading = false.obs;
  RxList<SliderModel> categoryList = <SliderModel>[].obs;
  final SliderService homeService = Get.put(SliderService());

  String oldCategory = '';
  RxString category = 'text'.obs;
  RxString slider = ''.obs;
  RxString author = ''.obs;

  SliderController({this.categoryModel});

  List<int>? avatar;
  RxString? filename = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  setAllCategoryDate(SliderModel? category) {
    if (category != null) {
      categoryModel = category;
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
    imageController.clear();
    webImage = Uint8List(10);
    categoryModel=null;

    isImageOffline.value = false;
    categoryModel = null;
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

  XFile? pickImage;
  final picker = ImagePicker();
  bool isSvg = false;

  imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    pickImage = image;

    if (image != null) {
      String file = image.name.split(".").last;

      if (file == "svg") {
        isSvg = true;
      }
      print(pickImage!.name);

      imageController.text = pickImage!.name;
      var f = await pickImage!.readAsBytes();
      isImageOffline(false);
      webImage = f;
      isImageOffline(true);
    }
  }

  Future<void> addCategory() async {
    isLoading.value = true;
    try {
      SliderModel categoryModel = await homeService.addCategory(
        avatar: webImage,
        filename: imageController.text,
      );
      categoryList.add(categoryModel);
      Fluttertoast.showToast(
          msg: "categorie ajoutee", backgroundColor: Colors.green);
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updateCategory({SliderModel? model}) async {
    isLoading.value = true;
    try {
      print(webImage);
      SliderModel categoryModel = await homeService.updateCategory(
        avatar: webImage,
        filename: imageController.text,
        model: model,
      );
      int index =
          categoryList.indexWhere((element) => element.sId == model!.sId);
      categoryList.removeAt(index);
      categoryList.insert(index, categoryModel);
      Fluttertoast.showToast(
          msg: "categorie mise a jour", backgroundColor: Colors.green);
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory({SliderModel? model}) async {

    try {
      print(webImage);
      await homeService.deleteCategory(
        model: model,
      );
      int index =
          categoryList.indexWhere((element) => element.sId == model!.sId);
      categoryList.removeAt(index);

      Fluttertoast.showToast(
          msg: "categorie Supprime", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (_) {
      isLoading.value = false;
    }
  }
}
