import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/categories/screens/entries_drop_down.dart';
import 'package:gslibrarydashboard/features/dashboard/controllers/dashboardController.dart';
import 'package:gslibrarydashboard/features/retraits/controller/retraitController.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/features/retraits/pages/subwidget/mobile_retrait_widget.dart';
import 'package:gslibrarydashboard/features/retraits/pages/subwidget/web_retrait_widget.dart';
import 'package:gslibrarydashboard/common/custom_pagination_widget.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

class RetraitPage extends StatefulWidget {
  RetraitPage();

  @override
  State<RetraitPage> createState() => _RetraitPageState();
}

class _RetraitPageState extends State<RetraitPage> {
  @override
  void initState() {
    super.initState();
  }

  final RetraitController bookController = Get.put(RetraitController());
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    RxString queryText = ''.obs;

    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(
          horizontal: getDefaultHorSpace(context),
          vertical: getDefaultHorSpace(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTextWidget(context, 'Paiements', 75, getFontColor(context),
              fontWeight: FontWeight.w700),
          getVerticalSpace(context, 35),
          /* FutureBuilder(
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
                              "Total paiements",
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
                        '${snapshot.data!.retrait} XAF',
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
          ),
          getVerticalSpace(context, 25), */
          Expanded(
              child: getCommonContainer(
                  context: context,
                  verSpace: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getVerticalSpace(context, getCommonPadding(context)),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              bookController.fetchCategoryData(refresh: true);
                            },
                            child: Text('Actualiser'),
                          ),
                          getHorizontalSpace(context, 15),
                          Expanded(
                              child: getSearchTextFiledWidget(
                                  context, 'Rechercher...', textEditingController,
                                  onChanged: (value) {
                            queryText(value);
                          })),
                          getHorizontalSpace(context, 15),
                        ],
                      ),
                      getVerticalSpace(context, 25),
                      bookController.obx(
                          (state) => Obx(() {
                                return state != null && state.isNotEmpty
                                    ? Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            isWeb(context)
                                                ? RetraitWebWidget(
                                                    mainList: state,
                                                    list: state,
                                                    queryText: queryText,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                  )
                                                : RetraitMobileWidget(
                                                    mainList: state,
                                                    list: state,
                                                    queryText: queryText,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                  ),
                                            getVerticalSpace(context, 20),
                                            
                                            // Widget de pagination personnalisé
                                            CustomPaginationWidget(
                                              currentPage: bookController.currentPage.value,
                                              totalPages: bookController.totalPages.value,
                                              totalItems: bookController.totalItems.value,
                                              itemsPerPage: bookController.pageSize.value,
                                              onPageChanged: (page) {
                                                bookController.changePage(page);
                                              },
                                              onItemsPerPageChanged: (size) {
                                                bookController.changePageSize(size);
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(child: getNoData(context));
                              }),
                          onLoading: getProgressWidget(context),
                          onEmpty: getNoData(context)),
                    ],
                  )))
        ],
      ),
    ));
  }

  // updateStatus(BuildContext context, Retrait storyModel) {
  //   getCommonDialog(
  //             context: context,
  //             title: storyModel.status!
  //                 ? 'Do you want to de-active this book?'
  //                 : 'Do you want to active this book?',
  //             function: () {

  //             },
  //             subTitle: 'Book');

  // }

  _showPopupMenu(BuildContext context, var detail, Retrait storyModel) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          detail & Size(0.h, 0.h), // smaller rect, the touch area
          Offset.zero & overlay!.size // Bigger rect, the entire screen
          ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: Get.find<ThemeController>().checkDarkTheme()
          ? getBackgroundColor(context)
          : getCardColor(context),
      items: [
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Edit",
                space: 0,
              ),
            ),
            onTap: () {},
            value: 'Edit'),
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Delete",
                space: 0,
                visibility: false,
              ),
            ),
            onTap: () {
              getCommonDialog(
                  context: context,
                  title: 'Do you want to delete this book?',
                  function: () {},
                  subTitle: 'Delete');
            },
            value: 'Delete'),
      ],
      elevation: 1,
    );
  }


}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    this.visibility,
    this.color,
    this.space,
    this.child,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? child;
  final double? space;
  final bool? visibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 12.h,
          ),
          child: Row(
            children: [
              Expanded(
                  child: getMaxLineFont(context, title, 45,
                      color == null ? getFontColor(context) : color!, 1,
                      fontWeight: FontWeight.w500)),
              child == null ? Container() : child!
            ],
          ),
        ),
        Visibility(
          visible: (visibility == null) ? true : visibility!,
          child: Container(
            color: getBorderColor(context),
            width: double.infinity,
            height: 0.5,
          ),
        )
      ],
    ).marginSymmetric(horizontal: space == null ? 35.w : space!);
  }
}
