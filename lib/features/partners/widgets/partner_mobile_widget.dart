import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/constants.dart';

class PartnerMobileWidget extends StatelessWidget {
  final List<Partner> list;
  final RxString queryText;
  final Function(Offset detail, Partner model) function;
  final Function(Partner model) onTapStatus;
  final Function(Partner model) onRegenerateApiKey;

  PartnerMobileWidget({
    required this.list,
    required this.queryText,
    required this.function,
    required this.onTapStatus,
    required this.onRegenerateApiKey,
  });

  @override
  Widget build(BuildContext context) {
    final PartnerController partnerController = Get.find();
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list
          .where((partner) => partner.name!
              .toLowerCase()
              .contains(queryText.value.toLowerCase()) ||
              partner.email!
                  .toLowerCase()
                  .contains(queryText.value.toLowerCase()))
          .length,
      itemBuilder: (context, index) {
        Partner partner = list
            .where((partner) => partner.name!
                .toLowerCase()
                .contains(queryText.value.toLowerCase()) ||
                partner.email!
                    .toLowerCase()
                    .contains(queryText.value.toLowerCase()))
            .toList()[index];

        return Container(
          margin: EdgeInsets.only(bottom: 15.h),
          decoration: getDefaultDecoration(
            bgColor: getCardColor(context),
            radius: getDefaultRadius(context),
            borderColor: getBorderColor(context),
            borderWidth: 1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et statut
              Container(
                padding: EdgeInsets.all(15.h),
                decoration: BoxDecoration(
                  color: getBackgroundColor(context),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(getDefaultRadius(context)),
                    topRight: Radius.circular(getDefaultRadius(context)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partner.name ?? '',
                            style: TextStyle(
                                fontFamily: Constants.fontsFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: getFontColor(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            partner.email ?? '',
                            style: TextStyle(
                                fontFamily: Constants.fontsFamily,
                              fontSize: 14,
                              color: getSubFontColor(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: partnerController.getStatusColor(partner.status ?? ''),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        partnerController.getStatusInFrench(partner.status ?? ''),
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenu principal
              Padding(
                padding: EdgeInsets.all(15.h),
                child: Column(
                  children: [
                    // Informations financières
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Commission',
                            '${partner.commission?.toStringAsFixed(1) ?? '0'}%',
                            Icons.percent,
                            Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Solde',
                            '${partner.balance?.toStringAsFixed(2) ?? '0'} XAF',
                            Icons.account_balance_wallet,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 15),
                    
                    // Utilisateurs et dates
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Utilisateurs',
                            '${partner.currentUsers ?? 0}/${partner.maxUsers ?? 0}',
                            Icons.people,
                            Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Période',
                            '${partner.startDate?.split('T')[0] ?? ''} - ${partner.endDate?.split('T')[0] ?? ''}',
                            Icons.calendar_today,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 15),
                    
                    // Contact
                    if (partner.contactPerson != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: getBackgroundColor(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: getFontColor(context),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${partner.contactPerson!.name}',
                              style: TextStyle(
                                fontSize: 13,
                                color: getSubFontColor(context),
                              ),
                            ),
                            Text(
                              '${partner.contactPerson!.phone}',
                              style: TextStyle(
                                fontSize: 13,
                                color: getSubFontColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                    
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => onTapStatus(partner),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: partner.status == 'active' 
                                    ? Colors.orange 
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  partner.status == 'active' ? 'Désactiver' : 'Activer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                                                 SizedBox(width: 10),
                         Expanded(
                           child: InkWell(
                             onTap: () {
                               final PartnerController partnerController = Get.find();
                               partnerController.copyApiKey(partner);
                             },
                             child: Container(
                               padding: EdgeInsets.symmetric(vertical: 10),
                               decoration: BoxDecoration(
                                 color: Colors.green,
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Center(
                                 child: Text(
                                   'Copier API',
                                   style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 14,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(width: 10),
                         Expanded(
                           child: InkWell(
                             onTap: () => onRegenerateApiKey(partner),
                             child: Container(
                               padding: EdgeInsets.symmetric(vertical: 10),
                               decoration: BoxDecoration(
                                 color: Colors.blue,
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Center(
                                 child: Text(
                                   'Régénérer',
                                   style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 14,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            final RenderBox button = context.findRenderObject() as RenderBox;
                            final Offset offset = button.localToGlobal(Offset.zero);
                            function(offset, partner);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: getBackgroundColor(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.more_vert,
                              color: getFontColor(context),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                  fontSize: 12,
                  color: getSubFontColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: getFontColor(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
