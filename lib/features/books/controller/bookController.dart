import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/books/services/bookService.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class BookController extends GetxController with StateMixin<List<Book>> {
  TextEditingController nameController = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController pourcentage = TextEditingController();

  TextEditingController imageController = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController authController = TextEditingController();
  TextEditingController pdfController = TextEditingController();
  TextEditingController pdfControllerPayante = TextEditingController();

  TextEditingController pourcentageReduction= TextEditingController(text: "0");

  final HomeController homeController = Get.find();

  QuillController descController = QuillController.basic();

  Uint8List webImage = Uint8List(0);
  Uint8List gratuite = Uint8List(0);
  List<int> payante = Uint8List(0);

  RxBool isImageOffline = false.obs;
  RxBool isImageOfflinePayante = false.obs;

  List<String> pdfOptionList = [Constants.file];
  //Constants.url,

  RxString pdf = Constants.file.obs;
  RxString pdfPayante = Constants.file.obs;

  RxString pdfUrl = ''.obs;
  RxString pdfUrlPayante = ''.obs;
  RxString pdfSize = ''.obs;
  RxString pdfSizePayante = ''.obs;

  CategoryModel? categoryModel;
  TopAuthors? topAuthors;
  RxBool isLoading = false.obs;
  RxBool isPopular = true.obs;
  RxBool isFeatured = true.obs;
  RxList<Book> categoryList = <Book>[].obs;
  Book? mybook;
  final BookService homeService = Get.put(BookService());

  String oldCategory = '';

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
    mybook = null;
    nameController.clear();
    price.clear();
    pourcentage.clear();
    categoryModel = null;
    topAuthors = null;
    imageController.clear();
    webImage = Uint8List(0);
    payante = Uint8List(0);
    gratuite = Uint8List(0);
    pdfController.clear();
    pdfControllerPayante.clear();
    descController = QuillController.basic();
    pdfUrl = ''.obs;
    pdfUrlPayante = ''.obs;
    isImageOffline.value = false;
    isLoading = false.obs;
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
  FilePickerResult? result;

  openFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      String fileName = result!.files.first.name;

      gratuite = result!.files.first.bytes!;

      String size =
          getFileSizeString(bytes: result!.files.first.size, decimals: 1);

      pdfUrl.value = fileName;

      pdfSize.value = size;

      print("Size-------_${size}");
    } else {
      pdfUrl.value = '';
    }
  }

  openFilePayante() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      String fileName = result!.files.first.name;

      payante = result!.files.first.bytes!;

      String size =
          getFileSizeString(bytes: result!.files.first.size, decimals: 1);

      pdfUrlPayante.value = fileName;

      pdfSizePayante.value = size;

      print("Size-------_${size}");
    } else {
      pdfUrlPayante.value = '';
    }
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

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

  Future<void> addBook() async {
    isLoading.value = true;

    String descript = deltaToHtml(descController.document
            .toDelta()
            .toJson());
    
    try {
      Book book = await homeService.addAuthor(
        avatar: webImage,
        filename: imageController.text,
        gratuite: gratuite,
        gratuiteFilename: pdfUrl.value,
        payante: payante,
        payanteFilename: pdfUrlPayante.value,
        nom: nameController.text,
        prix: price.text,
        pourcentage: pourcentage.text,
        description: descript, //descController.document.toPlainText(),
        topAuthors: topAuthors,
        categoryModel: categoryModel!,
        popular: isPopular.value,
        featured: isFeatured.value,
      );

      categoryList.add(book);
      Fluttertoast.showToast(
          msg: "Livre ajoute avec success", backgroundColor: Colors.green);
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updateBook() async {
    isLoading.value = true;
     String descript = deltaToHtml(descController.document
            .toDelta()
            .toJson());
    try {
      Book book = await homeService.updateBook(
        avatar: webImage,
        filename: imageController.text,
        gratuite: gratuite,
        gratuiteFilename: pdfUrl.value,
        payante: payante,
        payanteFilename: pdfUrlPayante.value,
        nom: nameController.text,
        prix: price.text,
        pourcentage: pourcentage.text,
        description: descript, // descController.document.toPlainText(),
        topAuthors: topAuthors,
        categoryModel: categoryModel!,
        book: mybook,
        popular: isPopular.value,
        featured: isFeatured.value,
      );

      //categoryList.add(book);
      Fluttertoast.showToast(
        msg: "Livre mis a jour avec success",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updateBookStatus({Book? book}) async {
    isLoading.value = true;
    try {
      await homeService.updateBookStatus(
        book: book,
        status: book!.status!.value,
      );

      //categoryList.add(book);
      Fluttertoast.showToast(
        msg: "Status mis a jour",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }


    Future<void> updateBookPromotion({Book? book,}) async {
    isLoading.value = true;
    try {
      await homeService.updateBookPromotion(
        book: book,
        hasPromo: book!.hasPromo!.value,
        pourcentageReduction: int.parse(pourcentageReduction.text),
      );

      //categoryList.add(book);
      Fluttertoast.showToast(
        msg: "Promotion mise a jour",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
      clearData();
    } on AppException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  void setBook(Book book) {
    nameController.text = book.nom!;
    price.text = book.prix.toString();

    pourcentage.text = book.pourcentage.toString();
    categoryModel = book.categories!.isNotEmpty ? book.categories![0] : null;
    topAuthors = book.author;

    if (book.description != null && book.description!.isNotEmpty) {
      final doc = Document()..insert(0, decode(book.description ?? ""));

      descController = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));
    }
    homeController.selectedItem!.value = AdminMenuItem(
      title: 'ajouter un livre',
      icon: Icons.add,
      route: '/books/add',
    );
    isFeatured.value = book.featured!.value;
    isPopular.value = book.popular!.value;
    mybook = book;
  }

  Future<void> deleteCategory({Book? model}) async {
    try {
      print(webImage);
      await homeService.deleteBook(
        model: model,
      );
      int index =
          categoryList.indexWhere((element) => element.sId == model!.sId);
      categoryList.removeAt(index);

      Fluttertoast.showToast(
          msg: "Livre Supprime", backgroundColor: Colors.green);
      isLoading.value = false;
    } on AppException catch (e) {
      isLoading.value = false;
    }
  }
}
