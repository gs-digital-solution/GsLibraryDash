import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/books/controller/bookController.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';

import 'package:gslibrarydashboard/features/commandes/controller/new_commande_controller.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';

import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

import 'package:searchfield/searchfield.dart';

class NewCommande extends StatefulWidget {
  NewCommande();

  @override
  State<NewCommande> createState() => _NewCommandeState();
}

class _NewCommandeState extends State<NewCommande> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final NewCommandeController categoryController =
        Get.put(NewCommandeController());
    final formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
                context, 'Nouvelle Commande', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            categoryController.obx(
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
                              getHorizontalSpace(context, 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemSubTitle(
                                      'Selectionner un utilisateur ', context),
                                  getVerticalSpace(context, 10),
                                  SearchField<User>(
                                    suggestions: categoryController.categoryList
                                        .map(
                                          (e) => SearchFieldListItem<User>(
                                            e.phonenumber!,
                                            item: e,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                e.phonenumber!,
                                                style: TextStyle(
                                                  fontFamily:
                                                      Constants.fontsFamily,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onSuggestionTap: (college) {
                                      categoryController.searchUser =
                                          college.item;
                                    categoryController.searchUserController.text=categoryController.searchUser!.phonenumber!;
                                      // epreuveController.searchcollege = college.item!;
                                    },
                                    suggestionStyle:TextStyle(
                                                        fontFamily:
                                                            Constants.fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ) ,
                                             searchStyle:TextStyle(
                                                        fontFamily:
                                                            Constants.fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ) ,
                                    validator: (value) => value!.isEmpty
                                        ? "Utilisateur requis"
                                        : null,
                                    controller:categoryController.searchUserController ,
                                    suggestionState: Suggestion.expand,
                                    textInputAction: TextInputAction.next,
                                    searchInputDecoration: InputDecoration(
                                        labelText: 'Rechercher un utilisateur',
                                        border: OutlineInputBorder()),
                                  ),
                                ],
                              ),
                              getVerticalSpace(context, 30),
                              FutureBuilder(
                                future: categoryController.getBooks(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle(
                                            'Selectionner un livre ', context),
                                        getVerticalSpace(context, 10),
                                        SearchField<Book>(
                                          suggestions: snapshot.data!
                                              .map(
                                                (e) => SearchFieldListItem<Book>(
                                                  e.nom!,
                                                  item: e,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      e.nom! +
                                                          " (${e.prix} XAF)" +
                                                          "   Auteur: ${e.author!.firstname}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            Constants.fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onSuggestionTap: (college) {
                                            categoryController.searchBook =
                                                college.item;
                                            categoryController.searchBookController.text=categoryController.searchBook!.nom!+" (${college.item!.prix} XAF)" +
                                                          "   Auteur: ${college.item!.author!.firstname}";
                                          },
                                          
                                          controller: categoryController.searchBookController,
                                          suggestionStyle:TextStyle(
                                                        fontFamily:
                                                            Constants.fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ) ,
                                             searchStyle:TextStyle(
                                                        fontFamily:
                                                            Constants.fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ) ,     
                                          validator: (value) => value!.isEmpty
                                              ? "choix du livre requis"
                                              : null,
                                          suggestionState: Suggestion.expand,
                                          textInputAction: TextInputAction.next,
                                          searchInputDecoration: InputDecoration(
                                              labelText: 'Rechercher un livre',
                                              border: OutlineInputBorder()),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        getVerticalSpace(context, 20),
                        Container(
                          width: Get.width,
                          child: Obx(() => getButtonWidget(
                                context,
                                'Enregistrer',
                                isProgress:
                                    categoryController.loadingPurchase.value,
                                () {
                                  if(formKey.currentState!.validate()){
                                    categoryController
                                      .createCommande(
                                          book: categoryController.searchBook,
                                          user: categoryController.searchUser,
                                          context: context)
                                      .then((value) {
                                    setState(() {
                                      categoryController.searchBook=null;
                                      categoryController.searchUser=null;
                                    });
                                  });
                                  }
                                },
                                horPadding: 25.h,
                                horizontalSpace: 0,
                                verticalSpace: 0,
                                btnHeight: 60.h,
                              )),
                        ),
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
