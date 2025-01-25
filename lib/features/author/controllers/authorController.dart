import 'dart:html';
import 'dart:typed_data';
import 'package:excel/excel.dart';
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
import 'package:gslibrarydashboard/features/author/services/authorService.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';
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
  RxList<Commande> commandes = <Commande>[].obs;
  final AuthorService homeService = Get.put(AuthorService());
  TopAuthors? authorModel;
  RxBool loading = false.obs;

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

  void setAuthor(TopAuthors topAuthors) {
    print(topAuthors);
    //final json = jsonDecode(topAuthors.description!);
    lastname.text = topAuthors.lastname!;
    firstname.text = topAuthors.firstname!;
    email.text = topAuthors.email!;
    phonenumber.text = topAuthors.phonenumber!;
    designation.text = topAuthors.designation!;
    if (topAuthors.description != null && topAuthors.description!.isNotEmpty) {
      final doc = Document()..insert(0, decode(topAuthors.description ?? ""));

      controller = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));
    }
    homeController.selectedItem!.value = AdminMenuItem(
      title: 'Ajouter un auteurs',
      icon: Icons.add,
      route: '/authors/add',
    );
    authorModel = topAuthors;
  }

  Future<void> addCategory() async {
    isLoading.value = true;
    print(controller.document.toDelta());
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
      print(categoryModel);
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
    print(model);
    try {
      TopAuthors categoryModel = await homeService.updateAuthor(
        avatar: webImage,
        filename: imageController.text,
        firstname: firstname.text,
        lastname: lastname.text,
        email: email.text,
        phonenumber: phonenumber.text,
        designation: designation.text,
        description: deltaToHtml(controller.document.toDelta().toJson()),
        topAuthors: model,
        password: password.text,
      );
      int index = authorList.indexWhere((element) => element.sId == model!.sId);
      authorList.removeAt(index);
      authorList.insert(index, categoryModel);
      Fluttertoast.showToast(
          msg: "Auteur mis a jour", backgroundColor: Colors.green);
      isLoading.value = false;
      clearAuthData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory({TopAuthors? model}) async {
    try {
      await homeService.deleteCategory(
        model: model,
      );
      int index = authorList.indexWhere((element) => element.sId == model!.sId);
      authorList.removeAt(index);

      Fluttertoast.showToast(
          msg: "categorie Supprimer", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (e) {
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
                    title: getCustomFont(authorList[index].firstname ?? "", 14,
                        getFontColor(context), 1),
                    trailing: Obx(
                      () => Checkbox(
                        activeColor: getPrimaryColor(context),
                        checkColor: Colors.white,
                        onChanged: (checked) {
                          if (selectedAuthors
                              .contains(authorList[index].sId!)) {
                            selectedAuthors.remove(authorList[index].sId!);
                            selectedAuthorsNameList
                                .remove(authorList[index].lastname!);
                          } else {
                            selectedAuthors.add(authorList[index].sId!);
                            selectedAuthorsNameList
                                .add(authorList[index].firstname!);
                          }
                        },
                        value: selectedAuthors.contains(authorList[index].sId!),
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

  void exportToExcelWeb({List<Commande>? commandes,TopAuthors?topAuthors}) {
    // Créer une nouvelle feuille Excel
    var excel = Excel.createExcel();

    // Ajouter des données à la feuille
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow(
      [
        TextCellValue("ID"),
        TextCellValue("Prix en FCFA"),
        TextCellValue("Nom du Livre"),
        TextCellValue("Date de Vente"),
      ],
    );

    for (var i = 0; i < commandes!.length; i++) {
      sheet.appendRow(
        [
          IntCellValue(i),
          TextCellValue("${commandes[i].montant!}"),
          TextCellValue(commandes[i].book!.nom??""),
          TextCellValue(commandes[i].createdAt!.split("T").first),
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
    final anchor = AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'commandes-authorId.xlsx'
      ..click();

    Url.revokeObjectUrl(url);
  }

  Future<void> getCommandeAuthor(
      {String? authorId, String? startDate, String? endDate,TopAuthors?topAuthors}) async {
    loading.value = true;

    try {
      commandes.value = await homeService.getCommandesAuthor(
        authorId: authorId,
        startDate: startDate,
        endDate: endDate,
      );

      if (commandes.isEmpty) {
        loading.value = false;
        Fluttertoast.showToast(msg: "Aucunes Commandes realisees.");
      } else {
        exportToExcelWeb(commandes: commandes);
        loading.value = false;
      }
    } on AppException catch (e) {
      loading.value = false;
      Fluttertoast.showToast(msg: "Une erreur est survenue.");
    }
  }
}
