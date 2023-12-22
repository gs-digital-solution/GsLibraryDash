
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/loginController.dart';
import 'package:gslibrarydashboard/main.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/utils/app_routes.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:gslibrarydashboard/utils/responsive.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  RxBool isProgress = false.obs;
  RxBool isSignUp = false.obs;

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: (Get.isDarkMode)
            ? getCardColor(context)
            : getBackgroundColor(context),
        body: SafeArea(
          child: Container(
            child: Row(
              children: [
                Visibility(
                    visible: Responsive.isDesktop(context),
                    child: Expanded(child: Container())),
                Expanded(
                  child: Obx(
                    () => (isSignUp.value) ? getSignUpView() : getLoginView(),
                  ),
                ),
                Visibility(
                    visible: Responsive.isDesktop(context),
                    child: Expanded(child: Container()))
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Constants.exitApp();
        return false;
      },
    );
  }

  getLoginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          color: (Get.isDarkMode)
              ? getBackgroundColor(context)
              : getCardColor(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(getResizeRadius(context, 25))),
          margin: EdgeInsets.symmetric(vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(context, 30),
              Align(
                alignment: Alignment.center,
                child: getTextWidget(
                  context,
                  'Login',
                  100,
                  getFontColor(context),
                  fontWeight: FontWeight.bold,
                  customFont: Constants.headerFontsFamily,
                ),
              ),
              getVerticalSpace(context, 30),
              getTextWidget(
                context,
                'Email',
                40,
                getFontColor(context),
                fontWeight: FontWeight.w500,
              ),
              getVerticalSpace(context, 15),
              getDefaultTextFiledWidget(
                context,
                "Email",
                loginController.email!,
              ),
              getVerticalSpace(context, 30),
              getTextWidget(
                context,
                'Password',
                40,
                getFontColor(context),
                fontWeight: FontWeight.w500,
              ),
              getVerticalSpace(context, 15),
              getPasswordTextFiledWidget(
                  context, "Password", loginController.password!,
                  onSubmit: (value) async {
                if (await loginController.login()) {
                  Constants.pushPage(KeyUtil.homePage, function: (value) {});
                } else {
                  Fluttertoast.showToast(
                    msg: (loginController.state as LoginFailure).error,
                    backgroundColor: Colors.red,
                  );
                }
              }),
              getVerticalSpace(context, 30),
              Obx(() {
                return getButtonWidget(context, 'Log In', () async {
                  if (await loginController.login()) {
                    
                    Constants.pushPage(KeyUtil.homePage, function: (value) {});
                  } else {
                    Fluttertoast.showToast(
                      msg: (loginController.state as LoginFailure).error,
                      backgroundColor: Colors.red,
                    );
                  }
                },
                    isProgress:loginController.state is LoginLoading?true:false,
                    horizontalSpace: 0,
                    bgColor: primaryColor,
                    textColor: Colors.white,
                    verticalSpace: 0);
              }),
              getVerticalSpace(context, 15),
              /*   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5.h,
                          ),
                          InkWell(
                            onTap: () {
                              isSignUp.value = true;
                              passwordController.text = "";
                              emailController.text = "";
                              confirmPasswordController.text = "";
                            },
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ), */
              /* StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(KeyTable.adminData)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!.size > 0) {
                    print("sna-----------${snapshot.data}");

                    return Container();

                    // if(snapshot.connectionState == ConnectionState.active){
                    //   return Container();
                    // }else{
                    //   return Container();
                    // }
                  } else {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5.h,
                          ),
                          InkWell(
                            onTap: () {
                              isSignUp.value = true;
                              passwordController.text = "";
                              emailController.text = "";
                              confirmPasswordController.text = "";
                            },
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }
                },
              ), */
              getVerticalSpace(context, 30),
            ],
          ).paddingSymmetric(horizontal: 30.h),
        ),
      ],
    ).marginSymmetric(horizontal: Responsive.isDesktop(context) ? 0.h : 15.h);
    // ).marginSymmetric(horizontal: Responsive.isDesktop(context)?200.h:15.h);
  }

  getSignUpView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          color: (Get.isDarkMode)
              ? getBackgroundColor(context)
              : getCardColor(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(getResizeRadius(context, 25))),
          margin: EdgeInsets.symmetric(vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(context, 30),
              Align(
                alignment: Alignment.center,
                child: getTextWidget(
                    context, 'Admin', 70, getFontColor(context),
                    fontWeight: FontWeight.bold,
                    customFont: Constants.fontsFamily),
              ),
              getVerticalSpace(context, 30),
              getTextWidget(
                context,
                'Email',
                40,
                getFontColor(context),
                fontWeight: FontWeight.w500,
              ),
              getVerticalSpace(context, 15),
              getDefaultTextFiledWidget(context, "Email", emailController),
              getVerticalSpace(context, 30),
              getTextWidget(
                context,
                'Password',
                40,
                getFontColor(context),
                fontWeight: FontWeight.w500,
              ),
              getVerticalSpace(context, 15),
              getPasswordTextFiledWidget(
                context,
                "Password",
                passwordController,
                onSubmit: (value) {
                  isProgress.value = true;
                  // _login();
                },
              ),
              getVerticalSpace(context, 30),
              getTextWidget(
                context,
                'Confirm Password',
                40,
                getFontColor(context),
                fontWeight: FontWeight.w500,
              ),
              getVerticalSpace(context, 15),
              getPasswordTextFiledWidget(
                context,
                "Confirm Password",
                confirmPasswordController,
                onSubmit: (value) {
                  isProgress.value = true;
                  // _login();
                },
              ),
              getVerticalSpace(context, 30),
              Obx(() {
                return getButtonWidget(context, 'Create', () {
                  isProgress.value = true;
                  signUp();
                },
                    isProgress: isProgress.value,
                    horizontalSpace: 0,
                    bgColor: primaryColor,
                    textColor: Colors.white,
                    verticalSpace: 0);
              }),
              getVerticalSpace(context, 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5.h,
                  ),
                  InkWell(
                    onTap: () {
                      isSignUp.value = false;

                      passwordController.text = "";
                      emailController.text = "";
                      confirmPasswordController.text = "";
                    },
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              getVerticalSpace(context, 30),
            ],
          ).paddingSymmetric(horizontal: 30.h),
        ),
      ],
    ).marginSymmetric(horizontal: Responsive.isDesktop(context) ? 0.h : 15.h);
    // ).marginSymmetric(horizontal: Responsive.isDesktop(context)?200.h:15.h);
  }

  getSideSpace() {
    return Responsive.isDesktop(context) || Responsive.isTablet(context)
        ? Expanded(
            child: Container(),
            flex: 1,
          )
        : Container().marginSymmetric(horizontal: 15.h);
  }



  bool checkValidation() {
    if (isNotEmpty(emailController.text) &&
        isValidEmail(emailController.text)) {
      if (isNotEmpty(passwordController.text)) {
        if (passwordController.text.length >= 6) {
          if (passwordController.text == confirmPasswordController.text) {
            return true;
          } else {
            showCustomToast(
                context: context, message: "Password dose not match");
            return false;
          }
        } else {
          showCustomToast(
              context: context,
              message: "You must have 6 characters in your password");
          return false;
        }
      } else {
        showCustomToast(context: context, message: "Enter Password");
        return false;
      }
    } else {
      showCustomToast(context: context, message: "Email not valid");
      return false;
    }
  }

  void signUp() async {
    if (checkValidation()) {}

    isProgress.value = false;
  }
}
