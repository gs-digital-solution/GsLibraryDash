import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';

import 'package:gslibrarydashboard/features/categories/screens/entries_drop_down.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/controllers/transfert_demand_controller.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/models/transfert.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/pages/widgets/mobile_transfert_widget.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/pages/widgets/web_transfert_widget.dart';
import 'package:gslibrarydashboard/common/custom_pagination_widget.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

class TransfertPage extends StatefulWidget {
  TransfertPage();

  @override
  State<TransfertPage> createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  @override
  void initState() {
    super.initState();
  }

  final TransfertDemandController bookController = Get.put(TransfertDemandController());


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
          getTextWidget(context, 'Transferts de Livres', 75, getFontColor(context),
              fontWeight: FontWeight.w700),
          getVerticalSpace(context, 35),
          
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
                                                ? TransfertWidgetWeb(
                                                    mainList: state,
                                                    list: state,
                                                    queryText: queryText,
                                                    controller: bookController,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                    onTapStatus: (model) {
                                                      updateStatus(
                                                          context, model);
                                                    })
                                                : TransfertMobileWidget(
                                                    mainList: state,
                                                    list: state,
                                                    queryText: queryText,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                    onTapStatus: (model) {
                                                      updateStatus(
                                                          context, model);
                                                    }),
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

  updateStatus(BuildContext context, Book storyModel) {
    getCommonDialog(
        context: context,
        title: storyModel.status!.value
            ? 'Do you want to de-active this book?'
            : 'Do you want to active this book?',
        function: () {
          
        },
        subTitle: 'Book');
  }

  _showPopupMenu(BuildContext context, var detail, TransfertDevice storyModel) async {
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
