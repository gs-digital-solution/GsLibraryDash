import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:gslibrarydashboard/features/dashboard/controllers/dashboardController.dart';
import 'package:gslibrarydashboard/features/retraits/controller/retraitController.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';

class NewRetrait extends StatefulWidget {
  NewRetrait();

  @override
  State<NewRetrait> createState() => _NewRetraitState();
}

class _NewRetraitState extends State<NewRetrait> {
  @override
  void initState() {
    super.initState();

    //LoginData.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    final AuthorController authorController = Get.put(AuthorController());
    final RetraitController retraitController = Get.put(RetraitController());
    final DashboardController dashboardController = Get.find();
    final formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           /*  FutureBuilder(
              future: dashboardController.getStatAdmin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return getProgressDialog(context);
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  double iconSize =
                      (MediaQuery.of(context).size.width < 1338) ? 25.h : 40.h;
                  double fontSize =
                      (MediaQuery.of(context).size.width < 1338) ? 15 : 17.sp;
                  double fontSize1 =
                      (MediaQuery.of(context).size.width < 1338) ? 35 : 40.h;
                  return Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 16),
                              blurRadius: 31,
                              color: Color(0XFFACBFC1).withOpacity(0.10))
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.h),
                        ),
                        color: getSubCardColor(context)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 96.h,
                          decoration: BoxDecoration(color: Color(0XFFD8F1E4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getSvgImage("dashboard_category_icon.svg",
                                  height: iconSize, width: iconSize),
                              getHorSpace(12.h),
                              getMultilineCustomFont(
                                "Restant a Payer",
                                fontSize,
                                Colors.black,
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 15.h),
                        ),
                        getHorSpace(12.h),
                        getCustomFont(
                          '${snapshot.data!.montant} XAF',
                          fontSize1,
                          Colors.orangeAccent,
                          1,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  );
                } else {
                  return getNoData(context);
                }
              },
            ), */
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
                              ? Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemSubTitle(
                                          'Selectionner un  auteur', context),
                                      getVerticalSpace(context, 10),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            left: 10.h,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: getPrimaryColor(context),
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: borderColor,
                                              )),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: borderColor,
                                              )),

                                          filled: true,
                                          fillColor: getCardColor(context),
                                          // fillColor: getReportColor(context),
                                          focusColor: Colors.green,
                                          hintText: "Selecetionner un auteur",
                                          isDense: false,
                                          hintStyle: TextStyle(
                                              fontFamily: Constants.fontsFamily,
                                              color: getSubFontColor(context),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        items: authorController.authorList
                                            .map(
                                              (element) => DropdownMenuItem(
                                                value: element,
                                                child: Text(
                                                    "${element.firstname ?? ""} ${element.firstname ?? ""} (${element.solde} FCFA)"),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          retraitController.topAuthors = value;
                                        },
                                        value: retraitController.topAuthors,
                                        validator: (value) => value != null
                                            ? null
                                            : "Vous devez selectionner un auteur",
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle(
                                          'Montant a retirer', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Entrer le montant",
                                          retraitController.amount),
                                    ],
                                  ),
                                )
                              : Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemSubTitle(
                                          'Selectionner un  auteur', context),
                                      getVerticalSpace(context, 10),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            left: 10.h,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: getPrimaryColor(context),
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: borderColor,
                                              )),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: borderColor,
                                              )),

                                          filled: true,
                                          fillColor: getCardColor(context),
                                          // fillColor: getReportColor(context),
                                          focusColor: Colors.green,
                                          hintText: "Selectionner un auteur",
                                          isDense: false,
                                          hintStyle: TextStyle(
                                              fontFamily: Constants.fontsFamily,
                                              color: getSubFontColor(context),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        items: authorController.authorList
                                            .map(
                                              (element) => DropdownMenuItem(
                                                value: element,
                                                child: Text(
                                                    "${element.firstname ?? ""} ${element.firstname ?? ""} (${element.solde} FCFA)"),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          retraitController.topAuthors = value;
                                        },
                                        value: retraitController.topAuthors,
                                        validator: (value) => value != null
                                            ? null
                                            : "Vous devez selectionner un auteur",
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle(
                                          'Montant a retirer', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          "Entrer le montant",
                                          retraitController.amount,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ], validator: (value) {
                                        if (value.toString().isEmpty) {
                                          return "Montant obligatoire";
                                        } else if (int.parse(value.toString()) >
                                            retraitController
                                                .topAuthors!.solde!) {
                                          return "Le montant doit etre inferieur au solde de l'auteur";
                                        } else {
                                          return null;
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 20),
                    Container(
                      width: Get.width / 3,
                      child: Obx(
                        () => getButtonWidget(
                          context,
                          'Enregister',
                          isProgress: retraitController.loading.value,
                          () {
                            if (formKey.currentState!.validate()) {
                              retraitController
                                  .createRetrait(context: context)
                                  .then((value) {
                                setState(() {});
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
