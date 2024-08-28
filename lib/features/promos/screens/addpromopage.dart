import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:gslibrarydashboard/common/common.dart';

import 'package:gslibrarydashboard/features/commandes/controller/new_commande_controller.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/promos/controller/promocontroller.dart';
import 'package:gslibrarydashboard/features/promos/models/promo.dart';
import 'package:gslibrarydashboard/features/promos/screens/promoPage.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:searchfield/searchfield.dart';

class AddPromoScreen extends StatefulWidget {
  final Promo? categoryModel;

  AddPromoScreen({this.categoryModel});

  @override
  State<AddPromoScreen> createState() => _AddPromoScreenState();
}

class _AddPromoScreenState extends State<AddPromoScreen> {
  final PromoController categoryController = Get.find();

  final NewCommandeController newCommandeController =
      Get.put(NewCommandeController());

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = categoryController.promo != null;

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
                    isEdit ? 'Mettre a jour le code promo' : 'Ajouter un code promo',
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
            newCommandeController.obx(
              (state) => Expanded(
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
                                            'Selectionner un utilisateur ',
                                            context),
                                        getVerticalSpace(context, 10),
                                        SearchField<User>(
                                          suggestions: newCommandeController
                                              .categoryList
                                              .map(
                                                (e) =>
                                                    SearchFieldListItem<User>(
                                                  e.phonenumber!,
                                                  item: e,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      e.phonenumber! +
                                                          " (${e.firstname} ${e.lastname})",
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
                                            categoryController.author.value =
                                                college.item!.sId!;
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
                                              ? "Utilisateur requis"
                                              : null,
                                          controller: newCommandeController
                                              .searchUserController,
                                          suggestionState: Suggestion.expand,
                                          textInputAction: TextInputAction.next,
                                          searchInputDecoration: InputDecoration(
                                              labelText:
                                                  'Rechercher un utilisateur',
                                              border: OutlineInputBorder()),
                                        ),
                                      ],
                                    ),
                              getVerticalSpace(context, 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle('Entrer le code Promo', context),
                                  getVerticalSpace(context, 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: getTextFiledWidget(
                                            context,
                                            "Entrer le code",
                                            categoryController.code,
                                            validator: (value) => value.isEmpty
                                                ? "Code obligatoire"
                                                : null,
                                            inputFormatters: [
                                              UpperCaseTextFormatter(),
                                            ]),
                                      ),
                                      getHorSpace(10.h),
                                      Expanded(
                                        child: getButtonWidget(
                                          context,
                                          'Generer',
                                          isProgress: false,
                                          () {
                                            setState(() {
                                              categoryController
                                                  .genererChaine();
                                            });
                                          },
                                          horPadding: 25.h,
                                          bgColor: primaryColor,
                                          horizontalSpace: 0,
                                          verticalSpace: 0,
                                          btnHeight: 60.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              getVerticalSpace(context, 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle(
                                      'Pourcentage de reduction', context),
                                  getVerticalSpace(context, 10),
                                  getTextFiledWidget(
                                    context,
                                    "Entrer le pourcentage",
                                    categoryController.discount,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) => value.isEmpty
                                        ? "Pourcentage de reduction obligatoire"
                                        : int.parse(value) > 100
                                            ? "Le pourcentage doit etre <= a 100"
                                            : null,
                                  ),
                                ],
                              ),
                              getVerticalSpace(context, 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle('Pourcentage de gain', context),
                                  getVerticalSpace(context, 10),
                                  getTextFiledWidget(
                                    context,
                                    "Entrer le pourcentage",
                                    categoryController.gain,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) => value.isEmpty
                                        ? "Pourcentage de Gain obligatoire"
                                        : int.parse(value) > 100
                                            ? "Le pourcentage doit etre <= a 100"
                                            : null,
                                  ),
                                ],
                              )
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
                                        categoryController.isLoading.value,
                                    () {
                                      if (!isEdit) {
                                        if (formKey.currentState!.validate()) {
                                          categoryController
                                              .addCategory(
                                            user: User(
                                                sId: categoryController
                                                    .author.value),
                                          )
                                              .then((value) {
                                            setState(() {});
                                          });
                                        }
                                      } else {
                                        if (formKey.currentState!.validate()) {
                                          categoryController
                                              .updatePromo(
                                            promo: categoryController.promo,
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
                                  categoryController.isLoading.value = false;
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
              onLoading: getProgressWidget(context),
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
