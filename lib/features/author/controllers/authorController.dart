import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/author/services/authorService.dart';
import 'package:image_picker/image_picker.dart';

class AuthorController extends GetxController
    with StateMixin<List<TopAuthors>> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController youTubeController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  RxList<TopAuthors> authorList = <TopAuthors>[].obs;
  final AuthorService homeService = Get.put(AuthorService());

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

  clearAuthData() {
    nameController = TextEditingController();
    imageController = TextEditingController();
    designationController = TextEditingController();
    facebookController = TextEditingController();
    instagramController = TextEditingController();
    twitterController = TextEditingController();
    youTubeController = TextEditingController();
    websiteController = TextEditingController();
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
    nameController.text = "";
    designationController.text = "";
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
