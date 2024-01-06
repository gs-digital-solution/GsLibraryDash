
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/retraits/model/retrait.dart';
import 'package:gslibrarydashboard/features/retraits/services/retraitService.dart';

class RetraitController extends GetxController
    with StateMixin<List<Retrait>> {
  RxList<Retrait> categoryList = <Retrait>[].obs;
  final RetraitService homeService = Get.put(RetraitService());

  String oldCategory = '';

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await homeService.getCommandes(page: 0, pageSize: 0);
      print(categoryList.length);
      if (categoryList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(categoryList, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }
}
