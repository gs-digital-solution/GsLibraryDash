import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/author/services/authorService.dart';
import 'package:image_picker/image_picker.dart';

class AuthorController extends GetxController
    with StateMixin<List<TopAuthors>> {
  TextEditingController firstname = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController lastname = TextEditingController();

  TextEditingController phonenumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController password = TextEditingController();
  RxList<TopAuthors> authorList = <TopAuthors>[].obs;
  final AuthorService homeService = Get.put(AuthorService());
  TopAuthors? authorModel;

  QuillController controller = QuillController.basic();

  final document = "text";

  QuillController descController = QuillController.basic();

  RxBool isLoading = false.obs;
  RxBool activeStatus = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAuthorsData();
  }

  bool isStatus = true;

  Future<void> fetchAuthorsData() async {
    change(null, status: RxStatus.loading());

    try {
      authorList.value = await homeService.getAuthors();
      print(authorList.length);
      if (authorList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(authorList, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

    Future<void> addCategory() async {
    isLoading.value = true;
    try {
      TopAuthors categoryModel = await homeService.addAuthor(
        avatar: webImage,
        filename: imageController.text,
        firstname: firstname.text,
        lastname: lastname.text,
        email: email.text,
        phonenumber: phonenumber.text,
        designation: designation.text,
        description: controller.document.toPlainText(),
        password: password.text,
        status: activeStatus.value,
      );
      authorList.add(categoryModel);
      Fluttertoast.showToast(
          msg: "Auteur ajoutee", backgroundColor: Colors.green);
      isLoading.value = false;
      clearAuthData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updateCategory({TopAuthors? model}) async {
    isLoading.value = true;
    try {
     
      TopAuthors categoryModel = await homeService.updateAuthor(
        avatar: webImage,
        filename: imageController.text,
        firstname: firstname.text,
        lastname: lastname.text,
        email: email.text,
        phonenumber: phonenumber.text,
        designation: designation.text,
        description: controller.document.toPlainText(),
        password: password.text,
      );
      int index =
          authorList.indexWhere((element) => element.sId == model!.sId);
      authorList.removeAt(index);
      authorList.insert(index, categoryModel);
      Fluttertoast.showToast(
          msg: "categorie mise a jour", backgroundColor: Colors.green);
      isLoading.value = false;
      clearAuthData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }



  clearAuthData() {
    firstname.clear();
    lastname.clear();
    imageController.clear();
    description.clear();
    designation.clear();
    phonenumber.clear();
    email.clear();
    descController = QuillController.basic();
    isLoading.value = false;
    activeStatus.value = true;
  }

  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
      return '';
    }
  }

  removeAllField(BuildContext context) {
    imageController.text = "";
  }

  Uint8List webImage = Uint8List(10);

  RxBool isImageOffline = false.obs;

  XFile? pickImage;
  final picker = ImagePicker();
  FilePickerResult? result;
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
