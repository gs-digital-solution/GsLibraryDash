import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/features/categories/services/categoryService.dart';
import 'package:image_picker/image_picker.dart';


class CategoryController extends GetxController
    with StateMixin<List<CategoryModel>> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  Uint8List webImage = Uint8List(10);

  RxBool isImageOffline = false.obs;

  CategoryModel? categoryModel;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  final CategoryService homeService = Get.put(CategoryService());

  String oldCategory = '';

  CategoryController({this.categoryModel});

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  setAllCategoryDate(CategoryModel? category) {
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
    nameController = TextEditingController();
    imageController = TextEditingController();
    webImage = Uint8List(10);

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

      imageController.text = pickImage!.name;
      var f = await pickImage!.readAsBytes();
      isImageOffline(false);
      webImage = f;
      isImageOffline(true);
    }
  }
}
