import 'package:country_picker/country_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:gslibrarydashboard/common/common.dart';

import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/countries/controller/country_controller.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/promos/controller/promocontroller.dart';

import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

class AddCountryPage extends StatefulWidget {
  final Country? categoryModel;

  AddCountryPage({this.categoryModel});

  @override
  State<AddCountryPage> createState() => _AddCountryPageState();
}

class _AddCountryPageState extends State<AddCountryPage> {


  final CountryController newCommandeController = Get.put(CountryController());

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = newCommandeController.country != null;

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
                    isEdit ? 'Mettre a jour le Pays' : 'Ajouter un Pays',
                    75,
                    getFontColor(context),
                    fontWeight: FontWeight.w700),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      newCommandeController.clearData();
                    });
                  },
                  child: Text(
                    'Supprimer le formulaire',
                    style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            getVerticalSpace(context, 35),
            Expanded(
              child: getCommonContainer(
                context: context,
                verSpace: 0,
                horSpace: isWeb(context) ? null : 15.h,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView(
                          children: [
                            getVerticalSpace(context, 30),
                            isEdit
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemSubTitle(
                                          'Selectionner un pays ', context),
                                      getVerticalSpace(context, 10),
                                      TextFormField(
                                        controller: newCommandeController.name,
                                        decoration: InputDecoration(
                                          prefix: Obx(
                                            () => Text(
                                              "+ ${newCommandeController
                                                  .countryCode.value} ",
                                            ),
                                          ),
                                        ),
                                        onTap: () => picker.showCountryPicker(
                                          context: context,
                                          showPhoneCode: true,
                                          onSelect: (value) {
                                            newCommandeController.name.text =
                                                value.name;
                                            newCommandeController.countryFlag
                                                .value = value.countryCode;
                                            newCommandeController.countryCode
                                                .value = value.phoneCode;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                            getVerticalSpace(context, 30),
                            getVerticalSpace(context, 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle('SERVICE CODE', context),
                                getVerticalSpace(context, 10),
                                getTextFiledWidget(
                                  context,
                                  "Entrer le service Code",
                                  newCommandeController.serviceCode,
                                 
                                  validator: (value) => value.isEmpty
                                      ? "service Code obligatoire"
                                      : null,
                                ),
                              ],
                            ),
                            getVerticalSpace(context, 30),
                          ],
                        ),
                      ),
                      getVerticalSpace(context, 20),
                      Row(
                        children: [
                          Obx(() => Expanded(
                                child: getButtonWidget(
                                  context,
                                  isEdit ? 'Mettre a jour' : 'Enregistrer',
                                  isProgress:
                                      newCommandeController.isLoading.value,
                                  () {
                                    if (!isEdit) {
                                      if (formKey.currentState!.validate()) {
                                        newCommandeController
                                            .addCategory(
                                          
                                        )
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        newCommandeController
                                            .updatePromo(
                                          promo: newCommandeController.country,
                                        )
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    }
                                  },
                                  horPadding: 25.h,
                                  horizontalSpace: 0,
                                  verticalSpace: 0,
                                  btnHeight: 60.h,
                                ),
                              )),
                          getHorSpace(10.h),
                          Expanded(
                            child: getButtonWidget(
                              context,
                              'Annuler',
                              isProgress: false,
                              () {
                                newCommandeController.isLoading.value = false;
                              },
                              horPadding: 25.h,
                              bgColor: Colors.red,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 60.h,
                            ),
                          ),
                        ],
                      ),
                      getVerticalSpace(context, 20),
                      getVerticalSpace(context, 20),
                    ],
                  ),
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
