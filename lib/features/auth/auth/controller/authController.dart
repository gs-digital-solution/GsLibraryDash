
import 'package:get/get.dart';
import 'package:gslibrarydashboard/features/auth/auth/model/adminUser.dart';
import 'package:gslibrarydashboard/features/auth/auth/states/authState.dart';
import 'package:gslibrarydashboard/home/services/baseService.dart';

import '../services/authservice.dart';

class AuthController extends GetxController {
  final AuthService? _authService;
  final Rx<AuthenticationState> _authenticationStateStream =
      AuthenticationState().obs;
  AuthenticationState get state => _authenticationStateStream.value;

  AuthController(
    this._authService,
  );

  @override
  void onInit() async {
    super.onInit();
    await getAuthenticatedUser();
  }

  Future<void> getAuthenticatedUser() async {
    AdminUser? user = await _authService!.getCurrentUser();
    // _authenticationStateStream.value = AuthenticationLoading();
    if (user != null) {
      _authenticationStateStream.value = Authenticated(user: user);
      BaseService.dio.options.headers["Authorization"] = 'Bearer ${user.token}';
    } else {
      _authenticationStateStream.value = UnAuthenticated();
    }
    print(_authenticationStateStream.value);
  }

  Future<void> login({String? email, String? password}) async {
    final user = await _authService!.login(email: email, password: password);
    _authenticationStateStream.value = Authenticated(user: user);
    BaseService.dio.options.headers["Authorization"] = 'Bearer ${user.token}';
  }

  Future<void> signOut() async {
    _authenticationStateStream.value = UnAuthenticated();
    await _authService!.signOut();
    Get.offAllNamed('/');
  }
}
