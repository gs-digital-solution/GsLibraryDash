import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/categories/screens/entries_drop_down.dart';
import 'package:gslibrarydashboard/features/countries/controller/country_controller.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/controllers/exchange_rate_controller.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/models/exchange_rate.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

import '../../promos/screens/promoPage.dart';

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  State<ExchangeRatePage> createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  RxInt position = 0.obs;

  RxInt totalItem = 10.obs;

  RxInt ind = 0.obs;
  final ExchangeRateController countryController =
      Get.put(ExchangeRateController());
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
            getTextWidget(
                context, 'Taux d\'echanges', 75, getFontColor(context),
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
                            isWeb(context)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: getEntryWidget(context),
                                    ),
                                  )
                                : Container(),
                            getHorizontalSpace(context, isWeb(context) ? 0 : 0),
                            Visibility(
                              child: Expanded(child: Container()),
                              visible: isWeb(context),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                countryController.getExchangeRates();
                              },
                              child: Text('Actualiser'),
                            ),
                            getHorizontalSpace(context, 15),
                            Expanded(
                                child: getSearchTextFiledWidget(
                                    context, 'Search..', textEditingController,
                                    onChanged: (value) {
                              queryText(value);
                            })),
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
                        isWeb(context)
                            ? Container()
                            : Container(
                                child: getEntryWidget(context),
                                margin: EdgeInsets.only(top: 15.h),
                              ),
                        getVerticalSpace(context, 25),
                        countryController.obx(
                          (state) => Obx(() {
                            double i = state!.length / 10;

                            int d = state.length -
                                (totalItem.value * i.toInt()).toInt();

                            if (d > 0) {
                              i = i + 1;
                            }
                            List<ExchangeRate> paginationList = [];

                            paginationList = state
                                .skip(position.value * totalItem.value)
                                .take(totalItem.value)
                                .toList();
                            return Expanded(
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
                                            width:
                                                isWeb(context) ? 130.h : 80.h,
                                            child: getMaxLineFont(context, 'ID',
                                                50, getFontColor(context), 1,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start)),
                                        Expanded(
                                          flex: 1,
                                          child: getMaxLineFont(
                                              context,
                                              'Pays entrant',
                                              50,
                                              getFontColor(context),
                                              1,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: getMaxLineFont(
                                              context,
                                              'Pays sortant',
                                              50,
                                              getFontColor(context),
                                              1,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: getMaxLineFont(
                                              context,
                                              'Taux d\'echange',
                                              50,
                                              getFontColor(context),
                                              1,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start),
                                        ),
                                        getHorizontalSpace(
                                          context,
                                          30,
                                        ),
                                        getMaxLineFont(context, 'Action', 50,
                                            getFontColor(context), 1,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: ListView.separated(
                                    itemCount: paginationList.length,
                                    controller: _controller,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return Obx(() {
                                        bool cell = true;

                                        if (queryText.value.isNotEmpty &&
                                            paginationList[index]
                                                .countryFrom!
                                                .toLowerCase()
                                                .contains(queryText.value
                                                    .toLowerCase())) {
                                          cell = false;
                                        }

                                        return cell
                                            ? separatorBuilder(context,
                                                value: paginationList[index]
                                                    .countryFrom!,
                                                queryText: queryText)
                                            : Container();
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      return Obx(() {
                                        bool cell = true;

                                        if (queryText.value.isNotEmpty &&
                                            !paginationList[index]
                                                .countryFrom!
                                                .toLowerCase()
                                                .contains(queryText.value
                                                    .toLowerCase())) {
                                          cell = false;
                                        }
                                        return cell
                                            ? Stack(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 15.h),
                                                    decoration:
                                                        getDefaultDecoration(
                                                            bgColor:
                                                                getCardColor(
                                                                    context),
                                                            radius: 0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width:
                                                                isWeb(context)
                                                                    ? 130.h
                                                                    : 80.h,
                                                            child:
                                                                getMaxLineFont(
                                                                    context,
                                                                    '${state.indexOf(paginationList[index]) + 1}',
                                                                    // (position.value != 0)?'${position.value}${index + 1}':"${d}",
                                                                    50,
                                                                    getFontColor(
                                                                        context),
                                                                    1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start)),
                                                        getHorizontalSpace(
                                                          context,
                                                          10,
                                                        ),
                                                        Expanded(
                                                          child: getMaxLineFont(
                                                            context,
                                                            paginationList[
                                                                    index]
                                                                .countryFrom!
                                                                .toString(),
                                                            50,
                                                            getFontColor(
                                                                context),
                                                            1,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: getMaxLineFont(
                                                            context,
                                                            paginationList[
                                                                    index]
                                                                .countryTo!,
                                                            50,
                                                            getFontColor(
                                                                context),
                                                            1,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: getMaxLineFont(
                                                            context,
                                                            paginationList[
                                                                    index]
                                                                .rate!
                                                                .toString(),
                                                            50,
                                                            getFontColor(
                                                                context),
                                                            1,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        getHorizontalSpace(
                                                          context,
                                                          30,
                                                        ),
                                                        Stack(
                                                          children: [
                                                            getMaxLineFont(
                                                                context,
                                                                'Action',
                                                                50,
                                                                Colors
                                                                    .transparent,
                                                                1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                            Positioned.fill(
                                                                child: Center(
                                                              child:
                                                                  GestureDetector(
                                                                      onTapDown:
                                                                          _storePosition,
                                                                      onTap:
                                                                          () {
                                                                        _showPopupMenu(
                                                                            context,
                                                                            _tapPosition,
                                                                            paginationList[index]);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        color: getSubFontColor(
                                                                            context),
                                                                      )),
                                                            ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      });
                                    },
                                  )),
                                  getVerticalSpace(
                                      context, (getCommonPadding(context) / 2)),
                                  Container(
                                    // height: 55.h,
                                    width: double.infinity,

                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print(
                                                  "posi===${position.value}===${i - 1}");
                                              if (position.value > 0) {
                                                position.value =
                                                    position.value - 1;
                                              }
                                            },
                                            child: getSvgImage1(
                                              'left.svg',
                                              height: 20.h,
                                              width: 20.h,
                                            ),

                                            // child: Icon(
                                            //   Icons.chevron_left,
                                            //   color: subPrimaryColor(context),
                                            // )
                                          ),
                                          getHorizontalSpace(context, 10),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: List.generate(
                                                    i.toInt(),
                                                    (index) => InkWell(
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.h),
                                                            height: 35.h,
                                                            width: 35.h,

                                                            decoration: getDefaultDecoration(
                                                                bgColor: position
                                                                            .value ==
                                                                        index
                                                                    ? getPrimaryColor(
                                                                        context)
                                                                    : Colors
                                                                        .transparent,
                                                                radius:
                                                                    getResizeRadius(
                                                                        context,
                                                                        15)),
                                                            // decoration: BoxDecoration(
                                                            //     shape: BoxShape
                                                            //         .circle,
                                                            //     color: position
                                                            //         .value ==
                                                            //         index
                                                            //         ? getPrimaryColor(context)
                                                            //         : getBorderColor(
                                                            //         context)),
                                                            child: Center(
                                                              child: getTextWidget(
                                                                  context,
                                                                  '${index + 1}',
                                                                  50,
                                                                  position.value ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : subPrimaryColor(
                                                                          context)),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            position.value =
                                                                index;
                                                            _controller
                                                                .jumpTo(0);
                                                          },
                                                        )),
                                              ),
                                            ),
                                          ),
                                          getHorizontalSpace(context, 10),
                                          InkWell(
                                            onTap: () {
                                              /*  print(
                                                        "posi===${position.value}===${i - 1}");
                                                    if (position.value <
                                                        (i.toInt() - 1)) {
                                                      position.value =
                                                          position.value +
                                                              1;
                                                    } */
                                            },

                                            child: getSvgImage1(
                                              'right.svg',
                                              height: 18.h,
                                              width: 18.h,
                                            ),
                                            // child: Icon(
                                            //   Icons.chevron_right,
                                            //   color: subPrimaryColor(context),
                                            // )
                                          ),
                                          getHorizontalSpace(context, 25),
                                          Expanded(
                                              child: Container(
                                                  // child: isWeb(context)
                                                  //     ? getEntryWidget(
                                                  //     context)
                                                  //     : Container(),
                                                  ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  getVerticalSpace(
                                      context, (getCommonPadding(context) / 2)),
                                ],
                              ),
                            );
                          }),
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

  getEntryWidget(BuildContext context) {
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
  }

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _showPopupMenu(
      BuildContext context, var detail, ExchangeRate storyModel) async {
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
                title: "Mettre a jour",
                space: 0,
              ),
            ),
            onTap: () {
              countryController.setPromo(storyModel);
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
              getCommonDialog(
                  context: context,
                  title: 'Voulez-vous supprimer ce Pays?',
                  function: () {
                    countryController.deleteExchangeRate(
                        exchangeRate: storyModel);
                  },
                  subTitle: 'Supprimer');
            },
            value: 'Supprimer'),
      ],
      elevation: 1,
    );
  }

  getActiveDeActiveCell(
      BuildContext context, bool isActive, Country storyModel) {
    return InkWell(
      child: Container(
          width: 120.h,
          alignment: Alignment.centerLeft,
          child: getButton(
              context,
              isActive ? 'Activer' : 'Desactiver',
              isActive ? "#00A010".toColor() : "#FD3E3E".toColor(),
              isActive ? "#E7FFE8".toColor() : "#FFF2F2".toColor())),
      onTap: () {
        storyModel.isActivated!.value = !storyModel.isActivated!.value;
        //updateStatus(context, storyModel);
      },
    );
  }

  getButton(BuildContext context, String string, Color color, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.h),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(getResizeRadius(context, 45))),
      child: getMaxLineFont(context, string, 45, color, 1,
          fontWeight: FontWeight.w400, textAlign: TextAlign.start),
    );
  }

  updateStatus(BuildContext context, Country storyModel) {
    getCommonDialog(
        context: context,
        title: storyModel.isActivated!.value
            ? 'Voulez-vous desactiver ce pays'
            : 'Voulez-vous activer ce pays?',
        function: () {
          storyModel.isActivated!.value = !storyModel.isActivated!.value;
          //categoryController.updatePromoStatus(promo: storyModel);
        },
        subTitle: 'Pays');
  }
}
