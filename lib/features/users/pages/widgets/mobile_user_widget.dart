import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';

import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

// ignore: must_be_immutable
class UserMobileWidget extends StatelessWidget {
 
  UserMobileWidget(
      {required this.list,
      required this.queryText,
      required this.function,
      required this.onTapStatus,
      required this.mainList});
  final List<User> list;
  final List<User> mainList;
  final RxString queryText;
  final Function(Offset, User) function;
  final Function onTapStatus;

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
                                .phonenumber!
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
                                        getSubCell('${list[index].firstname!}',
                                            context, 200),
                                        getSubCell('${list[index].lastname!}',
                                            context, 200),
                                        getSubCell(
                                            '${list[index].phonenumber!}',
                                            context,
                                            200),
                                        Expanded(
                                          child: getSubCell(
                                              '${list[index].deviceId!}',
                                              context,
                                              200),
                                        ),
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
                                      ],
                                    ),
                                  ),
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

/*   void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  } */

  getSubCell(String title, BuildContext context, double width) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: getSubTitle(context, title));
  }

  getActiveDeActiveCell(BuildContext context, bool isActive, Book model) {
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
        onTapStatus(model);
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
          getHeaderCell('Firstname', context, 80),
          getHeaderCell('Lastname', context, 130),
          getHeaderCell('Telephone', context, 100),
          getHeaderCell('DeviceId', context, 200),
          getHeaderCell('Date', context, 200),
          getHeaderCell('Heure', context, 120),
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
