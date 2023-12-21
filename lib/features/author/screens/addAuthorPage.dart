import 'package:flutter/cupertino.dart';
// ignore: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/author/controllers/authorController.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';

class AddAuthorScreen extends StatefulWidget {
  final TopAuthors? authorModel;

  AddAuthorScreen({this.authorModel});

  @override
  State<AddAuthorScreen> createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  final AuthorController authorController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.authorModel != null;
    return SafeArea(
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: getDefaultHorSpace(context),
              vertical: getDefaultHorSpace(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTextWidget(context, isEdit ? 'Edit Author' : 'Add Author', 75,
                  getFontColor(context),
                  fontWeight: FontWeight.w700),
              getVerticalSpace(context, 35),
              Expanded(
                child: getCommonContainer(
                  context: context,
                  verSpace: 0,
                  horSpace: isWeb(context) ? null : 15.h,
                  // width: double.infinity,
                  // height: double.infinity,
                  // decoration: getDefaultDecoration(
                  //     bgColor: getCardColor(context), radius: radius),
                  // padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerticalSpace(context, 30),
                            getCommonBackIcon(
                              context,
                              onTap: () {},
                            ),

                            getVerticalSpace(context, 30),
                            Responsive.isMobile(context)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemSubTitle('Name', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(context, "Enter name",
                                          authorController.nameController),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Designation', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Enter designation",
                                          authorController
                                              .designationController),

                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Adresse', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Enter facebook url",
                                          authorController.facebookController),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle(
                                          'Instagram URL (optional)', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Enter instagram url",
                                          authorController.instagramController),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle(
                                          'Twitter URL (optional)', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Enter twitter url",
                                          authorController.twitterController),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle(
                                          'Youtube URL (optional)', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Enter youtube url",
                                          authorController.youTubeController),

                                      getVerticalSpace(context, 30),
                                      itemSubTitle(
                                          'Website URL (optional)', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Enter website url",
                                          authorController.twitterController),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Status', context),
                                      getVerticalSpace(context, 10),
                                      Container(
                                        height: 30.h,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Obx(() => CupertinoSwitch(
                                              activeColor:
                                                  getPrimaryColor(context),
                                              value: authorController
                                                  .activeStatus.value,
                                              onChanged: (value) {
                                                authorController
                                                    .activeStatus.value = value;
                                              })),
                                        ),
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Description', context),
                                      getVerticalSpace(context, 10),
                                      Container(
                                        decoration: getDefaultDecoration(
                                            radius: getDefaultRadius(context),
                                            bgColor: getCardColor(context),
                                            // bgColor: getReportColor(context),
                                            borderColor:
                                                getBorderColor(context),
                                            borderWidth: 1),
                                        child: Column(
                                          children: [
                                            getVerticalSpace(context, 10),
                                          ],
                                        ),
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Image', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(context, "Chosen file",
                                          authorController.imageController,
                                          isEnabled: false,
                                          child: getCommonChooseFileBtn(context,
                                              () {
                                            authorController.imgFromGallery();
                                          })),
                                      getVerticalSpace(context, 30),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Obx(() {
                                          return (authorController
                                                  .isImageOffline.value)
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular((getResizeRadius(
                                                          context,
                                                          35))), //add border radius
                                                  child: (authorController
                                                          .isSvg)
                                                      ? Image.asset(
                                                          Constants.placeImage,
                                                          height: 100.h,
                                                          width: 100.h,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : Image.memory(
                                                          authorController
                                                              .webImage,
                                                          height: 100.h,
                                                          width: 100.h,
                                                          fit: BoxFit.contain,
                                                        ),
                                                )
                                              : isEdit
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              (getResizeRadius(
                                                                  context,
                                                                  35))), //add border radius
                                                      child: Image.network(
                                                        widget.authorModel!
                                                            .avatar!.url!,
                                                        height: 150.h,
                                                        width: 200.h,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : Container();
                                        }),
                                      ),
                                      getVerticalSpace(context, 30),

                                      // getHorizontalSpace(context, 10),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Nom de l\'auteur', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Entrer le nom",
                                                  authorController
                                                      .nameController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Prenom de l\'auteur',
                                                  context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Entrer le prenom",
                                                  authorController
                                                      .designationController),
                                            ],
                                          )),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Adresse Mail de l\'auteur',
                                                  context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "adresse mail",
                                                  authorController
                                                      .facebookController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Telephone', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Numero de telephone",
                                                  authorController
                                                      .instagramController),
                                            ],
                                          )),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Designation de l\'auteur',
                                                  context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Designation",
                                                  authorController
                                                      .designationController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Status', context),
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
                                                              authorController
                                                                  .activeStatus
                                                                  .value,
                                                          onChanged: (value) {
                                                            authorController
                                                                .activeStatus
                                                                .value = value;
                                                          })),
                                                ),
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
                                                  'Description', context),
                                              getVerticalSpace(context, 10),
                                              Container(
                                                decoration:
                                                    getDefaultDecoration(
                                                        radius:
                                                            getDefaultRadius(
                                                                context),
                                                        bgColor: getCardColor(
                                                            context),
                                                        // bgColor: getReportColor(context),
                                                        borderColor:
                                                            getBorderColor(
                                                                context),
                                                        borderWidth: 1),
                                                child: Column(
                                                  children: [
                                                    getVerticalSpace(
                                                        context, 10),
                                                    QuillToolbar(
                                                      configurations:
                                                          const QuillToolbarConfigurations(
                                                        buttonOptions:
                                                            QuillSimpleToolbarButtonOptions(
                                                          base:
                                                              QuillToolbarBaseButtonOptions(
                                                            globalIconSize:
                                                                20,
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
                                                              onPressed:
                                                                  () {},
                                                              icon:
                                                                  const Icon(
                                                                Icons
                                                                    .width_normal,
                                                              ),
                                                            ),
                                                            QuillToolbarHistoryButton(
                                                              isUndo: true,
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                            ),
                                                            QuillToolbarHistoryButton(
                                                              isUndo: false,
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              options:
                                                                  const QuillToolbarToggleStyleButtonOptions(),
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute:
                                                                  Attribute
                                                                      .bold,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              options:
                                                                  const QuillToolbarToggleStyleButtonOptions(),
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute:
                                                                  Attribute
                                                                      .italic,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute:
                                                                  Attribute
                                                                      .underline,
                                                            ),
                                                            QuillToolbarClearFormatButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                            ),
                                                            const VerticalDivider(),
                                                            const VerticalDivider(),
                                                            QuillToolbarColorButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              isBackground:
                                                                  false,
                                                            ),
                                                            QuillToolbarColorButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              isBackground:
                                                                  true,
                                                            ),
                                                            const VerticalDivider(),
                                                            const VerticalDivider(),
                                                            QuillToolbarToggleCheckListButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute:
                                                                  Attribute
                                                                      .ol,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute:
                                                                  Attribute
                                                                      .ul,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute: Attribute
                                                                  .inlineCode,
                                                            ),
                                                            QuillToolbarToggleStyleButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              attribute: Attribute
                                                                  .blockQuote,
                                                            ),
                                                            QuillToolbarIndentButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              isIncrease:
                                                                  true,
                                                            ),
                                                            QuillToolbarIndentButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
                                                              isIncrease:
                                                                  false,
                                                            ),
                                                            const VerticalDivider(),
                                                            QuillToolbarLinkStyleButton(
                                                              controller:
                                                                  authorController
                                                                      .controller,
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
                                                              authorController
                                                                  .controller,
                                                          scrollable: true,
                                                          autoFocus: true,
                                                          expands: false,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          placeholder:
                                                              "Enter Description..",
                                                          customStyles: DefaultStyles(
                                                              // placeHolder: quillView.DefaultTextBlockStyle(
                                                              //     TextStyle(
                                                              //       color: getSubFontColor(context),
                                                              //     ),
                                                              //     const Tuple2(16, 0),
                                                              //     const Tuple2(0, 0),
                                                              //     null),
                                                              //
                                                              // paragraph: quillView.DefaultTextBlockStyle(
                                                              //     TextStyle(
                                                              //       color: textColor,
                                                              //     ),
                                                              //     const Tuple2(16, 0),
                                                              //     const Tuple2(0, 0),
                                                              //     null),
                                                              ),
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
                                          Expanded(child: Container()),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Image', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Chosen file",
                                                  authorController
                                                      .imageController,
                                                  isEnabled: false,
                                                  child: getCommonChooseFileBtn(
                                                      context, () {
                                                    authorController
                                                        .imgFromGallery();
                                                  })),
                                              getVerticalSpace(context, 35),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Obx(() {
                                                return (authorController
                                                        .isImageOffline.value)
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                (getResizeRadius(
                                                                    context,
                                                                    35))), //add border radius
                                                        child: (authorController
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
                                                                authorController
                                                                    .webImage,
                                                                height: 100.h,
                                                                width: 100.h,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                      )
                                                    : isEdit
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    (getResizeRadius(
                                                                        context,
                                                                        35))), //add border radius
                                                            child:
                                                                Image.network(
                                                              widget
                                                                  .authorModel!
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
                                          ),
                                          getHorizontalSpace(context, 10),
                                          Expanded(child: Container()),
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
                          Obx(() => getButtonWidget(
                                context,
                                isEdit ? 'Update' : 'Save',
                                isProgress: authorController.isLoading.value,
                                () {
                                  if (isEdit) {
                                  } else {}
                                },
                                horPadding: 25.h,
                                horizontalSpace: 0,
                                verticalSpace: 0,
                                btnHeight: 40.h,
                              )),
                        ],
                      ),
                      getVerticalSpace(context, 20),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();

    //LoginData.getDeviceId();
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
