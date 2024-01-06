import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/commandes/model/commande.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

// ignore: must_be_immutable
class RetraitMobileWidget extends StatelessWidget {
  var _tapPosition;
  RetraitMobileWidget(
      {required this.list,
      required this.queryText,
      required this.function,
     
      required this.mainList});
  final List<Retrait> list;
  final List<Retrait> mainList;
  final RxString queryText;
  final Function(Offset, Retrait) function;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getHeaderWidget(context),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(list.length, (index) {
                      return Obx(() {
                        bool cell = false;

                        if (queryText.value.isNotEmpty &&
                            !list[index]
                                .author!
                                .firstname!
                                .toLowerCase()
                                .contains(queryText.value)) {
                          cell = false;
                        }

                        return cell
                            ? Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 25.h),
                                    child: Row(
                                      children: [
                                        getSubCell(
                                            '${mainList.indexOf(list[index]) + 1}',
                                            context,
                                            80),
                                  
                                        getSubCell(
                                            '${list[index].author!.lastname!}',
                                            context,
                                            200),
                                        Container(
                                          child: Row(
                                            children: [
                                              getHeaderCell(
                                                  '${list[index].montant}',
                                                  context,
                                                  200),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 80.h,
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                              onTapDown: _storePosition,
                                              onTap: () {},
                                              child: Icon(
                                                Icons.more_vert,
                                                color: getSubFontColor(context),
                                                size: 25.h,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Divider(
                                      height: 0.5,
                                      color: cell
                                          ? getBorderColor(context)
                                          : Colors.transparent,
                                    ).marginSymmetric(vertical: 4.h),
                                  ))
                                ],
                              )
                            : Container();
                      });
                    }))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  getSubCell(String title, BuildContext context, double width) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: getSubTitle(context, title));
  }

  getActiveDeActiveCell(BuildContext context, bool isActive, Retrait model) {
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
  //  onTapStatus(model);
      },
    );
  }

  getSubTitle(BuildContext context, String title) {
    return getMaxLineFont(context, title, 45, getFontColor(context), 1,
        fontWeight: FontWeight.w400, textAlign: TextAlign.start);
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
    var decoration =
        getDefaultDecoration(bgColor: getReportColor(context), radius: 0);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      decoration: decoration,
      height: 55.h,
      child: Row(
        // scrollDirection: Axis.horizontal,
        // physics: NeverScrollableScrollPhysics(),
        children: [
          getHeaderCell('ID', context, 80),
          getHeaderCell('Category', context, 130),
          getHeaderCell('Image', context, 100),
          getHeaderCell('Book Title', context, 200),
          getHeaderCell('Author', context, 200),
          getHeaderCell('Book Status', context, 120),
          getHeaderCell('Action', context, 80),
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
