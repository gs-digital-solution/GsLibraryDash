import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/countries/controller/country_controller.dart';
import 'package:gslibrarydashboard/features/countries/models/country.dart';
import 'package:gslibrarydashboard/features/payment_methods/controller/payment_method_controller.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:searchfield/searchfield.dart';

class AddPaymentMethodPage extends StatefulWidget {
  final Country? categoryModel;
  AddPaymentMethodPage({this.categoryModel});

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final PaymentMethodController newCommandeController = Get.put(
    PaymentMethodController(),
  );
  final CountryController countryController = Get.put(CountryController());
  final formKey = GlobalKey<FormState>();

  String selectedProvider = 'touchpay';

  final List<Map<String, String>> providers = [
    {'value': 'touchpay', 'label': 'TouchPay'},
    {'value': 'campay', 'label': 'CamPay'},
    {'value': 'ikeepay', 'label': 'IkeePay'},
    {'value': 'leekpay', 'label': 'LeekPay'},
  ];

  bool get needsUssdCode =>
      selectedProvider == 'touchpay' || selectedProvider == 'campay';
  bool get needsServiceCode => selectedProvider == 'touchpay';
  bool get needsCashIn => selectedProvider == 'touchpay';

  @override
  void initState() {
    super.initState();
    selectedProvider = newCommandeController.provider.value.isEmpty
        ? 'touchpay'
        : newCommandeController.provider.value;
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = newCommandeController.country != null;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getDefaultHorSpace(context),
          vertical: getDefaultHorSpace(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                  context,
                  isEdit
                      ? 'Mettre a jour la methode de paiement'
                      : 'Ajouter une methode de paiement',
                  75,
                  getFontColor(context),
                  fontWeight: FontWeight.w700,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      newCommandeController.clearData();
                      selectedProvider = 'touchpay';
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

                            // Sélection du pays
                            isEdit
                                ? SizedBox()
                                : countryController.obx(
                                    (state) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle(
                                          'Selectionner un pays',
                                          context,
                                        ),
                                        getVerticalSpace(context, 10),
                                        SearchField<Country>(
                                          suggestions: countryController
                                              .countries
                                              .map(
                                                (
                                                  e,
                                                ) => SearchFieldListItem<Country>(
                                                  e.name!.value,
                                                  item: e,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Text(
                                                      e.name! +
                                                          " (${e.countryCode})",
                                                      style: TextStyle(
                                                        fontFamily: Constants
                                                            .fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onSuggestionTap: (college) {
                                            newCommandeController
                                                    .countryId
                                                    .value =
                                                college.item!.id!;
                                            newCommandeController
                                                    .countryName
                                                    .text =
                                                college.item!.name!.value;
                                          },
                                          suggestionStyle: TextStyle(
                                            fontFamily: Constants.fontsFamily,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          searchStyle: TextStyle(
                                            fontFamily: Constants.fontsFamily,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          validator: (value) => value!.isEmpty
                                              ? "Pays requis"
                                              : null,
                                          controller:
                                              newCommandeController.countryName,
                                          suggestionState: Suggestion.expand,
                                          textInputAction: TextInputAction.next,
                                          searchInputDecoration:
                                              InputDecoration(
                                                labelText: 'Rechercher un pays',
                                                border: OutlineInputBorder(),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                            getVerticalSpace(context, 30),

                            // Nom de la méthode
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle(
                                  'Nom de la methode de paiement',
                                  context,
                                ),
                                getVerticalSpace(context, 10),
                                getTextFiledWidget(
                                  context,
                                  "Entrer le nom",
                                  newCommandeController.name,
                                  validator: (value) =>
                                      value.isEmpty ? "Nom obligatoire" : null,
                                ),
                              ],
                            ),

                            getVerticalSpace(context, 30),

                            // Dropdown Provider
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle('Provider de paiement', context),
                                getVerticalSpace(context, 10),
                                DropdownButtonFormField<String>(
                                  value: selectedProvider,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                  items: providers
                                      .map(
                                        (p) => DropdownMenuItem<String>(
                                          value: p['value'],
                                          child: Text(
                                            p['label']!,
                                            style: TextStyle(
                                              fontFamily: Constants.fontsFamily,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedProvider = value!;
                                      newCommandeController.provider.value =
                                          value;
                                      // Vider les champs non nécessaires
                                      if (!needsUssdCode)
                                        newCommandeController.ussCode.clear();
                                      if (!needsServiceCode)
                                        newCommandeController.serviceCode
                                            .clear();
                                      if (!needsCashIn)
                                        newCommandeController.cashIn.clear();
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? "Provider obligatoire"
                                      : null,
                                ),
                              ],
                            ),

                            getVerticalSpace(context, 30),

                            // USSD CODE — uniquement pour TouchPay et CamPay
                            if (needsUssdCode)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle('USSD CODE', context),
                                  getVerticalSpace(context, 10),
                                  getTextFiledWidget(
                                    context,
                                    "Entrer le USSD CODE",
                                    newCommandeController.ussCode,
                                    validator: (value) => value.isEmpty
                                        ? "ussdCode obligatoire"
                                        : null,
                                  ),
                                  getVerticalSpace(context, 30),
                                ],
                              ),

                            // SERVICE CODE — uniquement pour TouchPay
                            if (needsServiceCode)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle('SERVICE CODE', context),
                                  getVerticalSpace(context, 10),
                                  getTextFiledWidget(
                                    context,
                                    "Entrer le SERVICE CODE",
                                    newCommandeController.serviceCode,
                                    validator: (value) => value.isEmpty
                                        ? "service Code obligatoire"
                                        : null,
                                  ),
                                  getVerticalSpace(context, 30),
                                ],
                              ),

                            // CODE CASHIN — uniquement pour TouchPay
                            if (needsCashIn)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle('CODE CASHIN', context),
                                  getVerticalSpace(context, 10),
                                  getTextFiledWidget(
                                    context,
                                    "Entrer le CODE CASHIN",
                                    newCommandeController.cashIn,
                                    validator: (value) => value.isEmpty
                                        ? "Code obligatoire"
                                        : null,
                                  ),
                                  getVerticalSpace(context, 30),
                                ],
                              ),

                            // PRIORITY
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                itemSubTitle(
                                  'PRIORITY (Permet de classer les methodes de paiement. Si l\'entier est plus grand alors celle-ci s\'affichera en premier cote mobile)',
                                  context,
                                ),
                                getVerticalSpace(context, 10),
                                getTextFiledWidget(
                                  context,
                                  "Entrer la priorite",
                                  newCommandeController.priority,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) => value.isEmpty
                                      ? "priorite obligatoire"
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      getVerticalSpace(context, 20),
                      Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: getButtonWidget(
                                context,
                                isEdit ? 'Mettre a jour' : 'Enregistrer',
                                isProgress:
                                    newCommandeController.isLoading.value,
                                () {
                                  if (!isEdit) {
                                    if (formKey.currentState!.validate()) {
                                      newCommandeController.addCategory().then((
                                        value,
                                      ) {
                                        setState(() {});
                                      });
                                    }
                                  } else {
                                    if (formKey.currentState!.validate()) {
                                      newCommandeController
                                          .updatePromo(
                                            promo:
                                                newCommandeController.country,
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
                            ),
                          ),
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
