import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/investors/models/investor.dart';
import 'package:gslibrarydashboard/features/investors/models/investorwithsolde.dart';
import 'package:gslibrarydashboard/features/investors/services/investor_service.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';
import 'package:image_picker/image_picker.dart';

class InvestorController extends GetxController
    with StateMixin<List<InvestorWithSolde>> {
  TextEditingController firstname = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController pourcentage = TextEditingController(text: "1");
  TextEditingController investDate = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first);
  TextEditingController investEndingDate = TextEditingController(text: '');

  TextEditingController phonenumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController password = TextEditingController();
  RxList<InvestorWithSolde> authorList = <InvestorWithSolde>[].obs;
  final InvestorService homeService = Get.put(InvestorService());
  InvestorWithSolde? authorModel;

  QuillController controller = QuillController.basic();

  final document = "text";

  QuillController descController = QuillController.basic();

  RxBool isLoading = false.obs;
  RxBool activeStatus = true.obs;
  RxString author = ''.obs;
  RxList selectedAuthors = [].obs;
  RxList selectedAuthorsNameList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAuthorsData();
  }

  bool isStatus = true;
  final HomeController homeController = Get.find();
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

  void setAuthor(InvestorWithSolde topAuthors) {
    print(topAuthors.solde);
    //final json = jsonDecode(topAuthors.description!);
    lastname.text = topAuthors.investor!.lastname!;
    firstname.text = topAuthors.investor!.firstname!;
    email.text = topAuthors.investor!.email!;
    phonenumber.text = topAuthors.investor!.phonenumber!;
    pourcentage.text = topAuthors.investor!.pourcentage!.toString();
    designation.text = topAuthors.investor!.designation ?? "";
    investDate.text = topAuthors.investor!.investDate!.split("T").first;

    homeController.selectedItem!.value = AdminMenuItem(
      title: 'ajouter un investisseur',
      icon: Icons.add,
      route: '/investors/add',
    );
    authorModel = topAuthors;
  }

  Future<void> addCategory() async {
    isLoading.value = true;
    print(controller.document.toDelta());
    try {
      Investor categoryModel = await homeService.addAuthor(
        avatar: webImage,
        filename: imageController.text,
        firstname: firstname.text,
        lastname: lastname.text,
        email: email.text,
        phonenumber: phonenumber.text,
        designation: designation.text,
        pourcentage: int.parse(pourcentage.text),
        investDate: investDate.text,
        investEndingDate: investEndingDate.text.isEmpty
            ? null
            : DateTime.parse(investEndingDate.text.split(' ').first),
        password: password.text,
        status: activeStatus.value,
      );
      print(categoryModel);
      // authorList.add(categoryModel);
      Fluttertoast.showToast(
          msg: "Investisseur ajoutee", backgroundColor: Colors.green);
      isLoading.value = false;
      clearAuthData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updateCategory({InvestorWithSolde? model}) async {
    isLoading.value = true;
    print(model);
    try {
       await homeService.updateAuthor(
        avatar: webImage,
        filename: imageController.text,
        firstname: firstname.text,
        lastname: lastname.text,
        email: email.text,
        investDate: DateTime.parse(investDate.text.split(" ").first),
        investEndingDate: investEndingDate.text.isEmpty
            ? null
            : DateTime.parse(investEndingDate.text.split(' ').first),
        phonenumber: phonenumber.text,
        designation: designation.text,
        pourcentage: int.parse(pourcentage.text),
        topAuthors: TopAuthors(
            sId: model!.investor!.sId!, status: model.investor!.status),
        password: password.text,
      );
/*       int index = authorList.indexWhere((element) => element.sId == model!.sId);
      authorList.removeAt(index);
      authorList.insert(index, categoryModel);
      Fluttertoast.showToast(
          msg: "Auteur mis a jour", backgroundColor: Colors.green); */
      isLoading.value = false;
      clearAuthData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory({InvestorWithSolde? model}) async {
    try {
      await homeService.deleteCategory(
        model: TopAuthors(sId: model!.investor!.sId),
      );
      int index = authorList.indexWhere(
          (element) => element.investor!.sId == model.investor!.sId);
      authorList.removeAt(index);

      Fluttertoast.showToast(
          msg: "categorie Supprimer", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (_) {
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

    controller = QuillController.basic();
    password.clear();
    email.clear();
    isLoading.value = false;
    activeStatus.value = true;
    webImage = Uint8List(10);
    authorModel = null;
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

  Uint8List webImage = Uint8List(0);

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

  Future<void> showAuthorDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: getTextWidget(
                context, 'Select Author', 60, getFontColor(context),
                fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: getBackgroundColor(context),
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.h),
              width:
                  Responsive.isDesktop(context) || Responsive.isDesktop(context)
                      ? 450.h
                      : 350.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: authorList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // title: getCustomFont("text", 18, getFontColor(context), 1),
                    title: getCustomFont(
                        authorList[index].investor!.firstname ?? "",
                        14,
                        getFontColor(context),
                        1),
                    trailing: Obx(
                      () => Checkbox(
                        activeColor: getPrimaryColor(context),
                        checkColor: Colors.white,
                        onChanged: (checked) {
                          if (selectedAuthors
                              .contains(authorList[index].investor!.sId!)) {
                            selectedAuthors
                                .remove(authorList[index].investor!.sId!);
                            selectedAuthorsNameList
                                .remove(authorList[index].investor!.lastname!);
                          } else {
                            selectedAuthors
                                .add(authorList[index].investor!.sId!);
                            selectedAuthorsNameList
                                .add(authorList[index].investor!.firstname!);
                          }
                        },
                        value: selectedAuthors
                            .contains(authorList[index].investor!.sId!),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              getButtonWidget(
                context,
                'Submit',
                isProgress: false,
                () {
                  Get.back();
                  firstname.text = selectedAuthorsNameList
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '');
                },
                horPadding: 25.h,
                horizontalSpace: 0,
                verticalSpace: 0,
                btnHeight: 40.h,
              )
            ],
          );
        });
  }
}
