import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/categories/controller/categoryController.dart';
import 'package:gslibrarydashboard/features/categories/models/categoryModel.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

class CategorySelectionWidget extends StatefulWidget {
  const CategorySelectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CategorySelectionWidget> createState() => _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  final CategoryController categoryController = Get.find();
  final PartnerController partnerController = Get.find();
  List<CategoryModel> allCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    categoryController.fetchCategoryData().then((_) {
      setState(() {
        allCategories = categoryController.categoryList;
      });
    });
  }

  void _toggleCategory(String categoryId) {
    if (partnerController.allowedCategories.contains(categoryId)) {
      partnerController.allowedCategories.remove(categoryId);
    } else {
      partnerController.allowedCategories.add(categoryId);
    }
  }

  void _selectAllCategories() {
    List<String> allCategoryIds = allCategories.map((category) => category.sId!).toList();
    partnerController.allowedCategories.assignAll(allCategoryIds);
  }

  void _deselectAllCategories() {
    partnerController.allowedCategories.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDefaultDecoration(
        radius: getDefaultRadius(context),
        bgColor: getCardColor(context),
        borderColor: getBorderColor(context),
        borderWidth: 1,
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catégories autorisées',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: getFontColor(context),
                ),
              ),
                             Obx(() => Text(
                 '${partnerController.allowedCategories.length} sélectionnée(s)',
                 style: TextStyle(
                   fontSize: 12,
                   color: getFontColor(context).withOpacity(0.7),
                 ),
               )),
            ],
          ),
          getVerticalSpace(context, 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getPrimaryColor(context),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _selectAllCategories,
                  child: Text(
                    'Tout sélectionner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              getHorizontalSpace(context, 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: getFontColor(context),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _deselectAllCategories,
                  child: Text(
                    'Tout désélectionner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          getVerticalSpace(context, 15),
          Container(
            height: 400,
            child: allCategories.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                                             CategoryModel category = allCategories[index];
                       bool isSelected = partnerController.allowedCategories.contains(category.sId);
                      
                                             return Obx(() {
                         bool isSelected = partnerController.allowedCategories.contains(category.sId);
                         return Container(
                           margin: EdgeInsets.only(bottom: 8),
                           decoration: getDefaultDecoration(
                             radius: getDefaultRadius(context),
                             bgColor: isSelected 
                                 ? getPrimaryColor(context).withOpacity(0.1)
                                 : getCardColor(context),
                             borderColor: isSelected 
                                 ? getPrimaryColor(context)
                                 : getBorderColor(context),
                             borderWidth: 1,
                           ),
                           child: ListTile(
                             contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                             leading: Container(
                               width: 40,
                               height: 40,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(8),
                                 color: getPrimaryColor(context).withOpacity(0.1),
                               ),
                               child: category.avatar?.url != null
                                   ? ClipRRect(
                                       borderRadius: BorderRadius.circular(8),
                                       child: Image.network(
                                         category.avatar!.url!,
                                         fit: BoxFit.cover,
                                         errorBuilder: (context, error, stackTrace) {
                                           return Icon(
                                             Icons.category,
                                             color: getPrimaryColor(context),
                                             size: 20,
                                           );
                                         },
                                       ),
                                     )
                                   : Icon(
                                       Icons.category,
                                       color: getPrimaryColor(context),
                                       size: 20,
                                     ),
                             ),
                             title: Text(
                               category.name ?? '',
                               style: TextStyle(
                                 fontSize: 14,
                                 fontWeight: FontWeight.w500,
                                 color: getFontColor(context),
                               ),
                             ),
                             trailing: Checkbox(
                               value: isSelected,
                               onChanged: (value) => _toggleCategory(category.sId!),
                               activeColor: getPrimaryColor(context),
                             ),
                             onTap: () => _toggleCategory(category.sId!),
                           ),
                         );
                       });
                    },
                  ),
          ),
        ],
      ),
    );
  }
}