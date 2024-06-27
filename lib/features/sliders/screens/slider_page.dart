import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/categories/controller/categoryController.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/features/categories/screens/entries_drop_down.dart';
import 'package:gslibrarydashboard/features/sliders/controller/slider_controller.dart';
import 'package:gslibrarydashboard/features/sliders/models/slider.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

class SliderScreen extends StatefulWidget {
  SliderScreen();

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final SliderController categoryController = Get.put(SliderController());
  final HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();

    //LoginData.getDeviceId();
  }

  RxInt position = 0.obs;

  RxInt totalItem = 30.obs;

  RxInt ind = 0.obs;

  final ScrollController _controller = ScrollController();

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
            getTextWidget(context, 'Sliders', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
                child: getCommonContainer(
                    context: context,
                    verSpace: 0,
                    horSpace: isWeb(context) ? null : 15.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getVerticalSpace(context, getCommonPadding(context)),
                        Row(
                          children: [
                           
                            Align(
                              alignment: Alignment.centerLeft,
                              child: getTextWidget(
                                context,
                                'Listes des Slides',
                                50,
                                getFontColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                categoryController.fetchCategoryData();
                              },
                              child: Text('Actualiser'),
                            ),
                            getHorizontalSpace(context, 15),

                            /*   getButtonWidget(
                              context,
                              'Add New Category',
                              () {
                                /* homeController.selectedItem!.value =
                                    AdminMenuItem(
                                  title: 'Ajouter une categorie',
                                  icon: Icons.add,
                                  route: '/HomePage/categories/add',
                                ); */
                              },
                              horPadding: 25.h,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 42.h,
                            ) */
                          ],
                        ),
                        getVerticalSpace(context, 25),
                        categoryController.obx(
                          (state) => Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 15.h),
                                  decoration: getDefaultDecoration(
                                      bgColor: getReportColor(context),
                                      radius: 0),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: isWeb(context) ? 130.h : 80.h,
                                          child: getMaxLineFont(context, 'ID',
                                              50, getFontColor(context), 1,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start)),
                                      Expanded(
                                          child: Container(
                                        width: 150.h,
                                        child: getMaxLineFont(context, 'Image',
                                            50, getFontColor(context), 1,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start),
                                      )),
                                      getMaxLineFont(context, 'Action', 50,
                                          getFontColor(context), 1,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start)
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: ListView.separated(
                                  itemCount: state!.length,
                                  controller: _controller,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.h),
                                      decoration: getDefaultDecoration(
                                          bgColor: getCardColor(context),
                                          radius: 0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width:
                                                  isWeb(context) ? 130.h : 80.h,
                                              child: getMaxLineFont(
                                                  context,
                                                  '$index',
                                                  50,
                                                  getFontColor(context),
                                                  1,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start)),
                                          Expanded(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 250.h,
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  height:200.h,
                                                  width: 200.h,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Image(
                                                      image: NetworkImage(
                                                        state[index]
                                                            .avatar!
                                                            .url!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              getHorizontalSpace(
                                                context,
                                                10,
                                              ),
                                            ],
                                          )),
                                          Stack(
                                            children: [
                                              getMaxLineFont(context, 'Action',
                                                  50, Colors.transparent, 1,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start),
                                              Positioned.fill(
                                                  child: Center(
                                                child: GestureDetector(
                                                    onTapDown: _storePosition,
                                                    onTap: () {
                                                      _showPopupMenu(
                                                        context,
                                                        onTapDelete: () {
                                                          getCommonDialog(
                                                            context: context,
                                                            title:
                                                                'Voulez-vous supprimer cette categorie?',
                                                            function: () async {
                                                              categoryController
                                                                  .deleteCategory(
                                                                      model: state[
                                                                          index]);
                                                            },
                                                            subTitle:
                                                                'Supprimer',
                                                          );
                                                        },
                                                        onTapEdit: () {
                                                          homeController
                                                                  .selectedItem!
                                                                  .value =
                                                              AdminMenuItem(
                                                            title:
                                                                'Ajouter une image',
                                                            icon: Icons.add,
                                                            route:
                                                                '/sliders/add',
                                                          );

                                                          categoryController
                                                                  .categoryModel =
                                                              state[index];
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      color: getSubFontColor(
                                                          context),
                                                    )),
                                              ))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )),
                                getVerticalSpace(
                                    context, (getCommonPadding(context) / 2)),
                              ],
                            ),
                          ),
                          onLoading: getProgressWidget(context),
                          onError: (error) => Center(child: getNoData(context)),
                        ),
                      ],
                    ))),
            getVerticalSpace(context, isWeb(context) ? 0 : 35),
          ],
        ),
      ),
    );
  }

/*   getEntryWidget(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
  } */

  var _tapPosition;

  _showPopupMenu(BuildContext context,
      {required Function onTapEdit, required Function onTapDelete}) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(0.h, 0.h), // smaller rect, the touch area
          Offset.zero & overlay!.size // Bigger rect, the entire screen
          ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: ThemeController().checkDarkTheme()
          ? getBackgroundColor(context)
          : getCardColor(context),
      items: [
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Mettre a jour",
                space: 0,
              ),
            ),
            onTap: () {
              onTapEdit();
            },
            value: 'Mettre a jour'),
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Supprimer",
                space: 0,
                visibility: false,
              ),
            ),
            onTap: () {
              onTapDelete();
            },
            value: 'Supprimer'),
      ],
      elevation: 1.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
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
              // child == null ? Container() : child!
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
