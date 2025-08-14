import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';
import 'package:gslibrarydashboard/features/partners/widgets/partner_mobile_widget.dart';
import 'package:gslibrarydashboard/features/partners/widgets/partner_web_widget.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

class PartnerPage extends StatefulWidget {
  PartnerPage();

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  RxInt position = 0.obs;
  RxInt totalItem = 10.obs;
  final ScrollController _controller = ScrollController();
  final PartnerController partnerController = Get.put(PartnerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    RxString queryText = ''.obs;

    return Material(
      child: SafeArea(
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
                      context, 'Partenaires', 75, getFontColor(context),
                      fontWeight: FontWeight.w700),
                  
                ],
              ),
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
                              partnerController.fetchPartners(refresh: true);
                            },
                            child: Text('Actualiser'),
                          ),
                          getHorizontalSpace(context, 15),
                          Expanded(
                              child: getSearchTextFiledWidget(
                                  context,
                                  'Rechercher...',
                                  textEditingController, onChanged: (value) {
                            queryText(value);
                          })),
                          getHorizontalSpace(context, 15),
                          // Filtre par statut
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: getDefaultDecoration(
                              bgColor: getCardColor(context),
                              borderColor: getBorderColor(context),
                              borderWidth: 1,
                              radius: getDefaultRadius(context),
                            ),
                            child: DropdownButton<String>(
                              value: partnerController
                                      .selectedFilterStatus.value.isEmpty
                                  ? null
                                  : partnerController
                                      .selectedFilterStatus.value,
                              hint: Text('Statut'),
                              underline: Container(),
                              items: [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('Tous'),
                                ),
                                DropdownMenuItem(
                                  value: 'active',
                                  child: Text('Actif'),
                                ),
                                DropdownMenuItem(
                                  value: 'inactive',
                                  child: Text('Inactif'),
                                ),
                                DropdownMenuItem(
                                  value: 'suspended',
                                  child: Text('Suspendu'),
                                ),
                              ],
                              onChanged: (value) {
                                partnerController.filterByStatus(value ?? '');
                              },
                            ),
                          ),
                        ],
                      ),
                      isWeb(context)
                          ? Container()
                          : Container(
                              child: getEntryWidget(context),
                              margin: EdgeInsets.only(top: 15.h),
                            ),
                      getVerticalSpace(context, 25),
                       partnerController.obx(
                        (state) => Obx(
                          () {
                            double i = state!.length / 10;
                            int d = state.length -
                                (totalItem.value * i.toInt()).toInt();

                            if (d > 0) {
                              i = i + 1;
                            }

                            List<Partner> paginationList = [];

                            paginationList = state
                                .skip(position.value * totalItem.value)
                                .take(totalItem.value)
                                .toList();

                            return paginationList.length > 0
                                ? Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        isWeb(context)
                                            ? PartnerWebWidget(
                                                list: paginationList,
                                                queryText: queryText,
                                                function: (detail, model) {
                                                  _showPopupMenu(
                                                      context, detail, model);
                                                },
                                                onTapStatus: (model) {
                                                  updateStatus(context, model);
                                                },
                                                onRegenerateApiKey: (model) {
                                                  partnerController
                                                      .regenerateApiKey(model);
                                                },
                                              )
                                            : PartnerMobileWidget(
                                                list: paginationList,
                                                queryText: queryText,
                                                function: (detail, model) {
                                                  _showPopupMenu(
                                                      context, detail, model);
                                                },
                                                onTapStatus: (model) {
                                                  updateStatus(context, model);
                                                },
                                                onRegenerateApiKey: (model) {
                                                  partnerController
                                                      .regenerateApiKey(model);
                                                },
                                              ),
                                        getVerticalSpace(context,
                                            (getCommonPadding(context) / 2)),
                                        Container(
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
                                                ),
                                                getHorizontalSpace(context, 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: List.generate(
                                                          i.toInt(),
                                                          (index) => InkWell(
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5.h),
                                                                  height: 35.h,
                                                                  width: 35.h,
                                                                  decoration: getDefaultDecoration(
                                                                      bgColor: position.value ==
                                                                              index
                                                                          ? getPrimaryColor(
                                                                              context)
                                                                          : Colors
                                                                              .transparent,
                                                                      radius: getResizeRadius(
                                                                          context,
                                                                          15)),
                                                                  child: Center(
                                                                    child: getTextWidget(
                                                                        context,
                                                                        '${index + 1}',
                                                                        50,
                                                                        position.value ==
                                                                                index
                                                                            ? Colors.white
                                                                            : subPrimaryColor(context)),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  position.value =
                                                                      index;
                                                                  _controller
                                                                      .jumpTo(
                                                                          0);
                                                                },
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                                getHorizontalSpace(context, 10),
                                                InkWell(
                                                  onTap: () {
                                                    if (position.value <
                                                        (i.toInt() - 1)) {
                                                      position.value =
                                                          position.value + 1;
                                                    }
                                                  },
                                                  child: getSvgImage1(
                                                    'right.svg',
                                                    height: 18.h,
                                                    width: 18.h,
                                                  ),
                                                ),
                                                getHorizontalSpace(context, 25),
                                                Expanded(child: Container())
                                              ],
                                            ).marginOnly(
                                                right:
                                                    getCommonPadding(context)),
                                          ),
                                        ),
                                        getVerticalSpace(context,
                                            (getCommonPadding(context) / 2)),
                                      ],
                                    ),
                                  )
                                : Center(child: getNoData(context));
                          },
                        ),
                        onError: (error) => Center(
                            child: Column(
                          children: [
                            getTextWidget(
                                context, error!, 50, getFontColor(context),
                                fontWeight: FontWeight.w500),
                            getVerticalSpace(context, 10),
                          ],
                        )),
                        onEmpty: Center(child: getNoData(context)),
                        onLoading: getProgressWidget(context),
                      ), 
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateStatus(BuildContext context, Partner partner) {
    String action = partner.status == 'active' ? 'désactiver' : 'activer';
    getCommonDialog(
        context: context,
        title: 'Voulez-vous $action ce partenaire?',
        function: () {
          if (partner.status == 'active') {
            partnerController.deactivatePartner(partner);
          } else {
            partnerController.activatePartner(partner);
          }
        },
        subTitle: 'Partenaire');
  }

  _showPopupMenu(BuildContext context, Offset detail, Partner partner) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
           detail & Size(0.h, 0.h), // smaller rect, the touch area
          Offset.zero & overlay!.size),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: ThemeController().checkDarkTheme()
          ? getBackgroundColor(context)
          : getCardColor(context),
      items: [
        PopupMenuItem<String>(
          child: Container(
            child: MenuItem(
              title: "Modifier",
              space: 0,
            ),
          ),
          onTap: () {
            setState(() {
              partnerController.setPartnerForEdit(partner);
             
            });
          },
          value: 'Modifier',
        ),
        PopupMenuItem<String>(
          child: Container(
            child: MenuItem(
              title: "Régénérer API Key",
              space: 0,
            ),
          ),
          onTap: () {
            partnerController.regenerateApiKey(partner);
          },
          value: 'Régénérer API Key',
        ),
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
                  title: 'Voulez-vous supprimer ce partenaire?',
                  function: () async {
                    partnerController.deletePartner(partner);
                  },
                  subTitle: 'Supprimer');
            },
            value: 'Supprimer'),
      ],
      elevation: 1,
    );
  }

  getEntryWidget(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getTextWidget(context, 'Afficher', 50, getFontColor(context),
                fontWeight: FontWeight.w500),
            getHorizontalSpace(context, 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: getDefaultDecoration(
                bgColor: getCardColor(context),
                borderColor: getBorderColor(context),
                borderWidth: 1,
                radius: getDefaultRadius(context),
              ),
              child: DropdownButton<int>(
                value: totalItem.value,
                underline: Container(),
                items: [5, 10, 25, 50].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                onChanged: (value) {
                  totalItem(value!);
                },
              ),
            ),
            getHorizontalSpace(context, 15),
            getTextWidget(context, 'entrées', 50, getFontColor(context),
                fontWeight: FontWeight.w500),
          ],
        ));
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
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
