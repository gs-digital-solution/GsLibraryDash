import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';


import 'package:gslibrarydashboard/features/history/controller/history_controller.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/controllers/transfert_demand_controller.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/models/transfert.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

// ignore: must_be_immutable
class TransfertWidgetWeb extends StatelessWidget {
  
  TransfertWidgetWeb(
      {required this.list,
      required this.queryText,
      required this.function,
      required this.onTapStatus,
      required this.controller,
      required this.mainList});
  final List<TransfertDevice> list;
  final List<TransfertDevice> mainList;
  final RxString queryText;
  final Function(Offset, TransfertDevice) function;
  final Function onTapStatus;
  final TransfertDemandController? controller;

  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);

    return Expanded(
        child: Container(
      child: Column(
        children: [
          getHeaderWidget(context),
          Expanded(
              child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Obx(() {
                bool cell = true;

                if (queryText.value.isNotEmpty &&
                    !list[index]
                        .user!
                        .phonenumber!
                        .toLowerCase()
                        .contains(queryText.value)) {
                  cell = false;
                }
                return cell
                    ? Stack(
                        children: [
                          Container(
                            padding: padding,
                            child: Row(
                              children: [
                                getHeaderCell(
                                  '${mainList.indexOf(list[index]) + 1}',
                                  context,
                                  30,
                                ),
                                getHorSpace(10.h),
                                Expanded(
                                    flex: 1,
                                    child: getHeaderTitle(
                                        context, list[index].user!.firstname!)),
                                Expanded(
                                    child: SizedBox(
                                  width: 130,
                                  child: SelectableText(
                                    '${list[index].user!.phonenumber}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].user!.deviceId} ',
                                        context,
                                        130)),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].newDeviceId} ',
                                        context,
                                        130)),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].createdAt!.split('T').first}',
                                        context,
                                        130)),
                                Expanded(
                                  child: getHeaderCell(
                                    '${list[index].requestCount}',
                                    context,
                                    130,
                                  ),
                                ),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      switch (list[index].status!.value) {
                                        case 0:
                                          return getCustomFont(
                                            "En cours",
                                            12.sp,
                                            Colors.orange,
                                            1,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                          );

                                        case 1:
                                          return getCustomFont(
                                            "Acceptee",
                                            12.sp,
                                            Colors.green,
                                            1,
                                            fontWeight: FontWeight.bold,
                                             textAlign: TextAlign.center,
                                          );

                                        default:
                                          return getCustomFont(
                                            "Refusee",
                                            12.sp,
                                            Colors.red,
                                            1,
                                            fontWeight: FontWeight.bold,
                                             textAlign: TextAlign.center,
                                          );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: PopupMenuButton<int>(
                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: getCustomFont(
                                          "Confirmer",
                                          18.sp,
                                          Colors.green,
                                          1,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: getCustomFont(
                                          "Rejeter",
                                          18.sp,
                                          Colors.red,
                                          1,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 3,
                                        child: getCustomFont(
                                          "Historique",
                                          18.sp,
                                          Colors.orange,
                                          1,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    ],
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 3:
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                GetBuilder<HistoryController>(
                                              init: HistoryController(
                                                userId: list[index].user!.sId,
                                              ),
                                              builder: (controller) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: getCustomFont(
                                                                  "Device Id",
                                                                  12.sp,
                                                                  Colors.black,
                                                                  1)),
                                                          Expanded(
                                                              child:
                                                                  getCustomFont(
                                                                      "Date",
                                                                      12.sp,
                                                                      Colors
                                                                          .black,
                                                                      1)),
                                                          Expanded(
                                                              child:
                                                                  getCustomFont(
                                                                      "Heure",
                                                                      12.sp,
                                                                      Colors
                                                                          .black,
                                                                      1)),
                                                        ],
                                                      ),
                                                      Divider(),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      controller.obx(
                                                        (state) => Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    Container(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: getCustomFont(
                                                                            state[index].deviceId ??
                                                                                "",
                                                                            12.sp,
                                                                            Colors.black,
                                                                            1,
                                                                            fontWeight: FontWeight.bold)),
                                                                    Expanded(
                                                                        child: getCustomFont(
                                                                            state[index].createdAt!.split("T").first,
                                                                            12.sp,
                                                                            Colors.black,
                                                                            1,
                                                                            fontWeight: FontWeight.bold)),
                                                                    Expanded(
                                                                        child: getCustomFont(
                                                                            state[index].createdAt!.split("T").last.split(".").first,
                                                                            12.sp,
                                                                            Colors.black,
                                                                            1,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            itemCount:
                                                                state!.length,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                          break;
                                        case 2:
                                          if (await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            routeSettings: RouteSettings(),
                                            builder: (context) => WillPopScope(
                                              onWillPop: () async {
                                                return false;
                                              },
                                              child: Dialog(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  width: Get.width / 3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Confirmez le rejet de cette demande?",
                                                        style: TextStyle(
                                                          fontFamily: Constants
                                                              .fontsFamily,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: Text(
                                                              'Oui',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                            child: Text(
                                                              'Non',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )) {
                                            controller?.cancelTransfert(
                                                transfertDevice: list[index],
                                                context: context);
                                          }
                                        default:
                                          if (await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            routeSettings: RouteSettings(),
                                            builder: (context) => WillPopScope(
                                              onWillPop: () async {
                                                return false;
                                              },
                                              child: Dialog(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  width: Get.width / 3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Confirmez la validation de cette demande?",
                                                        style: TextStyle(
                                                          fontFamily: Constants
                                                              .fontsFamily,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: Text(
                                                              'Oui',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                            child: Text(
                                                              'Non',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )) {
                                            controller?.validateTransfert(
                                                transfertDevice: list[index],
                                                context: context);
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container();
              });
            },
          ))
        ],
      ),
    ));
  }

/*   void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  } */

  getActiveDeActiveCell(BuildContext context, bool isActive) {
    return Container(
        width: 120.h,
        alignment: Alignment.centerLeft,
        child: getButton(
            context,
            isActive ? 'Payée' : 'Non Payée',
            isActive ? "#00A010".toColor() : "#FD3E3E".toColor(),
            isActive ? "#E7FFE8".toColor() : "#FFF2F2".toColor()));
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

  getHeaderWidget(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);
    var decoration =
        getDefaultDecoration(bgColor: getReportColor(context), radius: 0);
    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        children: [
          getHeaderCell('ID', context, 30),
          getHorSpace(10.h),
          Expanded(child: getHeaderCell('Nom', context, 80)),
          Expanded(child: getHeaderCell('Telephone', context, 80)),
          Expanded(child: getHeaderCell('Ancien Device', context, 100)),
          Expanded(
            flex: 1,
            child: getHeaderCell('Nouveau Device', context, 100),
          ),
          Expanded(
              child: getHeaderCell(
                  'Date'
                  '',
                  context,
                  120)),
          Expanded(
              child: getHeaderCell(
                  'Numero demande'
                  '',
                  context,
                  120)),
          Expanded(
              child: getHeaderCell(
                  'Status'
                  '',
                  context,
                  120)),
          Expanded(
              child: getHeaderCell(
                  ''
                  '',
                  context,
                  120)),
        ],
      ),
    );
  }

  getHeaderCell(String title, BuildContext context, double width) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: getHeaderTitle(context, title));
  }

  getHeaderTitle(BuildContext context, String title) {
    return getMaxLineFont(context, title, 45, getFontColor(context), 1,
        fontWeight: FontWeight.w600, textAlign: TextAlign.start);
  }
}
