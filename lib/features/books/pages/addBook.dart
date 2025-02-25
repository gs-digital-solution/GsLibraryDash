import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/author/controllers/authorController.dart';
import 'package:gslibrarydashboard/features/books/controller/bookController.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/books/pages/category_dropdown.dart';
import 'package:gslibrarydashboard/features/books/pages/subwidget/status_drop_down.dart';
import 'package:gslibrarydashboard/features/categories/controller/categoryController.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/controllers/exchange_rate_controller.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';

class AddStoryScreen extends StatefulWidget {
  final Book? storyModel;

  AddStoryScreen({this.storyModel});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  @override
  void initState() {
    super.initState();

    //LoginData.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.put(BookController());
    final ExchangeRateController exchangeRateController =
        Get.put(ExchangeRateController());
    final CategoryController categoryController = Get.put(CategoryController());
    final AuthorController authorController = Get.put(AuthorController());

    bool isEdit = bookController.mybook != null;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    context,
                    isEdit ? 'Mettre a jour le livre' : 'Ajouter un livre',
                    75,
                    getFontColor(context),
                    fontWeight: FontWeight.w700),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      bookController.clearData();
                    });
                  },
                  child: Text(
                    'Supprimer le formulaire',
                    style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            getVerticalSpace(context, 35),
            Expanded(
              child: getCommonContainer(
                context: context,
                verSpace: 0,
                horSpace: isWeb(context) ? null : 15.h,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: [
                          getVerticalSpace(context, 30),
                          Responsive.isMobile(context)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    itemSubTitle('Book Title', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Enter title..",
                                        bookController.nameController),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Select Category', context),
                                    getVerticalSpace(context, 10),
                                    Obx(() {
                                      return categoryController
                                              .category.value.isNotEmpty
                                          ? categoryController
                                                      .categoryList.length ==
                                                  1
                                              ? getDisableDropDownWidget(
                                                  context,
                                                  categoryController
                                                      .categoryList[0].name!,
                                                )
                                              : CategoryDropDown(
                                                  categoryController,
                                                  value: categoryController
                                                      .category.value,
                                                  onChanged: (value) {
                                                    if (value !=
                                                        categoryController
                                                            .category.value) {
                                                      categoryController
                                                          .category(value);
                                                    }
                                                  },
                                                )
                                          : getDisableTextFiledWidget(
                                              context,
                                              categoryController.isLoading.value
                                                  ? "Loading.."
                                                  : "No Data",
                                            );
                                    }),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Select Author', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Author",
                                        bookController.authController,
                                        isEnabled: false,
                                        child: InkWell(
                                          onTap: () {
                                            if (authorController
                                                    .authorList.isNotEmpty &&
                                                authorController
                                                        .authorList.length >
                                                    0) {
                                              authorController.showAuthorDialog(
                                                context,
                                              );
                                            } else {
                                              showCustomToast(
                                                  context: context,
                                                  message: "No Data");
                                            }
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 8.h),
                                            // margin: EdgeInsets.all(7.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.h,
                                                vertical: 5.h),
                                            decoration: getDefaultDecoration(
                                                bgColor:
                                                    getReportColor(context),
                                                borderColor: borderColor,
                                                radius: getResizeRadius(
                                                    context, 10)),
                                            child: getTextWidget(
                                              context,
                                              'Select Author',
                                              40,
                                              getSubFontColor(context),
                                              customFont: "",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Type', context),
                                    getVerticalSpace(context, 10),
                                    Obx(() {
                                      return PDFDropDown(
                                        bookController,
                                        value: bookController.pdf.value,
                                        onChanged: (value) {
                                          if (value !=
                                              bookController.pdf.value) {
                                            bookController.pdf(value);
                                          }
                                        },
                                      );
                                    }),
                                    getVerticalSpace(context, 30),
                                    Obx(() {
                                      return (bookController.pdf.value ==
                                              Constants.url)
                                          ? itemSubTitle('URL', context)
                                          : itemSubTitle('Upload PDF', context);
                                    }),
                                    getVerticalSpace(context, 10),
                                    Obx(
                                      () => (bookController.pdf.value ==
                                              Constants.url)
                                          ? getTextFiledWidget(
                                              context,
                                              "Enter url..",
                                              bookController.pdfController)
                                          : Obx(() => getTextFiledWidget(
                                              context,
                                              "No file chosen",
                                              TextEditingController(
                                                  text: bookController
                                                      .pdfUrl.value),
                                              isEnabled: false,
                                              child: getCommonChooseFileBtn(
                                                  context, () {
                                                bookController.openFile();
                                              }))),
                                    ),

                                    Obx(() {
                                      return (bookController
                                              .pdfUrl.value.isNotEmpty)
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(top: 35.h),
                                              padding: EdgeInsets.all(22.h),
                                              width: double.infinity,
                                              decoration: getDefaultDecoration(
                                                bgColor:
                                                    getReportColor(context),
                                                radius: getResizeRadius(
                                                    context, 25),
                                              ),
                                              child: Row(
                                                children: [
                                                  imageAsset("pdf.png",
                                                      height: 44.h,
                                                      width: 32.h),
                                                  getHorizontalSpace(
                                                      context, 20),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Obx(() => getTextWidget(
                                                            context,
                                                            bookController
                                                                .pdfUrl.value,
                                                            50,
                                                            getFontColor(
                                                                context))),
                                                        getVerticalSpace(
                                                            context, 10),
                                                        getTextWidget(
                                                            context,
                                                            bookController
                                                                .pdfSize.value,
                                                            40,
                                                            getFontColor(
                                                                context))
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        bookController
                                                            .pdfUrl.value = "";
                                                      },
                                                      child: imageAsset(
                                                          "trash.png",
                                                          height: 24.h,
                                                          width: 24.h))
                                                ],
                                              ),
                                            )
                                          : Container();
                                    }),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Book Image', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "No file chosen",
                                        bookController.imageController,
                                        isEnabled: false,
                                        child:
                                            getCommonChooseFileBtn(context, () {
                                          bookController.imgFromGallery();
                                        })),
                                    getVerticalSpace(context, 30),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Obx(() {
                                        return (bookController
                                                .isImageOffline.value)
                                            ? ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular((getResizeRadius(
                                                        context,
                                                        35))), //add border radius
                                                child: (bookController.isSvg)
                                                    ? Image.asset(
                                                        Constants.placeImage,
                                                        height: 100.h,
                                                        width: 100.h,
                                                        fit: BoxFit.contain,
                                                      )
                                                    : Image.memory(
                                                        bookController.webImage,
                                                        height: 100.h,
                                                        width: 100.h,
                                                        fit: BoxFit.contain,
                                                      ),
                                              )
                                            : isEdit
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular((getResizeRadius(
                                                            context,
                                                            35))), //add border radius
                                                    child: (widget.storyModel!
                                                            .avatar!.url!
                                                            .split(".")
                                                            .last
                                                            .startsWith("svg"))
                                                        ? Image.asset(
                                                            Constants
                                                                .placeImage,
                                                            height: 150.h,
                                                            width: 200.h,
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Image.network(
                                                            widget.storyModel!
                                                                .avatar!.url!,
                                                            height: 150.h,
                                                            width: 200.h,
                                                            fit: BoxFit.contain,
                                                          ),
                                                  )
                                                : Container();
                                      }),
                                    ),
                                    // getVerticalSpace(context, 30),
                                    itemSubTitle('Description', context),
                                    getVerticalSpace(context, 10),

                                    Container(
                                      // margin: EdgeInsets.all(value),
                                      decoration: getDefaultDecoration(
                                          radius: getDefaultRadius(context),
                                          bgColor: getCardColor(context),
                                          // bgColor: getReportColor(context),
                                          borderColor: getBorderColor(context),
                                          borderWidth: 1),
                                      child: Column(
                                        children: [
                                          getVerticalSpace(context, 10),
                                          /*    Container(
                                      margin: EdgeInsets.all(8.h),
                                      decoration: getDefaultDecoration(
                                          radius: getDefaultRadius(context),
                                          bgColor: getCardColor(context),
                                          borderColor: getBorderColor(context),
                                          borderWidth: 1),
                                      child: QuillToolbar.basic(
                                          iconTheme: QuillIconTheme(
                                              iconUnselectedFillColor: Colors.transparent
                                          ),
                                          controller: storyController.descController),
                                    ), */
                                          /*  Container(
                                      child: QuillEditor.basic(
                                        controller: storyController.descController,

                                        readOnly: false, // true for view only mode
                                      ).paddingSymmetric(
                                          vertical: 15.h, horizontal: 15),
                                    ).marginSymmetric(vertical: 15.h), */
                                        ],
                                      ),
                                    ),

                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Is Popular?', context),
                                    getVerticalSpace(context, 10),
                                    Container(
                                      height: 30.h,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Obx(() => CupertinoSwitch(
                                            activeColor:
                                                getPrimaryColor(context),
                                            value:
                                                bookController.isPopular.value,
                                            onChanged: (value) {
                                              bookController.isPopular.value =
                                                  value;
                                            })),
                                      ),
                                    ),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Is Featured?', context),
                                    getVerticalSpace(context, 10),
                                    Container(
                                      height: 30.h,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Obx(() => CupertinoSwitch(
                                            activeColor:
                                                getPrimaryColor(context),
                                            value:
                                                bookController.isFeatured.value,
                                            onChanged: (value) {
                                              bookController.isFeatured.value =
                                                  value;
                                            })),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Book Title', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "Enter title..",
                                                bookController.nameController),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 5),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle(
                                                'Select Category', context),
                                            getVerticalSpace(context, 10),
                                            DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                  left: 10.h,
                                                ),
                                                border: InputBorder.none,

                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              getPrimaryColor(
                                                                  context),
                                                        )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        borderSide: BorderSide(
                                                          color: borderColor,
                                                        )),
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        borderSide: BorderSide(
                                                          color: borderColor,
                                                        )),

                                                filled: true,
                                                fillColor:
                                                    getCardColor(context),
                                                // fillColor: getReportColor(context),
                                                focusColor: Colors.green,
                                                hintText:
                                                    "Choix de la categorie",
                                                isDense: false,
                                                hintStyle: TextStyle(
                                                    fontFamily:
                                                        Constants.fontsFamily,
                                                    color: getSubFontColor(
                                                        context),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15),
                                              ),
                                              items: isEdit &&
                                                      bookController
                                                              .categoryModel !=
                                                          null
                                                  ? [
                                                      DropdownMenuItem(
                                                        child: Text(
                                                            bookController
                                                                .categoryModel!
                                                                .name!),
                                                        value: bookController
                                                            .categoryModel,
                                                      ),
                                                      ...categoryController
                                                          .categoryList
                                                          .where((category) =>
                                                              category.sId !=
                                                              bookController
                                                                  .categoryModel!
                                                                  .sId)
                                                          .map(
                                                            (element) =>
                                                                DropdownMenuItem(
                                                              value: element,
                                                              child: Text(
                                                                  element
                                                                      .name!),
                                                            ),
                                                          )
                                                          .toList()
                                                    ]
                                                  : categoryController
                                                      .categoryList
                                                      .map(
                                                        (element) =>
                                                            DropdownMenuItem(
                                                          value: element,
                                                          child: Text(
                                                              element.name!),
                                                        ),
                                                      )
                                                      .toList(),
                                              onChanged: (value) {
                                                bookController.categoryModel =
                                                    value;
                                              },
                                              value:
                                                  bookController.categoryModel,
                                            ),
/*                                             Obx(() {
                                              return categoryController
                                                      .category.value.isNotEmpty
                                                  ? categoryController
                                                              .categoryList
                                                              .length ==
                                                          1
                                                      ? getDisableDropDownWidget(
                                                          context,
                                                          categoryController
                                                              .categoryList[0]
                                                              .name!,
                                                        )
                                                      : CategoryDropDown(
                                                          categoryController,
                                                          value:
                                                              categoryController
                                                                  .category
                                                                  .value,
                                                          onChanged: (value) {
                                                            if (value !=
                                                                categoryController
                                                                    .category
                                                                    .value) {
                                                              categoryController
                                                                  .category(
                                                                      value);
                                                            }
                                                          },
                                                        )
                                                  : getDisableTextFiledWidget(
                                                      context,
                                                      categoryController
                                                              .isLoading.value
                                                          ? "Loading.."
                                                          : "No Data",
                                                    );
                                            }) */
                                          ],
                                        )),
                                        getHorizontalSpace(context, 5),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle(
                                                'Select Author', context),
                                            getVerticalSpace(context, 10),
                                            DropdownButtonFormField(
                                              value: bookController.topAuthors,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                  left: 10.h,
                                                ),
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              getPrimaryColor(
                                                                  context),
                                                        )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        borderSide: BorderSide(
                                                          color: borderColor,
                                                        )),
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        borderSide: BorderSide(
                                                          color: borderColor,
                                                        )),

                                                filled: true,
                                                fillColor:
                                                    getCardColor(context),
                                                // fillColor: getReportColor(context),
                                                focusColor: Colors.green,
                                                hintText:
                                                    "Choix de la categorie",
                                                isDense: false,
                                                hintStyle: TextStyle(
                                                    fontFamily:
                                                        Constants.fontsFamily,
                                                    color: getSubFontColor(
                                                        context),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15),
                                              ),
                                              items: isEdit
                                                  ? [
                                                      DropdownMenuItem(
                                                        child: Text(
                                                            bookController
                                                                .topAuthors!
                                                                .firstname!),
                                                        value: bookController
                                                            .topAuthors!,
                                                      ),
                                                      ...authorController
                                                          .authorList
                                                          .where(
                                                            (element) =>
                                                                element.sId !=
                                                                bookController
                                                                    .topAuthors!
                                                                    .sId,
                                                          )
                                                          .map(
                                                            (element) =>
                                                                DropdownMenuItem(
                                                              value: element,
                                                              child: Text(element
                                                                      .firstname ??
                                                                  ""),
                                                            ),
                                                          )
                                                          .toList()
                                                    ]
                                                  : authorController.authorList
                                                      .map(
                                                        (element) =>
                                                            DropdownMenuItem(
                                                          value: element,
                                                          child: Text(element
                                                                  .firstname ??
                                                              ""),
                                                        ),
                                                      )
                                                      .toList(),
                                              onChanged: (value) {
                                                bookController.topAuthors =
                                                    value;
                                              },
                                            ),
                                            /* getTextFiledWidget(
                                              context,
                                              "Author",
                                              bookController.authController,
                                              isEnabled: false,
                                              child: InkWell(
                                                onTap: () {
                                                  if (authorController
                                                          .authorList
                                                          .isNotEmpty &&
                                                      authorController
                                                              .authorList
                                                              .length >
                                                          0) {
                                                    authorController
                                                        .showAuthorDialog(
                                                      context,
                                                    );
                                                  } else {
                                                    showCustomToast(
                                                        context: context,
                                                        message: "No Data");
                                                  }
                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      left: 8.h),
                                                  // margin: EdgeInsets.all(7.h),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.h,
                                                      vertical: 5.h),
                                                  decoration:
                                                      getDefaultDecoration(
                                                          bgColor:
                                                              getReportColor(
                                                                  context),
                                                          borderColor:
                                                              borderColor,
                                                          radius:
                                                              getResizeRadius(
                                                                  context, 10)),
                                                  child: getTextWidget(
                                                    context,
                                                    'Select Author',
                                                    40,
                                                    getSubFontColor(context),
                                                    customFont: "",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ), */
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle(
                                                'Prix du Livre', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "Prix",
                                                bookController.price),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Monnaie', context),
                                              getVerticalSpace(context, 10),
                                              DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    left: 10.h,
                                                  ),
                                                  border: InputBorder.none,

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                            color:
                                                                getPrimaryColor(
                                                                    context),
                                                          )),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                            color: borderColor,
                                                          )),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                            color: borderColor,
                                                          )),

                                                  filled: true,
                                                  fillColor:
                                                      getCardColor(context),
                                                  // fillColor: getReportColor(context),
                                                  focusColor: Colors.green,
                                                  hintText: "Choix de monnaie",
                                                  isDense: false,
                                                  hintStyle: TextStyle(
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      color: getSubFontColor(
                                                          context),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15),
                                                ),
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text(bookController
                                                        .currency),
                                                    value:
                                                        bookController.currency,
                                                  ),
                                                  ...exchangeRateController
                                                      .exchangeRates
                                                      .map((element) =>
                                                          element.countryFrom)
                                                      .toList()
                                                      .toSet()
                                                      .toList()
                                                      .where((category) =>
                                                          category !=
                                                          bookController
                                                              .currency)
                                                      .map(
                                                        (element) =>
                                                            DropdownMenuItem(
                                                          value: element,
                                                          child: Text(
                                                            element!,
                                                          ),
                                                        ),
                                                      )
                                                      .toList()
                                                ],
                                                onChanged: (value) {
                                                  bookController.currency =
                                                      value!;
                                                },
                                                value: bookController.currency,
                                              ),
                                            ],
                                          ),
                                        ),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Pourcentage de vente',
                                                context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                              context,
                                              "pourcentage",
                                              bookController.pourcentage,
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle(
                                                'Version Gratuite', context),
                                            getVerticalSpace(context, 10),
                                            Obx(() {
                                              return PDFDropDown(
                                                bookController,
                                                value: bookController.pdf.value,
                                                onChanged: (value) {
                                                  if (value !=
                                                      bookController
                                                          .pdf.value) {
                                                    bookController.pdf(value);
                                                  }
                                                },
                                              );
                                            }),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return (bookController
                                                          .pdf.value ==
                                                      Constants.url)
                                                  ? itemSubTitle('URL', context)
                                                  : itemSubTitle(
                                                      'Upload PDF', context);
                                            }),
                                            getVerticalSpace(context, 10),
                                            Obx(
                                              () => (bookController.pdf.value ==
                                                      Constants.url)
                                                  ? getTextFiledWidget(
                                                      context,
                                                      "Enter url..",
                                                      bookController
                                                          .pdfController)
                                                  : Obx(() => getTextFiledWidget(
                                                      context,
                                                      "No file chosen",
                                                      TextEditingController(
                                                          text: bookController
                                                              .pdfUrl.value),
                                                      isEnabled: false,
                                                      child:
                                                          getCommonChooseFileBtn(
                                                              context, () {
                                                        bookController
                                                            .openFile();
                                                      }))),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    Obx(() {
                                      return (bookController
                                              .pdfUrl.value.isNotEmpty)
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(top: 35.h),
                                              padding: EdgeInsets.all(22.h),
                                              width: double.infinity,
                                              decoration: getDefaultDecoration(
                                                bgColor:
                                                    getReportColor(context),
                                                radius: getResizeRadius(
                                                    context, 25),
                                              ),
                                              child: Row(
                                                children: [
                                                  imageAsset("pdf.png",
                                                      height: 44.h,
                                                      width: 32.h),
                                                  getHorizontalSpace(
                                                      context, 20),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Obx(() => getTextWidget(
                                                            context,
                                                            bookController
                                                                .pdfUrl.value,
                                                            50,
                                                            getFontColor(
                                                                context))),
                                                        getVerticalSpace(
                                                            context, 10),
                                                        getTextWidget(
                                                            context,
                                                            bookController
                                                                .pdfSize.value,
                                                            40,
                                                            getFontColor(
                                                                context))
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        bookController
                                                            .pdfUrl.value = "";
                                                      },
                                                      child: imageAsset(
                                                          "trash.png",
                                                          height: 24.h,
                                                          width: 24.h))
                                                ],
                                              ),
                                            )
                                          : Container();
                                    }),
                                    getVerticalSpace(context, 30),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle(
                                                'Version Payante', context),
                                            getVerticalSpace(context, 10),
                                            Obx(() {
                                              return PDFDropDown(
                                                bookController,
                                                value: bookController
                                                    .pdfPayante.value,
                                                onChanged: (value) {
                                                  if (value !=
                                                      bookController
                                                          .pdfPayante.value) {
                                                    bookController
                                                        .pdfPayante(value);
                                                  }
                                                },
                                              );
                                            }),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return (bookController
                                                          .pdfPayante.value ==
                                                      Constants.url)
                                                  ? itemSubTitle('URL', context)
                                                  : itemSubTitle(
                                                      'Upload PDF', context);
                                            }),
                                            getVerticalSpace(context, 10),
                                            Obx(
                                              () => (bookController.pdf.value ==
                                                      Constants.url)
                                                  ? getTextFiledWidget(
                                                      context,
                                                      "Enter url..",
                                                      bookController
                                                          .pdfControllerPayante)
                                                  : Obx(() => getTextFiledWidget(
                                                      context,
                                                      "No file chosen",
                                                      TextEditingController(
                                                          text: bookController
                                                              .pdfUrlPayante
                                                              .value),
                                                      isEnabled: false,
                                                      child:
                                                          getCommonChooseFileBtn(
                                                              context, () {
                                                        bookController
                                                            .openFilePayante();
                                                      }))),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    Obx(() {
                                      return (bookController
                                              .pdfUrlPayante.value.isNotEmpty)
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(top: 35.h),
                                              padding: EdgeInsets.all(22.h),
                                              width: double.infinity,
                                              decoration: getDefaultDecoration(
                                                bgColor:
                                                    getReportColor(context),
                                                radius: getResizeRadius(
                                                    context, 25),
                                              ),
                                              child: Row(
                                                children: [
                                                  imageAsset("pdf.png",
                                                      height: 44.h,
                                                      width: 32.h),
                                                  getHorizontalSpace(
                                                      context, 20),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Obx(() => getTextWidget(
                                                            context,
                                                            bookController
                                                                .pdfUrlPayante
                                                                .value,
                                                            50,
                                                            getFontColor(
                                                                context))),
                                                        getVerticalSpace(
                                                            context, 10),
                                                        getTextWidget(
                                                            context,
                                                            bookController
                                                                .pdfSizePayante
                                                                .value,
                                                            40,
                                                            getFontColor(
                                                                context))
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        bookController
                                                            .pdfUrlPayante
                                                            .value = "";
                                                      },
                                                      child: imageAsset(
                                                          "trash.png",
                                                          height: 24.h,
                                                          width: 24.h))
                                                ],
                                              ),
                                            )
                                          : Container();
                                    }),
                                    getVerticalSpace(context, 30),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Book Image', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "No file chosen",
                                                bookController.imageController,
                                                isEnabled: false,
                                                child: getCommonChooseFileBtn(
                                                    context, () {
                                                  bookController
                                                      .imgFromGallery();
                                                })),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              itemSubTitle("", context),
                                              getVerticalSpace(context, 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Obx(() {
                                                  return (bookController
                                                          .isImageOffline.value)
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  (getResizeRadius(
                                                                      context,
                                                                      35))), //add border radius
                                                          child: (bookController
                                                                  .isSvg)
                                                              ? Image.asset(
                                                                  Constants
                                                                      .placeImage,
                                                                  height: 100.h,
                                                                  width: 100.h,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                )
                                                              : Image.memory(
                                                                  bookController
                                                                      .webImage,
                                                                  height: 100.h,
                                                                  width: 100.h,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                        )
                                                      : bookController.mybook !=
                                                              null
                                                          ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(
                                                                  (getResizeRadius(
                                                                      context,
                                                                      35))), //add border radius
                                                              child:
                                                                  Image.network(
                                                                bookController
                                                                    .mybook!
                                                                    .avatar!
                                                                    .url!,
                                                                height: 100.h,
                                                                width: 100.h,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            )
                                                          : Container();
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Container())
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle(
                                                'Description', context),
                                            getVerticalSpace(context, 10),
                                            Container(
                                              decoration: getDefaultDecoration(
                                                  radius:
                                                      getDefaultRadius(context),
                                                  bgColor:
                                                      getCardColor(context),
                                                  // bgColor: getReportColor(context),
                                                  borderColor:
                                                      getBorderColor(context),
                                                  borderWidth: 1),
                                              child: Column(
                                                children: [
                                                  getVerticalSpace(context, 10),
                                                  QuillToolbar(
                                                    configurations:
                                                        const QuillToolbarConfigurations(
                                                      buttonOptions:
                                                          QuillSimpleToolbarButtonOptions(
                                                        base:
                                                            QuillToolbarBaseButtonOptions(
                                                          globalIconSize: 20,
                                                          globalIconButtonFactor:
                                                              1.4,
                                                        ),
                                                      ),
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              Icons
                                                                  .width_normal,
                                                            ),
                                                          ),
                                                          QuillToolbarHistoryButton(
                                                            isUndo: true,
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                          ),
                                                          QuillToolbarHistoryButton(
                                                            isUndo: false,
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            options:
                                                                const QuillToolbarToggleStyleButtonOptions(),
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute:
                                                                Attribute.bold,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            options:
                                                                const QuillToolbarToggleStyleButtonOptions(),
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute: Attribute
                                                                .italic,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute: Attribute
                                                                .underline,
                                                          ),
                                                          QuillToolbarClearFormatButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                          ),
                                                          const VerticalDivider(),
                                                          const VerticalDivider(),
                                                          QuillToolbarColorButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            isBackground: false,
                                                          ),
                                                          QuillToolbarColorButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            isBackground: true,
                                                          ),
                                                          const VerticalDivider(),
                                                          const VerticalDivider(),
                                                          QuillToolbarToggleCheckListButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute:
                                                                Attribute.ol,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute:
                                                                Attribute.ul,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute: Attribute
                                                                .inlineCode,
                                                          ),
                                                          QuillToolbarToggleStyleButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            attribute: Attribute
                                                                .blockQuote,
                                                          ),
                                                          QuillToolbarIndentButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            isIncrease: true,
                                                          ),
                                                          QuillToolbarIndentButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                            isIncrease: false,
                                                          ),
                                                          const VerticalDivider(),
                                                          QuillToolbarLinkStyleButton(
                                                            controller:
                                                                bookController
                                                                    .descController,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    width: Get.width,
                                                    child: QuillEditor(
                                                      scrollController:
                                                          ScrollController(),
                                                      configurations:
                                                          QuillEditorConfigurations(
                                                        controller:
                                                            bookController
                                                                .descController,
                                                        scrollable: true,
                                                        autoFocus: true,
                                                        expands: false,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        placeholder:
                                                            "Enter Description..",
                                                        customStyles:
                                                            DefaultStyles(),
                                                        readOnly: false,
                                                      ),
                                                      focusNode: FocusNode(),
                                                      // true for view only mode
                                                    ).paddingSymmetric(
                                                        vertical: 15.h,
                                                        horizontal: 15),
                                                  ).marginSymmetric(
                                                      vertical: 15.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Row(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              children: [
                                                itemSubTitle(
                                                    'Is Popular?', context),
                                                getVerticalSpace(context, 10),
                                                Container(
                                                  height: 30.h,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Obx(() =>
                                                        CupertinoSwitch(
                                                            activeColor:
                                                                getPrimaryColor(
                                                                    context),
                                                            value:
                                                                bookController
                                                                    .isPopular
                                                                    .value,
                                                            onChanged: (value) {
                                                              bookController
                                                                      .isPopular
                                                                      .value =
                                                                  value;
                                                            })),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Expanded(
                                                child: Column(
                                              children: [
                                                itemSubTitle(
                                                    'Is Featured?', context),
                                                getVerticalSpace(context, 10),
                                                Container(
                                                  height: 30.h,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Obx(() =>
                                                        CupertinoSwitch(
                                                            activeColor:
                                                                getPrimaryColor(
                                                                    context),
                                                            value:
                                                                bookController
                                                                    .isFeatured
                                                                    .value,
                                                            onChanged: (value) {
                                                              bookController
                                                                  .isFeatured
                                                                  .value = value;
                                                            })),
                                                  ),
                                                ),
                                              ],
                                            ))
                                          ],
                                        )),
                                      ],
                                    ),
                                  ],
                                ),

                          // Obx(() => controller.isLoading.value
                          //     ? getProgressWidget(context)
                          //     : Container())
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 20),
                    Row(
                      children: [
                        Obx(
                          () => Expanded(
                            child: getButtonWidget(
                              context,
                              isEdit ? 'Mettre a jour' : 'Enregistrer',
                              isProgress: bookController.isLoading.value,
                              () async {
                                if (isEdit) {
                                  Future.delayed(Duration(seconds: 2));
                                  await bookController.updateBook();
                                } else {
                                  Future.delayed(Duration(seconds: 2));
                                  await bookController.addBook();
                                  bookController.addBook().then((value) {
                                    setState(() {
                                      bookController.clearData();
                                    });
                                  });
                                }
                              },
                              horPadding: 25.h,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 60.h,
                            ),
                          ),
                        ),
                        getHorSpace(10.h),
                        Expanded(
                          child: getButtonWidget(
                            context,
                            'Annuler',
                            isProgress: false,
                            () {
                              bookController.isLoading.value = false;
                            },
                            horPadding: 25.h,
                            bgColor: Colors.red,
                            horizontalSpace: 0,
                            verticalSpace: 0,
                            btnHeight: 60.h,
                          ),
                        ),
                      ],
                    ),
                    getVerticalSpace(context, 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

itemSubTitle(String s, BuildContext context, {Color? color}) {
  return getTextWidget(
    context,
    s,
    45,
    color == null ? getFontColor(context) : color,
    fontWeight: FontWeight.w500,
  );
}
