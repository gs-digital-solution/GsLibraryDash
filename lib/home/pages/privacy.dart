import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  void backClick() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question('Collecte de l\'information '),
                          getVerSpace(16.h),
                          answer(
                              "Nous collectons les informations suivantes : informations fournies par l'utilisateur lors de l'inscription, telles que le nom, le numéro de téléphone."),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question('2.Utilisation de l\'information '),
                          getVerSpace(16.h),
                          answer(
                              "Les informations collectées par GS LIBRARY sont utilisées pour "),
                          getVerSpace(16.h),
                          answer(
                              "Fournir, maintenir et améliorer nos services: via des appels ou sms;"),
                          getVerSpace(16.h),
                          answer(
                              "Personnaliser l'application pour vous offrir une meilleure expérience utilisateur "),
                          getVerSpace(16.h),
                          answer(
                              "Communiquer avec vous, y compris pour vous envoyer des mises à jour importantes et des offres promotionnelles."),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question('3.Partage de l\'Information'),
                          getVerSpace(16.h),
                          answer(
                              "Nous ne partageons pas vos informations personnelles avec des tiers, sauf dans les cas suivants :"),
                          getVerSpace(16.h),
                          answer("Avec votre consentement."),
                          getVerSpace(16.h),
                          answer(
                              "Pour se conformer à la loi, une procédure légale, ou une demande gouvernementale."),
                          getVerSpace(16.h),
                          answer(
                              "Pour protéger la sécurité ou l'intégrité de notre service."),
                          getVerSpace(16.h),
                          answer(
                              "En cas de fusion, vente d'actifs de la société, financement ou acquisition de tout ou partie de notre entreprise par une autre société."),
                          getVerSpace(16.h),
                          answer(
                              "Pour protéger la sécurité ou l'intégrité de notre service."),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question('4.Sécurité de l\'Information'),
                          getVerSpace(16.h),
                          answer(
                              "Nous prenons la sécurité de vos informations au sérieux et utilisons des mesures techniques et organisationnelles appropriées pour protéger vos informations contre l'accès non autorisé, la modification, la divulgation ou la destruction"),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question('5.Vos Droits '),
                          getVerSpace(16.h),
                          answer(
                              "Accéder et recevoir une copie des informations personnelles que nous détenons à votre sujet"),
                          getVerSpace(16.h),
                          answer(
                              "Demander la correction de vos informations personnelles si elles sont inexactes."),
                          getVerSpace(16.h),
                          answer(
                              "Demander la suppression de vos informations personnelles."),
                          getVerSpace(16.h),
                          answer(
                              "Retirer votre consentement à tout moment pour les cas où le consentement à la collecte et au traitement de vos informations a été demandé"),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question(
                              '7. Modifications de la Politique de Confidentialité '),
                          getVerSpace(16.h),
                          answer(
                              "Nous pouvons mettre à jour notre politique de confidentialité de temps à autre. Nous vous informerons de tout changement en publiant la nouvelle politique de confidentialité sur notre application et, si les changements sont significatifs, nous vous fournirons un avis plus direct, tel qu'un message whasapp par exemple"),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                    Container(
                      color: context.theme.focusColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          question('8. Contact'),
                          getVerSpace(16.h),
                          answer(
                              "Si vous avez des questions ou des préoccupations concernant cette politique de confidentialité, veuillez nous contacter à l’adresse gs.library2024@gmail.com "),
                        ],
                      ).paddingSymmetric(horizontal: 20.h, vertical: 20.h),
                    ).paddingSymmetric(vertical: 10.h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  question(String s) {
    return getMultilineCustomFont(s, 18.sp, context.theme.primaryColor,
        fontWeight: FontWeight.w700, txtHeight: 1.5.h);
  }

  answer(String s) {
    return getMultilineCustomFont(s, 14.sp, Colors.grey,
        fontWeight: FontWeight.w400, txtHeight: 1.5.h);
  }
}
