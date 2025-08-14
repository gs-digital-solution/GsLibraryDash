import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

class CustomPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;
  final Function(int) onPageChanged;
  final Function(int) onItemsPerPageChanged;

  const CustomPaginationWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    this.itemsPerPageOptions = const [5, 10, 25, 50],
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: getBorderColor(context),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informations sur les résultats
          Text(
            'Affichage de ${_getStartIndex() + 1} à ${_getEndIndex()} sur $totalItems résultats',
            style: TextStyle(
              fontSize: 13,
              color: getSubFontColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Navigation des pages
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bouton première page
              _buildNavigationButton(
                context,
                icon: Icons.first_page,
                onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
                tooltip: 'Première page',
              ),
              
              SizedBox(width: 6.w),
              
              // Bouton page précédente
              _buildNavigationButton(
                context,
                icon: Icons.chevron_left,
                onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
                tooltip: 'Page précédente',
              ),
              
              SizedBox(width: 10.w),
              
              // Numéros de pages
              _buildPageNumbers(context),
              
              SizedBox(width: 10.w),
              
              // Bouton page suivante
              _buildNavigationButton(
                context,
                icon: Icons.chevron_right,
                onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
                tooltip: 'Page suivante',
              ),
              
              SizedBox(width: 6.w),
              
              // Bouton dernière page
              _buildNavigationButton(
                context,
                icon: Icons.last_page,
                onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
                tooltip: 'Dernière page',
              ),
            ],
          ),
          
          // Sélecteur du nombre d'éléments par page
          Row(
            children: [
              Text(
                'Afficher',
                style: TextStyle(
                  fontSize: 13,
                  color: getSubFontColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: getBorderColor(context),
                    width: 1,
                  ),
                ),
                child: DropdownButton<int>(
                  value: itemsPerPage,
                  underline: Container(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: getFontColor(context),
                    size: 16,
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: getFontColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                  items: itemsPerPageOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onItemsPerPageChanged(value);
                    }
                  },
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'par page',
                style: TextStyle(
                  fontSize: 13,
                  color: getSubFontColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: onPressed != null 
                ? getPrimaryColor(context).withOpacity(0.1)
                : getBackgroundColor(context),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: onPressed != null 
                  ? getPrimaryColor(context)
                  : getBorderColor(context),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onPressed != null 
                ? getPrimaryColor(context)
                : getSubFontColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPageNumbers(BuildContext context) {
    List<Widget> pageButtons = [];
    
    // Calculer les pages à afficher
    int startPage = _getStartPage();
    int endPage = _getEndPage();
    
    // Ajouter les pages
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildPageButton(context, i));
      if (i < endPage) {
        pageButtons.add(SizedBox(width: 3.w));
      }
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pageButtons,
    );
  }

  Widget _buildPageButton(BuildContext context, int pageNumber) {
    bool isCurrentPage = pageNumber == currentPage;
    
    return InkWell(
      onTap: () => onPageChanged(pageNumber),
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isCurrentPage 
              ? getPrimaryColor(context)
              : getBackgroundColor(context),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isCurrentPage 
                ? getPrimaryColor(context)
                : getBorderColor(context),
            width: 1,
          ),
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isCurrentPage 
                ? Colors.white
                : getFontColor(context),
          ),
        ),
      ),
    );
  }

  int _getStartIndex() {
    return (currentPage - 1) * itemsPerPage;
  }

  int _getEndIndex() {
    int end = currentPage * itemsPerPage;
    return end > totalItems ? totalItems : end;
  }

  int _getStartPage() {
    int maxVisiblePages = 5;
    if (totalPages <= maxVisiblePages) {
      return 1;
    }
    
    int halfVisible = maxVisiblePages ~/ 2;
    int start = currentPage - halfVisible;
    
    if (start < 1) {
      start = 1;
    } else if (start + maxVisiblePages - 1 > totalPages) {
      start = totalPages - maxVisiblePages + 1;
    }
    
    return start;
  }

  int _getEndPage() {
    int maxVisiblePages = 5;
    if (totalPages <= maxVisiblePages) {
      return totalPages;
    }
    
    int start = _getStartPage();
    int end = start + maxVisiblePages - 1;
    
    return end > totalPages ? totalPages : end;
  }
}
