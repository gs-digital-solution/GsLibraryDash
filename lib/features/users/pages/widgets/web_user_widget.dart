import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';

import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

// ignore: must_be_immutable
class UserWebWidget extends StatelessWidget {
  UserWebWidget(
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
                                Expanded(
                                  child: getHeaderCell(
                                    '${mainList.indexOf(list[index]) + 1}',
                                    context,
                                    80,
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: getHeaderTitle(
                                        context, list[index].firstname!)),
                                Expanded(
                                    flex: 1,
                                    child: getHeaderTitle(
                                        context, list[index].lastname!)),
                                Expanded(
                                    child: SizedBox(
                                  width: 130,
                                  child: SelectableText(
                                    '${list[index].country!['countryCode']} ${list[index].phonenumber}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                                Expanded(
                                    child: SizedBox(
                                  width: 130,
                                  child: SelectableText(
                                    '${list[index].country!['name']}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                                Expanded(
                                    child: getHeaderCell(
                                        '${list[index].deviceId} ',
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
      child: getMaxLineFont(
        context,
        string,
        45,
        color,
        1,
        fontWeight: FontWeight.w400,
        textAlign: TextAlign.start,
      ),
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
          Expanded(child: getHeaderCell('Nom', context, 80)),
          Expanded(child: getHeaderCell('Prenom', context, 130)),
          Expanded(child: getHeaderCell('Telephone', context, 100)),
          Expanded(child: getHeaderCell('Pays', context, 130)),
          Expanded(
            flex: 1,
            child: getHeaderCell('Device Id', context, 100),
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
