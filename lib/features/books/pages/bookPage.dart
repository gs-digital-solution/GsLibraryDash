import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';

import 'package:gslibrarydashboard/features/books/controller/bookController.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/books/pages/subwidget/mobile_widget.dart';
import 'package:gslibrarydashboard/features/books/pages/subwidget/web_widget.dart';
import 'package:gslibrarydashboard/features/categories/screens/entries_drop_down.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

class StoryScreen extends StatefulWidget {
  StoryScreen();

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  RxInt position = 0.obs;

  RxInt totalItem = 10.obs;

  final ScrollController _controller = ScrollController();

  final BookController bookController = Get.put(BookController());

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
          getTextWidget(context, 'Books', 75, getFontColor(context),
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
                          isWeb(context)
                              ? Expanded(
                                  child: Container(
                                  child: getEntryWidget(context),
                                ))
                              : Container(),
                          getHorizontalSpace(context, isWeb(context) ? 0 : 0),
                          Visibility(
                            child: Expanded(child: Container()),
                            visible: isWeb(context),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              bookController.fetchCategoryData();
                            },
                            child: Text('Actualiser'),
                          ),
                          Expanded(
                              child: getSearchTextFiledWidget(
                                  context, 'Search..', textEditingController,
                                  onChanged: (value) {
                            queryText(value);
                          })),
                          getHorizontalSpace(context, 15),
                          /* getButtonWidget(
                              context,
                              'Add New Book',
                                  () {

                                    
                              },
                              horPadding: 25.h,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 42.h,
                            ) */
                        ],
                      ),
                      isWeb(context)
                          ? Container()
                          : Container(
                              child: getEntryWidget(context),
                              margin: EdgeInsets.only(top: 15.h),
                            ),
                      getVerticalSpace(context, 25),
                      bookController.obx(
                          (state) => Obx(() {
                                double i = state!.length / 10;

                                int d = state.length -
                                    (totalItem.value * i.toInt()).toInt();

                                if (d > 0) {
                                  i = i + 1;
                                }
                                List<Book> paginationList = [];

                                paginationList = state
                                    .skip(position.value * totalItem.value)
                                    .take(totalItem.value)
                                    .toList();

                                print(
                                    "pos==${position.value}==${paginationList.length}");

                                return paginationList.length > 0
                                    ? Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            isWeb(context)
                                                ? WebWidget(
                                                    mainList: state,
                                                    list: paginationList,
                                                    queryText: queryText,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                    onTapStatus: (model) {
                                                      updateStatus(
                                                          context, model);
                                                    })
                                                : MobileWidget(
                                                    mainList: state,
                                                    list: paginationList,
                                                    queryText: queryText,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                    onTapStatus: (model) {
                                                      updateStatus(
                                                          context, model);
                                                    }),
                                            getVerticalSpace(
                                                context,
                                                (getCommonPadding(context) /
                                                    2)),
                                            Container(
                                              width: double.infinity,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        print(
                                                            "posi===${position.value}===${i - 1}");
                                                        if (position.value >
                                                            0) {
                                                          position.value =
                                                              position.value -
                                                                  1;
                                                        }
                                                      },
                                                      child: getSvgImage1(
                                                        'left.svg',
                                                        height: 20.h,
                                                        width: 20.h,
                                                      ),
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 10),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children:
                                                              List.generate(
                                                                  i.toInt(),
                                                                  (index) =>
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 5.h),
                                                                          height:
                                                                              35.h,
                                                                          width:
                                                                              35.h,
                                                                          decoration: getDefaultDecoration(
                                                                              bgColor: position.value == index ? getPrimaryColor(context) : Colors.transparent,
                                                                              radius: getResizeRadius(context, 15)),
                                                                          child:
                                                                              Center(
                                                                            child: getTextWidget(
                                                                                context,
                                                                                '${index + 1}',
                                                                                50,
                                                                                position.value == index ? Colors.white : subPrimaryColor(context)),
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          position.value =
                                                                              index;
                                                                          _controller
                                                                              .jumpTo(0);
                                                                        },
                                                                      )),
                                                        ),
                                                      ),
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 10),
                                                    InkWell(
                                                      onTap: () {
                                                        print(
                                                            "posi===${position.value}===${i - 1}");
                                                        if (position.value <
                                                            (i.toInt() - 1)) {
                                                          position.value =
                                                              position.value +
                                                                  1;
                                                        }
                                                      },
                                                      child: getSvgImage1(
                                                        'right.svg',
                                                        height: 18.h,
                                                        width: 18.h,
                                                      ),
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 25),
                                                    Expanded(child: Container())
                                                  ],
                                                ).marginOnly(
                                                    right: getCommonPadding(
                                                        context)),
                                              ),
                                            ),
                                            getVerticalSpace(
                                                context,
                                                (getCommonPadding(context) /
                                                    2)),
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
        title: storyModel.status!
            ? 'Do you want to de-active this book?'
            : 'Do you want to active this book?',
        function: () {},
        subTitle: 'Book');
  }

  _showPopupMenu(BuildContext context, var detail, Book storyModel) async {
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

  getEntryWidget(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getTextWidget(context, 'Show entries', 50, getFontColor(context),
                fontWeight: FontWeight.w500),
            getHorizontalSpace(context, 15),
            EntriesDropDown(
                onChanged: (value) {
                  totalItem(value);
                },
                value: totalItem.value),
          ],
        ));
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
