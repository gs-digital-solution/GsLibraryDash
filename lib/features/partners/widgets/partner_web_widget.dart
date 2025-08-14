import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

class PartnerWebWidget extends StatelessWidget {
  final List<Partner> list;
  final RxString queryText;
  final Function(Offset detail, Partner model) function;
  final Function(Partner model) onTapStatus;
  final Function(Partner model) onRegenerateApiKey;

  PartnerWebWidget({
    required this.list,
    required this.queryText,
    required this.function,
    required this.onTapStatus,
    required this.onRegenerateApiKey,
  });

  @override
  Widget build(BuildContext context) {
    final PartnerController partnerController = Get.find();

    return Container(
      decoration: getDefaultDecoration(
        bgColor: getCardColor(context),
        radius: getDefaultRadius(context),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: TextStyle(
            color: getFontColor(context),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          dataTextStyle: TextStyle(
            color: getFontColor(context),
            fontSize: 13,
          ),
          columns: [
            DataColumn(
                label: Text(
              'Nom',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Email',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Statut',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Commission',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Solde',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Utilisateurs',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Date début',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Date fin',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
            DataColumn(
                label: Text(
              'Actions',
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getFontColor(context)),
            )),
          ],
          rows: list
              .where((partner) =>
                  partner.name!
                      .toLowerCase()
                      .contains(queryText.value.toLowerCase()) ||
                  partner.email!
                      .toLowerCase()
                      .contains(queryText.value.toLowerCase()))
              .map((partner) => DataRow(
                    cells: [
                      DataCell(
                        Container(
                          width: 150,
                          child: Text(
                            partner.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: Constants.fontsFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: getFontColor(context)),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 200,
                          child: Text(
                            partner.email ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: partnerController
                                .getStatusColor(partner.status ?? ''),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            partnerController
                                .getStatusInFrench(partner.status ?? ''),
                            style: TextStyle(
                              color: Colors.white,
                               fontFamily: Constants.fontsFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                            '${partner.commission?.toStringAsFixed(1) ?? '0'}%',style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),),
                      ),
                      DataCell(
                        Text(
                            '${partner.balance?.toStringAsFixed(2) ?? '0'} XAF',style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),),
                      ),
                      DataCell(
                        Text(
                            '${partner.currentUsers ?? 0}/${partner.maxUsers ?? 0}',style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),),
                      ),
                      DataCell(
                        Text(partner.startDate?.split('T')[0] ?? '',style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),),
                      ),
                      DataCell(
                        Text(partner.endDate?.split('T')[0] ?? '',style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Bouton de statut
                            InkWell(
                              onTap: () => onTapStatus(partner),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: partner.status == 'active'
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  partner.status == 'active'
                                      ? 'Désactiver'
                                      : 'Activer',
                                  style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            // Bouton copier API Key
                            InkWell(
                              onTap: () {
                                final PartnerController partnerController =
                                    Get.find();
                                partnerController.copyApiKey(partner);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Copier',
                                  style: TextStyle(
                                     fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            // Bouton régénérer API Key
                            InkWell(
                              onTap: () => onRegenerateApiKey(partner),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Régénérer',
                                  style: TextStyle(
                                     fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            // Menu d'actions
                            InkWell(
                              onTap: () {
                                final RenderBox button =
                                    context.findRenderObject() as RenderBox;
                                final Offset offset =
                                    button.localToGlobal(Offset.zero);
                                function(offset, partner);
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: getFontColor(context),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
