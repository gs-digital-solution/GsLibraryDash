
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/author/models/author.dart';
import 'package:gslibrarydashboard/features/investors/models/investorwithsolde.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';

import '../../../theme/color_scheme.dart';


// ignore: must_be_immutable
class InvestorWebWidget extends StatelessWidget{

  var _tapPosition;
  InvestorWebWidget({required this.list,required this.queryText,required this.function,required this.onTapStatus});
  final List<InvestorWithSolde> list;
  final RxString queryText;
  final Function(Offset,InvestorWithSolde) function;
  final Function onTapStatus;


  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);

    return Expanded(
        child: Container(
          child: Column(
            children: [
              getHeaderWidget(
                  context),
              Expanded(
                  child: ListView
                      .builder(
             
                    itemCount:
                    list.length,
                    itemBuilder:
                        (context, index) {

                      return    Obx(() {
                            bool cell = true;

                            if (queryText
                                .value
                                .isNotEmpty &&
                                !list[index].investor!
                                    .firstname!.toLowerCase()
                                    .contains(
                                    queryText
                                        .value)) {
                              cell = false;
                            }
                            return cell
                                ? Stack(
                                  children: [

                                    Container(
                              padding: padding,
                              child: Row(
                                    children: [
                                      // getHeaderCell(
                                      //     '${index + 1}',
                                      //     context,
                                      //     130),

                                      SizedBox(
                                        width: 100.h,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 50.h,
                                          width: 50.h,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius
                                                .circular(50.h / 2),
                                            child: Image(
                                              width: 50.h,
                                              height: 50.h,
                                              image: NetworkImage(list[index].investor!.avatar!.url ?? ""),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      getHorSpace(10.h),
                                      getHeaderCell(
                                          '${list[index].investor!.firstname??""} ${list[index].investor!.lastname??""} ',
                                          context,
                                          200),
                                      getHeaderCell(
                                          '${list[index].investor!.pourcentage??""}',
                                          context,
                                          150),
                                      getHorSpace(10.h),
                                       getHeaderCell(
                                          '${list[index].montantTotalCommandes??""} XAF',
                                          context,
                                          150),
                                      getHorSpace(10.h),
                                       getHeaderCell(
                                          '${list[index].solde??""} XAF',
                                          context,
                                          150),
                                      getHorSpace(10.h),
                                      Expanded(
                                        flex: 1,
                                        child: getMaxLineFont(
                                            context, removeAllHtmlTags(list[index].investor!.investDate!.split("T").first ?? ""),
                                            50, getFontColor(context),
                                            3,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign
                                                .start,txtHeight: 1.5.h),
                                      ),
                                      getHorizontalSpace(context, 10),
                                         Expanded(
                                        flex: 1,
                                        child: getMaxLineFont(
                                            context, removeAllHtmlTags(list[index].investor!.investEndingDate!=null?list[index].investor!.investEndingDate!.split("T").first:"Indeterminée"),
                                            50, Colors.redAccent,
                                            3,
                                            fontWeight: FontWeight.w700,
                                            textAlign: TextAlign
                                                .start,txtHeight: 1.5.h),
                                      ),

                                     /*  SizedBox(
                                        width: 120.h,
                                        child: getActiveDeActiveCell(
                                            context,
                                            list[index].status??false, list[index]),
                                      ), */
                                      Stack(
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
                                                      function(
                                                          _tapPosition, list[index]);
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
                            ),

                                    Positioned.fill(
                                        child:
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Divider(
                                            height: 0.5,
                                            color: cell?getBorderColor(context):Colors.transparent,
                                          ).marginSymmetric(vertical: 4.h),)
                                    )

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

  getActiveDeActiveCell(BuildContext context, bool isActive,TopAuthors authorModel) {
    return InkWell(
      child: Container(
          width: 120.h,
          alignment: Alignment.centerLeft,
          child: getButton(
              context,
              isActive ? 'Active' : 'Deactive',
              isActive ? "#00A010".toColor() : "#FD3E3E".toColor(),
              isActive ? "#E7FFE8".toColor() : "#FFF2F2".toColor())),
      onTap: (){
        onTapStatus(authorModel);
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
          // getHeaderCell('ID', context, 130),
          getHeaderCell('Avatar', context, 100),
          getHeaderCell(
              'Nom & Prenom',
              context,
              200),
          getHeaderCell(
              'Pourcentage'
                  '',
              context,
              150),
          getHeaderCell(
              'Solde GSLIBRARY'
                  '',
              context,
              150),
              getHeaderCell(
              'Solde'
                  '',
              context,
              150),
          getHorSpace(10.h),
          Expanded(child: getHeaderTitle(context, 'Date Investissement')),
           Expanded(child: getHeaderTitle(context, 'Date Cloture Investissement')),
          /* getHeaderCell(
              'Status',
              context,
              120), */
          getHeaderTitle(context, 'Action'),
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