import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';

class AddPartnerPage extends StatefulWidget {
  AddPartnerPage();

  @override
  State<AddPartnerPage> createState() => _AddPartnerPageState();
}

class _AddPartnerPageState extends State<AddPartnerPage> {
   final PartnerController partnerController = Get.put(PartnerController());

  @override
  Widget build(BuildContext context) {
    bool isEdit = partnerController.selectedPartner != null;
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
                    isEdit ? 'Modifier le partenaire' : 'Ajouter un partenaire',
                    75,
                    getFontColor(context),
                    fontWeight: FontWeight.w700),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      partnerController.clearForm();
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
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          getVerticalSpace(context, 30),
                          Responsive.isMobile(context)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nom du partenaire
                                    itemSubTitle('Nom du partenaire', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Entrer le nom",
                                        partnerController.nameController),
                                    getVerticalSpace(context, 30),
                                    
                                    // Email
                                    itemSubTitle('Email du partenaire', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Entrer l'email",
                                        partnerController.emailController),
                                    getVerticalSpace(context, 30),
                                    
                                    // Description
                                    itemSubTitle('Description', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Description du partenaire",
                                        partnerController.descriptionController),
                                    getVerticalSpace(context, 30),
                                    
                                    // Date de début
                                    itemSubTitle('Date de début', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Date de début",
                                        partnerController.startDateController,
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            DateTime? picker = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2023),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picker != null) {
                                              setState(() {
                                                partnerController.startDateController.text =
                                                    picker.toString().split(' ').first;
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.calendar_month),
                                        ),
                                        isEnabled: true,
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Date de fin
                                    itemSubTitle('Date de fin', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Date de fin",
                                        partnerController.endDateController,
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            DateTime? picker = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2023),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picker != null) {
                                              setState(() {
                                                partnerController.endDateController.text =
                                                    picker.toString().split(' ').first;
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.calendar_month),
                                        ),
                                        isEnabled: true,
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Nombre maximum d'utilisateurs
                                    itemSubTitle('Nombre max d\'utilisateurs', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Nombre maximum d'utilisateurs",
                                        partnerController.maxUsersController,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Commission
                                    itemSubTitle('Commission (%)', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Pourcentage de commission",
                                        partnerController.commissionController,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Webhook URL
                                    itemSubTitle('URL Webhook (optionnel)', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "URL du webhook",
                                        partnerController.webhookUrlController),
                                    getVerticalSpace(context, 30),
                                    
                                    // Informations de contact
                                    itemSubTitle('Informations de contact', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Nom du contact",
                                        partnerController.contactNameController),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(context, "Téléphone du contact",
                                        partnerController.contactPhoneController),
                                    getVerticalSpace(context, 30),
                                    
                                    // Paramètres
                                    itemSubTitle('Paramètres', context),
                                    getVerticalSpace(context, 10),
                                    Container(
                                      decoration: getDefaultDecoration(
                                        radius: getDefaultRadius(context),
                                        bgColor: getCardColor(context),
                                        borderColor: getBorderColor(context),
                                        borderWidth: 1,
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Peut effectuer des achats',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canPurchase!.value ,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canPurchase!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                          getVerticalSpace(context, 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Peut voir les catégories',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canViewCategories!.value,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canViewCategories!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                          getVerticalSpace(context, 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Peut voir les livres',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canViewBooks!.value ,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canViewBooks!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                          getVerticalSpace(context, 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Peut voir les achats',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canViewPurchases!.value ,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canViewPurchases!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    getVerticalSpace(context, 30),
                                  ],
                                )
                              : Column(
                                  children: [
                                    // Première ligne : Nom et Email
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Nom du partenaire', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "Entrer le nom",
                                                partnerController.nameController),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Email du partenaire', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "Entrer l'email",
                                                partnerController.emailController),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Deuxième ligne : Dates
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Date de début', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "Date de début",
                                                partnerController.startDateController,
                                                suffixIcon: IconButton(
                                                  onPressed: () async {
                                                    DateTime? picker = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(2023),
                                                      lastDate: DateTime(2100),
                                                    );
                                                    if (picker != null) {
                                                      setState(() {
                                                        partnerController.startDateController.text =
                                                            picker.toString().split(' ').first;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(Icons.calendar_month),
                                                ),
                                                isEnabled: true,
                                            ),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Date de fin', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "Date de fin",
                                                partnerController.endDateController,
                                                suffixIcon: IconButton(
                                                  onPressed: () async {
                                                    DateTime? picker = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(2023),
                                                      lastDate: DateTime(2100),
                                                    );
                                                    if (picker != null) {
                                                      setState(() {
                                                        partnerController.endDateController.text =
                                                            picker.toString().split(' ').first;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(Icons.calendar_month),
                                                ),
                                                isEnabled: true,
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Troisième ligne : Max Users et Commission
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Nombre max d\'utilisateurs', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "Nombre maximum d'utilisateurs",
                                                partnerController.maxUsersController,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            ),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Commission (%)', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "Pourcentage de commission",
                                                partnerController.commissionController,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Quatrième ligne : Contact
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Nom du contact', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "Nom du contact",
                                                partnerController.contactNameController),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Téléphone du contact', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "Téléphone du contact",
                                                partnerController.contactPhoneController),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Cinquième ligne : Description et Webhook
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Description', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "Description du partenaire",
                                                partnerController.descriptionController),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('URL Webhook (optionnel)', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(context, "URL du webhook",
                                                partnerController.webhookUrlController),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    
                                    // Paramètres
                                    itemSubTitle('Paramètres', context),
                                    getVerticalSpace(context, 10),
                                    Container(
                                      decoration: getDefaultDecoration(
                                        radius: getDefaultRadius(context),
                                        bgColor: getCardColor(context),
                                        borderColor: getBorderColor(context),
                                        borderWidth: 1,
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Peut effectuer des achats',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              
                                               Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canPurchase!.value,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canPurchase!.value = value;
                                                },
                                              ))
                                            ],
                                          ),
                                          getVerticalSpace(context, 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Peut voir les catégories',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canViewCategories!.value,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canViewCategories!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                          getVerticalSpace(context, 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Peut voir les livres',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canViewBooks!.value ,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canViewBooks!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                          getVerticalSpace(context, 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                               Text(
                                                  'Peut voir les achats',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              
                                              Obx(() => CupertinoSwitch(
                                                activeColor: getPrimaryColor(context),
                                                value: partnerController.defaultSettings.canViewPurchases!.value ,
                                                onChanged: (value) {
                                                  partnerController.defaultSettings.canViewPurchases!.value = value;
                                                },
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    getVerticalSpace(context, 30),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 20),
                    Obx(() => getButtonWidget(
                          context,
                          isEdit ? 'Mettre à jour' : 'Enregistrer',
                          isProgress: partnerController.isLoading.value,
                          () {
                            if (isEdit) {
                              partnerController.updatePartner();
                            } else {
                              partnerController.createPartner();
                            }
                          },
                          horPadding: 25.h,
                          horizontalSpace: 0,
                          verticalSpace: 0,
                          btnHeight: 50.h,
                        )),
                    getVerticalSpace(context, 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

itemSubTitle(String s, BuildContext context, {Color? color}) {
  return getTextWidget(
    context,
    s,
    45,
    color == null ? getFontColor(context) : color,
    fontWeight: FontWeight.w500,
  );
}
