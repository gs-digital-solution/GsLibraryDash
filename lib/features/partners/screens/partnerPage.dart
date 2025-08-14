import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';
import 'package:gslibrarydashboard/features/partners/widgets/partner_mobile_widget.dart';
import 'package:gslibrarydashboard/features/partners/widgets/partner_web_widget.dart';
import 'package:gslibrarydashboard/common/custom_pagination_widget.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';

class PartnerPage extends StatefulWidget {
  PartnerPage();

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  final PartnerController partnerController = Get.put(PartnerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    RxString queryText = ''.obs;

    return Material(
      child: SafeArea(
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
                      context, 'Partenaires', 75, getFontColor(context),
                      fontWeight: FontWeight.w700),
                  
                ],
              ),
              getVerticalSpace(context, 35),
              Expanded(
                child: getCommonContainer(
                  context: context,
                  verSpace: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getVerticalSpace(context, getCommonPadding(context)),
                      Row(
                        children: [
                          getHorizontalSpace(context, isWeb(context) ? 0 : 0),
                          Visibility(
                            child: Expanded(child: Container()),
                            visible: isWeb(context),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              partnerController.fetchPartners(refresh: true);
                            },
                            child: Text('Actualiser'),
                          ),
                          getHorizontalSpace(context, 15),
                          Expanded(
                              child: getSearchTextFiledWidget(
                                  context,
                                  'Rechercher...',
                                  textEditingController, onChanged: (value) {
                            queryText(value);
                          })),
                          getHorizontalSpace(context, 15),
                          // Filtre par statut
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: getDefaultDecoration(
                              bgColor: getCardColor(context),
                              borderColor: getBorderColor(context),
                              borderWidth: 1,
                              radius: getDefaultRadius(context),
                            ),
                            child: DropdownButton<String>(
                              value: partnerController
                                      .selectedFilterStatus.value.isEmpty
                                  ? null
                                  : partnerController
                                      .selectedFilterStatus.value,
                              hint: Text('Statut'),
                              underline: Container(),
                              items: [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('Tous'),
                                ),
                                DropdownMenuItem(
                                  value: 'active',
                                  child: Text('Actif'),
                                ),
                                DropdownMenuItem(
                                  value: 'inactive',
                                  child: Text('Inactif'),
                                ),
                                DropdownMenuItem(
                                  value: 'suspended',
                                  child: Text('Suspendu'),
                                ),
                              ],
                              onChanged: (value) {
                                partnerController.filterByStatus(value ?? '');
                              },
                            ),
                          ),
                        ],
                      ),

                      getVerticalSpace(context, 25),
                       partnerController.obx(
                        (state) => Obx(
                          () {
                            return state != null && state.isNotEmpty
                                ? Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        isWeb(context)
                                            ? PartnerWebWidget(
                                                list: state,
                                                queryText: queryText,
                                                function: (detail, model) {
                                                  _showPopupMenu(
                                                      context, detail, model);
                                                },
                                                onTapStatus: (model) {
                                                  updateStatus(context, model);
                                                },
                                                onRegenerateApiKey: (model) {
                                                  _showRegenerateApiKeyDialog(context, model);
                                                },
                                              )
                                            : Expanded(child: PartnerMobileWidget(
                                                list: state,
                                                queryText: queryText,
                                                function: (detail, model) {
                                                  _showPopupMenu(
                                                      context, detail, model);
                                                },
                                                onTapStatus: (model) {
                                                  updateStatus(context, model);
                                                },
                                                onRegenerateApiKey: (model) {
                                                  _showRegenerateApiKeyDialog(context, model);
                                                },
                                              )),
                                        getVerticalSpace(context, 20),
                                        
                                        // Widget de pagination personnalisé
                                        CustomPaginationWidget(
                                          currentPage: partnerController.currentPage.value,
                                          totalPages: partnerController.totalPages.value,
                                          totalItems: partnerController.totalItems.value,
                                          itemsPerPage: partnerController.pageSize.value,
                                          onPageChanged: (page) {
                                            partnerController.changePage(page);
                                          },
                                          onItemsPerPageChanged: (size) {
                                            partnerController.changePageSize(size);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(child: getNoData(context));
                          },
                        ),
                        onError: (error) => Center(
                            child: Column(
                          children: [
                            getTextWidget(
                                context, error!, 50, getFontColor(context),
                                fontWeight: FontWeight.w500),
                            getVerticalSpace(context, 10),
                          ],
                        )),
                        onEmpty: Center(child: getNoData(context)),
                        onLoading: getProgressWidget(context),
                      ), 
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateStatus(BuildContext context, Partner partner) {
    String action = partner.status == 'active' ? 'désactiver' : 'activer';
    getCommonDialog(
        context: context,
        title: 'Voulez-vous $action ce partenaire?',
        function: () {
          if (partner.status == 'active') {
            partnerController.deactivatePartner(partner);
          } else {
            partnerController.activatePartner(partner);
          }
        },
        subTitle: 'Partenaire');
  }

  _showRegenerateApiKeyDialog(BuildContext context, Partner partner) {
    getCommonDialog(
        context: context,
        title: 'Régénérer l\'API Key',
        function: () {
          partnerController.regenerateApiKey(partner);
        },
        subTitle: 'Êtes-vous sûr de vouloir régénérer l\'API Key de ce partenaire ?\n\nCette action est irréversible et l\'ancienne clé ne fonctionnera plus.');
  }

  _showPopupMenu(BuildContext context, Offset detail, Partner partner) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
           detail & Size(0.h, 0.h), // smaller rect, the touch area
          Offset.zero & overlay!.size),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: ThemeController().checkDarkTheme()
          ? getBackgroundColor(context)
          : getCardColor(context),
      items: [
        PopupMenuItem<String>(
          child: Container(
            child: MenuItem(
              title: "Modifier",
              space: 0,
            ),
          ),
          onTap: () {
            setState(() {
              partnerController.setPartnerForEdit(partner);
             
            });
          },
          value: 'Modifier',
        ),
        PopupMenuItem<String>(
          child: Container(
            child: MenuItem(
              title: "Régénérer API Key",
              space: 0,
            ),
          ),
          onTap: () {
            partnerController.regenerateApiKey(partner);
          },
          value: 'Régénérer API Key',
        ),
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Supprimer",
                space: 0,
                visibility: false,
              ),
            ),
            onTap: () {
              getCommonDialog(
                  context: context,
                  title: 'Voulez-vous supprimer ce partenaire?',
                  function: () async {
                    partnerController.deletePartner(partner);
                  },
                  subTitle: 'Supprimer');
            },
            value: 'Supprimer'),
      ],
      elevation: 1,
    );
  }


}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.title,
    this.visibility,
    this.color,
    this.space,
    this.child,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? child;
  final double? space;
  final bool? visibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 12.h,
          ),
          child: Row(
            children: [
              Expanded(
                  child: getMaxLineFont(context, title, 45,
                      color == null ? getFontColor(context) : color!, 1,
                      fontWeight: FontWeight.w500)),
              child == null ? Container() : child!
            ],
          ),
        ),
        Visibility(
          visible: (visibility == null) ? true : visibility!,
          child: Container(
            color: getBorderColor(context),
            width: double.infinity,
            height: 0.5,
          ),
        )
      ],
    ).marginSymmetric(horizontal: space == null ? 35.w : space!);
  }
}
