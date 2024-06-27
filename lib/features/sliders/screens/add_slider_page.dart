import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/sliders/controller/slider_controller.dart';
import 'package:gslibrarydashboard/features/sliders/models/slider.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

class AddSliderScreen extends StatefulWidget {
  final SliderModel? categoryModel;

  AddSliderScreen({this.categoryModel});

  @override
  State<AddSliderScreen> createState() => _AddSliderScreenState();
}

class _AddSliderScreenState extends State<AddSliderScreen> {
  final SliderController categoryController = Get.put(SliderController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = categoryController.categoryModel != null;

    return SafeArea(
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
                    context,
                    isEdit ? 'Mettre a jour' : 'Ajouter un slide',
                    75,
                    getFontColor(context),
                    fontWeight: FontWeight.w700),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  onPressed: () {
                    setState(() {
                      categoryController.clearData();
                    });
                  },
                  child: Text('Supprimer le formulaire',style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                ),
              ],
            ),
            getVerticalSpace(context, 35),
            Expanded(
              child: getCommonContainer(
                context: context,
                verSpace: 0,
                horSpace: isWeb(context) ? null : 15.h,
                child: ListView(
                  children: [
                    getVerticalSpace(context, 30),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                        
                          itemSubTitle('Image a selectionner...', context),
                          getVerticalSpace(context, 10),
                          getTextFiledWidget(context, "Aucun fichier selectionne",
                              categoryController.imageController,
                              isEnabled: false,
                              child: getCommonChooseFileBtn(context, () {
                                categoryController.imgFromGallery();
                              })),
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 35),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Obx(() {
                        return (categoryController.isImageOffline.value)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    (getResizeRadius(
                                        context, 35))), //add border radius
                                child: Image.memory(
                                  categoryController.webImage,
                                  height: 200.h,
                                  width: 300.h,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : categoryController.categoryModel != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        (getResizeRadius(
                                            context, 35))), //add border radius
                                    child: Image.network(
                                      categoryController
                                          .categoryModel!.avatar!.url!,
                                      height: 200.h,
                                      width: 300.h,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container();
                      }),
                    ),
                    Obx(() =>
                        (categoryController.isImageOffline.value || isEdit)
                            ? getVerticalSpace(context, 20)
                            : getVerticalSpace(context, 0)),
                    Obx(() => getButtonWidget(
                          context,
                          isEdit ? 'Mettre a jour' : 'Ajouter',
                          isProgress: categoryController.isLoading.value,
                          () {
                            if (isEdit) {
                              categoryController.updateCategory(
                                  model: categoryController.categoryModel);
                            } else {
                              categoryController.addCategory();
                            }
                          },
                          horPadding: 25.h,
                          horizontalSpace: 0,
                          verticalSpace: 0,
                          btnHeight: 60.h,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  itemSubTitle(String s, BuildContext context) {
    return getTextWidget(
      context,
      s,
      50,
      getFontColor(context),
      fontWeight: FontWeight.w500,
    );
  }
}
