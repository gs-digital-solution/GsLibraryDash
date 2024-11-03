import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/services/transfert_service.dart';

import '../../auth/auth/controller/authController.dart';
import '../models/transfert.dart';

class TransfertDemandController extends GetxController
    with StateMixin<List<TransfertDevice>> {
  RxList<TransfertDevice> categoryList = <TransfertDevice>[].obs;

  final TransfertService categoryService = Get.put(TransfertService());
  final AuthController authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value = await categoryService.getTransfertBookRequest();
      if (categoryList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(
          categoryList.reversed.toList(),
          status: RxStatus.success(),
        );
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }
}
