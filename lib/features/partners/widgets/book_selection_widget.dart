import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/books/controller/bookController.dart';
import 'package:gslibrarydashboard/features/books/model/book.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';

class BookSelectionWidget extends StatefulWidget {
  const BookSelectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BookSelectionWidget> createState() => _BookSelectionWidgetState();
}

class _BookSelectionWidgetState extends State<BookSelectionWidget> {
  final BookController bookController = Get.put(BookController());
  final PartnerController partnerController = Get.find();
  List<Book> allBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    bookController.fetchCategoryData().then((_) {
      setState(() {
        allBooks = bookController.categoryList;
      });
    });
  }

  void _toggleBook(String bookId) {
    if (partnerController.allowedBooks.contains(bookId)) {
      partnerController.allowedBooks.remove(bookId);
    } else {
      partnerController.allowedBooks.add(bookId);
    }
  }

  void _selectAllBooks() {
    List<String> allBookIds = allBooks.map((book) => book.sId!).toList();
    partnerController.allowedBooks.assignAll(allBookIds);
  }

  void _deselectAllBooks() {
    partnerController.allowedBooks.clear();
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
                'Livres autorisés',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: getFontColor(context),
                ),
              ),
                             Obx(() => Text(
                 '${partnerController.allowedBooks.length} sélectionné(s)',
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
                  onPressed: _selectAllBooks,
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
                  onPressed: _deselectAllBooks,
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
            child: allBooks.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: allBooks.length,
                    itemBuilder: (context, index) {
                                                                    Book book = allBooks[index];
                      
                                             return Obx(() {
                         bool isSelected = partnerController.allowedBooks.contains(book.sId);
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
                               child: book.avatar?.url != null
                                   ? ClipRRect(
                                       borderRadius: BorderRadius.circular(8),
                                       child: Image.network(
                                         book.avatar!.url!,
                                         fit: BoxFit.cover,
                                         errorBuilder: (context, error, stackTrace) {
                                           return Icon(
                                             Icons.book,
                                             color: getPrimaryColor(context),
                                             size: 20,
                                           );
                                         },
                                       ),
                                     )
                                   : Icon(
                                       Icons.book,
                                       color: getPrimaryColor(context),
                                       size: 20,
                                     ),
                             ),
                             title: Text(
                               book.nom ?? '',
                               style: TextStyle(
                                 fontSize: 14,
                                 fontWeight: FontWeight.w500,
                                 color: getFontColor(context),
                               ),
                             ),
                             subtitle: Text(
                               '${book.prix ?? 0} ${book.currency ?? "XAF"}',
                               style: TextStyle(
                                 fontSize: 12,
                                 color: getFontColor(context).withOpacity(0.7),
                               ),
                             ),
                             trailing: Checkbox(
                               value: isSelected,
                               onChanged: (value) => _toggleBook(book.sId!),
                               activeColor: getPrimaryColor(context),
                             ),
                             onTap: () => _toggleBook(book.sId!),
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