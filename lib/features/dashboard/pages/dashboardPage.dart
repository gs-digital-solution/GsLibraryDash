import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/dashboard/controllers/dashboardController.dart';
import 'package:gslibrarydashboard/main.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dashboardController =
      Get.put(DashboardController());
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
                                        "Total Commandes",
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
                                        "Restant a Payer",
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
                                        "Total paiements",
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
