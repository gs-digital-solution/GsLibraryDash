import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/dashboard/controllers/dashboardController.dart';
import 'package:gslibrarydashboard/main.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

import '../../author/screens/addAuthorPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(context, 35),
            getTextWidget(context, 'DashBoard', 75, getFontColor(context),
                    fontWeight: FontWeight.w900)
                .marginSymmetric(horizontal: getDefaultHorSpace(context)),
            getVerticalSpace(context, 35),
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: dashboardController.getStatAdmin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return getProgressDialog(context);
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.data != null) {
                      double iconSize =
                          (MediaQuery.of(context).size.width < 1338)
                              ? 25.h
                              : 40.h;
                      double fontSize =
                          (MediaQuery.of(context).size.width < 1338)
                              ? 15
                              : 17.sp;
                      double fontSize1 =
                          (MediaQuery.of(context).size.width < 1338)
                              ? 35
                              : 40.h;
                      return GridView(
                        padding: EdgeInsets.symmetric(
                            horizontal: getDefaultHorSpace(context)),
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: kIsWeb
                                ? (MediaQuery.of(context).size.width < 1338)
                                    ? 2
                                    : 3
                                : 2,
                            mainAxisExtent: 180.h,
                            mainAxisSpacing: kIsWeb ? 10.h : 20.h,
                            crossAxisSpacing: kIsWeb ? 10.h : 20.h),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 16),
                                      blurRadius: 31,
                                      color:
                                          Color(0XFFACBFC1).withOpacity(0.10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.h),
                                ),
                                color: getSubCardColor(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 96.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.h),
                                          topRight: Radius.circular(16.h)),
                                      color: Color(0XFFD8F1E4)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getSvgImage("dashboard_category_icon.svg",
                                          height: iconSize, width: iconSize),
                                      getHorSpace(12.h),
                                      getMultilineCustomFont(
                                        "Solde GSLIBARY + INVESTISSEUR"
                                            .toUpperCase(),
                                        fontSize,
                                        Colors.black,
                                        fontWeight: FontWeight.w300,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.h),
                                ),
                                getVerSpace(12.h),
                                getCustomFont(
                                  '${(snapshot.data!.soldeGslibrary!).toStringAsFixed(2)} XAF',
                                  fontSize1,
                                  Colors.orangeAccent,
                                  1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 16),
                                      blurRadius: 31,
                                      color:
                                          Color(0XFFACBFC1).withOpacity(0.10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.h),
                                ),
                                color: getSubCardColor(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 96.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.h),
                                          topRight: Radius.circular(16.h)),
                                      color: Color(0XFFFFEDE9)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getSvgImage("dashboard_category_icon.svg",
                                          height: iconSize, width: iconSize),
                                      getHorSpace(12.h),
                                      getMultilineCustomFont(
                                        "Total Commandes".toUpperCase(),
                                        fontSize,
                                        Colors.black,
                                        fontWeight: FontWeight.w300,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.h),
                                ),
                                getVerSpace(12.h),
                                getCustomFont(
                                  '${snapshot.data!.commande} XAF',
                                  fontSize1,
                                  Colors.green,
                                  1,
                                  fontWeight: FontWeight.w700,
                                )
                              ],
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 16),
                                      blurRadius: 31,
                                      color:
                                          Color(0XFFACBFC1).withOpacity(0.10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.h),
                                ),
                                color: getSubCardColor(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 96.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.h),
                                          topRight: Radius.circular(16.h)),
                                      color: Color(0XFFD8F1E4)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getSvgImage("dashboard_category_icon.svg",
                                          height: iconSize, width: iconSize),
                                      getHorSpace(12.h),
                                      getMultilineCustomFont(
                                        "Restant a Payer au Utilisateurs"
                                            .toUpperCase(),
                                        fontSize,
                                        Colors.black,
                                        fontWeight: FontWeight.w300,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.h),
                                ),
                                getVerSpace(12.h),
                                getCustomFont(
                                  '${snapshot.data!.montantUser} XAF',
                                  fontSize1,
                                  Colors.orangeAccent,
                                  1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          //  getHorSpace(20.h),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 16),
                                      blurRadius: 31,
                                      color:
                                          Color(0XFFACBFC1).withOpacity(0.10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.h),
                                ),
                                color: getSubCardColor(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 96.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.h),
                                          topRight: Radius.circular(16.h)),
                                      color: Color(0XFFD8F1E4)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getSvgImage("dashboard_category_icon.svg",
                                          height: iconSize, width: iconSize),
                                      getHorSpace(12.h),
                                      getMultilineCustomFont(
                                        "Restant a Payer aux Auteurs"
                                            .toUpperCase(),
                                        fontSize,
                                        Colors.black,
                                        fontWeight: FontWeight.w300,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.h),
                                ),
                                getVerSpace(12.h),
                                getCustomFont(
                                  '${snapshot.data!.montant} XAF',
                                  fontSize1,
                                  Colors.orangeAccent,
                                  1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          // getHorSpace(20.h),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 16),
                                      blurRadius: 31,
                                      color:
                                          Color(0XFFACBFC1).withOpacity(0.10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.h),
                                ),
                                color: getSubCardColor(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 96.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.h),
                                          topRight: Radius.circular(16.h)),
                                      color: Color(0XFFFFEDE9)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getSvgImage("dashboard_category_icon.svg",
                                          height: iconSize, width: iconSize),
                                      getHorSpace(12.h),
                                      getMultilineCustomFont(
                                        "Total paiements".toUpperCase(),
                                        fontSize,
                                        Colors.black,
                                        fontWeight: FontWeight.w300,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.h),
                                ),
                                getVerSpace(12.h),
                                getCustomFont(
                                  '-${snapshot.data!.retrait} XAF',
                                  fontSize1,
                                  Colors.red,
                                  1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      width: Get.width / 2,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.h, vertical: 30.h),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: Form(
                                        key: formKey,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              getCustomFont(
                                                "Nouveau Retrait",
                                                14.sp,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              getVerSpace(20.h),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  itemSubTitle(
                                                      'Montant a retirer',
                                                      context),
                                                  getVerticalSpace(context, 10),
                                                  getTextFiledWidget(
                                                      context,
                                                      "Entrer le montant",
                                                      dashboardController
                                                          .amount,
                                                      validator: (value) => value
                                                              .isEmpty
                                                          ? "Montant obligatoire"
                                                          : null,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ]),
                                                ],
                                              ),
                                              getVerticalSpace(context, 30),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  itemSubTitle(
                                                      'Numéro de téléphone',
                                                      context),
                                                  getVerticalSpace(context, 10),
                                                  getTextFiledWidget(
                                                      context,
                                                      "Entrer Numéro de téléphone",
                                                      dashboardController.phoneNumber,
                                                      validator: (value) => value.isEmpty ? "Numéro de téléphone obligatoire" : null,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ]),
                                                ],
                                              ),
                                              getVerticalSpace(context, 30),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  itemSubTitle(
                                                      'Mot de passe', context),
                                                  getVerticalSpace(context, 10),
                                                  getPasswordTextFiledWidget(
                                                    context,
                                                    "Entrer le mot de passe",
                                                    dashboardController
                                                        .password,
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? "Mot de passe obligatoire"
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                              getVerticalSpace(context, 30),
                                              Column(
                                                children: List.generate(
                                                    dashboardController
                                                        .cashIns.length,
                                                    (index) =>
                                                        RadioListTile<CashIn>(
                                                          value:
                                                              dashboardController
                                                                      .cashIns[
                                                                  index],
                                                          title: Text(
                                                              dashboardController
                                                                  .cashIns[
                                                                      index]
                                                                  .name!),
                                                          groupValue:
                                                              dashboardController
                                                                  .selectedCashIn,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              dashboardController
                                                                      .selectedCashIn =
                                                                  value!;
                                                            });
                                                          },
                                                        )),
                                              ),
                                              getVerticalSpace(context, 30),
                                              Row(
                                                children: [
                                                  Obx(() => Expanded(
                                                        child: getButtonWidget(
                                                          context,
                                                          'Nouveau Retrait',
                                                          isProgress:
                                                              dashboardController
                                                                  .isLoading
                                                                  .value,
                                                          () {
                                                            if (formKey
                                                                .currentState!
                                                                .validate()) {
                                                              dashboardController
                                                                  .initRetraitAdmin()
                                                                  .then(
                                                                      (value) {
                                                                setState(() {});
                                                              });
                                                            }
                                                          },
                                                          horPadding: 25.h,
                                                          horizontalSpace: 0,
                                                          verticalSpace: 0,
                                                          btnHeight: 60.h,
                                                        ),
                                                      )),
                                                  getHorSpace(10.h),
                                                  Expanded(
                                                    child: getButtonWidget(
                                                      context,
                                                      'Annuler',
                                                      isProgress: false,
                                                      () {
                                                        dashboardController
                                                            .isLoading
                                                            .value = false;
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
                                              getVerticalSpace(context, 30),
                                              Obx(
                                                () => dashboardController
                                                        .message.value.isEmpty
                                                    ? SizedBox()
                                                    : Text(
                                                        dashboardController
                                                            .message.value,
                                                        style: TextStyle(
                                                          fontFamily: Constants
                                                              .fontsFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 16),
                                        blurRadius: 31,
                                        color:
                                            Color(0XFFACBFC1).withOpacity(0.10))
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.h),
                                  ),
                                  color: getSubCardColor(context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 96.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.h),
                                            topRight: Radius.circular(16.h)),
                                        color: Color(0XFFFFEDE9)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        getSvgImage(
                                            "dashboard_category_icon.svg",
                                            height: iconSize,
                                            width: iconSize),
                                        getHorSpace(12.h),
                                        getMultilineCustomFont(
                                          "Nouveau Retrait d'argent"
                                              .toUpperCase(),
                                          fontSize,
                                          Colors.black,
                                          fontWeight: FontWeight.w300,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 15.h),
                                  ),
                                  getVerSpace(12.h),
                                  getCustomFont(
                                    '+',
                                    fontSize1,
                                    Colors.red,
                                    1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return getNoData(context);
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
