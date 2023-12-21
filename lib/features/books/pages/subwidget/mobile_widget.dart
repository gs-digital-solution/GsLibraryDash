
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';


// ignore: must_be_immutable
class MobileWidget extends StatelessWidget{

  var _tapPosition;
  MobileWidget({required this.list,required this.queryText,required this.function,required this.onTapStatus,required this.mainList});
  final List<Book> list;
  final List<Book> mainList;
  final RxString queryText;
  final Function(Offset,Book) function;
  final Function onTapStatus;


  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: ListView(
        children: [
          SingleChildScrollView(
              scrollDirection:
              Axis.horizontal,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  getHeaderWidget(
                      context),

                  Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: List.generate(
                          list.length,
                              (index) {
                          return  Obx(() {

                            bool cell =false;

                                          if (queryText.value.isNotEmpty &&
                                              !list[index].nom!.toLowerCase().contains(queryText.value)) {
                                            cell = false;
                                          }

                                          return cell
                                              ? Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
                                                child: Row(
                                                  children: [
                                                    getSubCell('${mainList.indexOf(list[index])+1}', context, 80),
                                                    Container(
                                                          child: Row(
                                                            children: [
                                                             
                                                              SizedBox(
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
                                                                          list[index].avatar!.url!),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            
                                                            ],
                                                          ),
                                                        ),

                                                    

                                                    getSubCell('${list[index].nom!}', context, 200),
                                                    Container(
                                                            child: Row(
                                                              children: [
                                                                getHeaderCell
                                                                  (
                                                                    '${list[index].author!.firstname.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                                    context,
                                                                    200),
                                                              ],
                                                            ),
                                                          ),

                                                    
                                                    getActiveDeActiveCell(
                                                        context,
                                                        list[index].status!, list[index]),

                                                    Container(
                                                      width: 80.h,
                                                      alignment: Alignment.centerLeft,
                                                      child: GestureDetector(
                                                          onTapDown: _storePosition,
                                                          onTap: () {

                                                           
                                                          },
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: getSubFontColor(context),
                                                            size: 25.h,
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned.fill(child: Align(alignment: Alignment.bottomLeft,
                                                child: Divider(
                                                  height: 0.5,
                                                  color: cell?getBorderColor(context):Colors.transparent,
                                                ).marginSymmetric(vertical: 4.h),))
                                            ],
                                          )
                                              : Container();
                                        });
                          
                          }))
                ],
              ))
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
  getActiveDeActiveCell(BuildContext context, bool isActive,Book model) {
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
          getHeaderCell('ID', context, 80),
          getHeaderCell('Category', context, 130),
          getHeaderCell( 'Image',context,100),
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