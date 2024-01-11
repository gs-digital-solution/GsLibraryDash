
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:equatable/equatable.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/authController.dart';
import 'package:gslibrarydashboard/features/auth/auth/model/adminUser.dart';
import 'package:gslibrarydashboard/features/auth/auth/services/authservice.dart';


class LoginController extends GetxController {
  final AuthController _authController = Get.find();
  final _loginStateStream = LoginState().obs;
  LoginState get state => _loginStateStream.value;

  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();

  RxString countryId = '237'.obs;
  RxBool phoneOrEmail = true.obs;
  RxBool obscure = true.obs;
  RxString message = ''.obs;
  RxBool sendCode = false.obs;
  RxBool forgot = false.obs;
  RxString codeSend = ''.obs;
  AdminUser? user;

  void changePhoneOrEmail() {
    phoneOrEmail.value = !phoneOrEmail.value;
  }

  void visibility() {
    obscure.value = !obscure.value;
  }

  Future<bool> login() async {
    _loginStateStream.value = LoginLoading();
    print(email!.text);
    print(password!.text);
    try {
      await _authController.login(email: email!.text, password: password!.text);
      _loginStateStream.value = LoginSuccess();
      email!.clear();
      password!.clear();
      return true;
    } on AuthException catch (e) {
      _loginStateStream.value = LoginFailure(error: e.message!);
      return false;
    }
  }

  String? validateEmail(String value) {
    if (GetUtils.isEmail(value)) {
      return null;
    } else {
      return "Enter a valid email";
    }
  }

  String? validatephoneNumber(String value) {
    if (GetUtils.isPhoneNumber(value)) {
      return null;
    } else {
      return "Enter a valid phone number";
    }
  }

  String? validatePassword(String value) {
    if (value.length > 6) {
      return null;
    } else {
      return "Password must be of 6 characters";
    }
  }

  String? validateConfirmPassword(String password, String confirm) {
    if (password == confirm) {
      return null;
    } else {
      return "passwords_not_match".tr;
    }
  }
}


class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}