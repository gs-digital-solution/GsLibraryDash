import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';

import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

// ignore: must_be_immutable
class CommandeWebWidget extends StatelessWidget {
  var _tapPosition;
  CommandeWebWidget(
      {required this.list,
      required this.queryText,
      required this.function,
      required this.onTapStatus,
      required this.mainList});
  final List<Commande> list;
  final List<Commande> mainList;
  final RxString queryText;
  final Function(Offset, Commande) function;
  final Function onTapStatus;

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
                        .book!
                        .nom!
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
                                Expanded(
                                    child: getHeaderCell(
                                        '${mainList.indexOf(list[index]) + 1}',
                                        context,
                                        80)),
                                Expanded(
                                    child: SizedBox(
                                  width: 100.h,
                                  child: Container(
                                    height: 50.h,
                                    width: 75.h,
                                    alignment: Alignment.centerLeft,
                                    child: ClipRRect(
                                      // borderRadius: BorderRadius
                                      //     .circular(10.r),
                                      child: Image(
                                        image: NetworkImage(
                                            list[index].book!.avatar!.url!),
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    flex: 1,
                                    child: getHeaderTitle(
                                        context, '${list[index].book!.nom}')),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].author!.firstname ?? ""} ',
                                        context,
                                        130)),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].user!.phonenumber} ',
                                        context,
                                        130)),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].montant} FCFA',
                                        context,
                                        130)),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].createdAt!.split('T').first}',
                                        context,
                                        130)),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].createdAt!.split('T').last.split('.').first}',
                                        context,
                                        130)),
                                /* Stack(
                                  children: [
                                    getMaxLineFont(context, 'Action', 50,
                                        Colors.transparent, 1,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),
                                    Positioned.fill(
                                        child: Center(
                                      child: GestureDetector(
                                          onTapDown: _storePosition,
                                          onTap: () {
                                            function(_tapPosition, list[index]);
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: getSubFontColor(context),
                                          )),
                                    ))
                                  ],
                                ) */
                              ],
                            ),
                          ),
                          /* Positioned.fill(
                              child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Divider(
                              height: 0.5,
                              color: cell
                                  ? getBorderColor(context)
                                  : Colors.transparent,
                            ).marginSymmetric(vertical: 4.h),
                          )) */
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

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  getActiveDeActiveCell(BuildContext context, bool isActive, Book storyModel) {
    return InkWell(
      child: Container(
          width: 120.h,
          alignment: Alignment.centerLeft,
          child: getButton(
              context,
              isActive ? 'Active' : 'Deactive',
              isActive ? "#00A010".toColor() : "#FD3E3E".toColor(),
              isActive ? "#E7FFE8".toColor() : "#FFF2F2".toColor())),
      onTap: () {
        onTapStatus(storyModel);
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

  getHeaderWidget(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);
    var decoration =
        getDefaultDecoration(bgColor: getReportColor(context), radius: 0);
    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        children: [
          Expanded(child: getHeaderCell('ID', context, 80)),
          Expanded(child: getHeaderCell('image', context, 130)),
          Expanded(child: getHeaderCell('Livre', context, 100)),
          Expanded(
            flex: 1,
            child: getHeaderCell('Author', context, 100),
          ),
          Expanded(flex: 1, child: getHeaderTitle(context, 'client')),
          Expanded(
            flex: 1,
            child: getHeaderCell('Price', context, 100),
          ),
          Expanded(
              child: getHeaderCell(
                  'Date'
                  '',
                  context,
                  120)),
          Expanded(
              child: getHeaderCell(
                  'Heure'
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
