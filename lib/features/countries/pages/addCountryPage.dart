import 'package:country_picker/country_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/countries/controller/country_controller.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/controllers/exchange_rate_controller.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';

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
      final ExchangeRateController exchangeRateController =
        Get.put(ExchangeRateController());

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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle('Selectionner un pays ', context),
                                getVerticalSpace(context, 10),
                                TextFormField(
                                  controller: newCommandeController.name,
                                  decoration: InputDecoration(
                                    prefix: Obx(
                                      () => Text(
                                        "+ ${newCommandeController.countryCode.value} ",
                                      ),
                                    ),
                                  ),
                                  onTap: () => picker.showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (value) {
                                      newCommandeController.name.text =
                                          value.nameLocalized!;
                                      newCommandeController.countryFlag.value =
                                          value.countryCode;
                                      newCommandeController.countryCode.value =
                                          value.phoneCode;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            getVerticalSpace(context, 30),
                             Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Monnaie', context),
                                              getVerticalSpace(context, 10),
                                              DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    left: 10.h,
                                                  ),
                                                  border: InputBorder.none,

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                            color:
                                                                getPrimaryColor(
                                                                    context),
                                                          )),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                            color: borderColor,
                                                          )),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                            color: borderColor,
                                                          )),

                                                  filled: true,
                                                  fillColor:
                                                      getCardColor(context),
                                                  // fillColor: getReportColor(context),
                                                  focusColor: Colors.green,
                                                  hintText: "Choix de monnaie",
                                                  isDense: false,
                                                  hintStyle: TextStyle(
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      color: getSubFontColor(
                                                          context),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15),
                                                ),
                                                items: isEdit
                                                    ? [
                                                        DropdownMenuItem(
                                                          child: Text(
                                                              newCommandeController
                                                                  .currency),
                                                          value: newCommandeController
                                                              .currency,
                                                        ),
                                                        ...exchangeRateController
                                                            .exchangeRates
                                                            .toSet().toList()
                                                            .where((category) =>
                                                                category
                                                                    .countryFrom !=
                                                                newCommandeController
                                                                    .currency)
                                                            .map(
                                                              (element) =>
                                                                  DropdownMenuItem(
                                                                value: element
                                                                    .countryFrom,
                                                                child: Text(
                                                                  element
                                                                      .countryFrom!,
                                                                ),
                                                              ),
                                                            )
                                                            .toList()
                                                      ]
                                                    : exchangeRateController
                                                        .exchangeRates
                                                        .toSet().toList()
                                                        .map(
                                                          (element) =>
                                                              DropdownMenuItem(
                                                            value: element
                                                                .countryFrom,
                                                            child: Text(
                                                              element
                                                                  .countryFrom!,
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  newCommandeController.currency =
                                                      value!;
                                                },
                                                value: newCommandeController.currency,
                                              ),
                                            ],
                                          ),
                                        ),
                           
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
                                            .addCategory()
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
