import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/controllers/exchange_rate_controller.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/models/exchange_rate.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

class AddExchangeRatePage extends StatefulWidget {
  final ExchangeRate? exchangeRate;

  AddExchangeRatePage({this.exchangeRate});

  @override
  State<AddExchangeRatePage> createState() => _AddExchangeRatePageState();
}

class _AddExchangeRatePageState extends State<AddExchangeRatePage> {
  final ExchangeRateController exchangeRateController =
      Get.put(ExchangeRateController());

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = exchangeRateController.exchangeRate != null;

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
                    isEdit
                        ? 'Mettre a jour le taux d\'echange'
                        : 'Ajouter un taux d\'echange',
                    75,
                    getFontColor(context),
                    fontWeight: FontWeight.w700),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      exchangeRateController.clearData();
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
                                itemSubTitle('Pays Entrant', context),
                                getVerticalSpace(context, 10),
                                getTextFiledWidget(
                                  context,
                                  "Entrer la devise du pays sortant",
                                  exchangeRateController.countryFrom,
                                  validator: (value) => value.isEmpty
                                      ? "Devise obligatoire"
                                      : null,
                                ),
                              ],
                            ),
                            getVerticalSpace(context, 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle('Pays sortant', context),
                                getVerticalSpace(context, 10),
                                getTextFiledWidget(
                                  context,
                                  "Entrer la monnaie du pays sortant",
                                  exchangeRateController.countryTo,
                                  validator: (value) => value.isEmpty
                                      ? "Devise obligatoire"
                                      : null,
                                ),
                              ],
                            ),
                            getVerticalSpace(context, 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle('Taux d\'echanges', context),
                                getVerticalSpace(context, 10),
                                getTextFiledWidget(
                                  context,
                                  "Entrer la valeur du taux d'echange",
                                  exchangeRateController.rate,
                                  validator: (value) =>
                                      value.isEmpty ? "Taux obligatoire" : null,
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
                                      exchangeRateController.loading.value,
                                  () {
                                    if (!isEdit) {
                                      if (formKey.currentState!.validate()) {
                                        exchangeRateController
                                            .createExchangeRate()
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        exchangeRateController
                                            .updateExchangeRate()
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
                                exchangeRateController.loading.value = false;
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
