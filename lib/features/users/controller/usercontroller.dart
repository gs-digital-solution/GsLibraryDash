import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/commandes/model/user.dart';
import 'package:gslibrarydashboard/features/users/services/userservice.dart';

class UserController extends GetxController with StateMixin<List<User>> {
  RxList<User> categoryList = <User>[].obs;
  final UserService homeService = Get.put(UserService());

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    change(null, status: RxStatus.loading());
    try {
      categoryList.value =
          await homeService.getCategories(page: 0, pageSize: 0);
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
