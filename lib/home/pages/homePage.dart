import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/common/common.dart';
import 'package:gslibrarydashboard/features/auth/auth/controller/authController.dart';
import 'package:gslibrarydashboard/features/author/controllers/authorController.dart';
import 'package:gslibrarydashboard/features/author/screens/addAuthorPage.dart';
import 'package:gslibrarydashboard/features/author/screens/authorPage.dart';
import 'package:gslibrarydashboard/features/books/pages/addBook.dart';
import 'package:gslibrarydashboard/features/books/pages/bookPage.dart';
import 'package:gslibrarydashboard/features/categories/controller/categoryController.dart';
import 'package:gslibrarydashboard/features/categories/screens/addCategoryPage.dart';
import 'package:gslibrarydashboard/features/categories/screens/categoryPage.dart';
import 'package:gslibrarydashboard/features/commandes/pages/commandePage.dart';
import 'package:gslibrarydashboard/features/commandes/pages/new_commande.dart';
import 'package:gslibrarydashboard/features/countries/pages/addCountryPage.dart';
import 'package:gslibrarydashboard/features/countries/pages/country_page.dart';
import 'package:gslibrarydashboard/features/dashboard/pages/dashboardPage.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/controllers/exchange_rate_controller.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/pages/add_exchange_rate_page.dart';
import 'package:gslibrarydashboard/features/exchanges-rates/pages/exchange_rate_page.dart';
import 'package:gslibrarydashboard/features/investors/controllers/investor_controller.dart';
import 'package:gslibrarydashboard/features/investors/screens/add_investor_page.dart';
import 'package:gslibrarydashboard/features/investors/screens/investor_page.dart';
import 'package:gslibrarydashboard/features/payment_methods/pages/add_payment_method_page.dart';
import 'package:gslibrarydashboard/features/payment_methods/pages/payment_method_page.dart';
import 'package:gslibrarydashboard/features/promos/controller/promocontroller.dart';
import 'package:gslibrarydashboard/features/promos/screens/addpromopage.dart';
import 'package:gslibrarydashboard/features/promos/screens/promoPage.dart';
import 'package:gslibrarydashboard/features/retraits/pages/addRetrait.dart';
import 'package:gslibrarydashboard/features/retraits/pages/retraitPage.dart';
import 'package:gslibrarydashboard/features/sliders/screens/add_slider_page.dart';
import 'package:gslibrarydashboard/features/sliders/screens/slider_page.dart';
import 'package:gslibrarydashboard/features/transfertsBooks/pages/transfertpage.dart';
import 'package:gslibrarydashboard/features/users/pages/userpage.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';
import 'package:gslibrarydashboard/main.dart';
import 'package:gslibrarydashboard/theme/app_theme.dart';
import 'package:gslibrarydashboard/theme/color_scheme.dart';
import 'package:gslibrarydashboard/theme/theme_controller.dart';
import 'package:gslibrarydashboard/utils/constants.dart';
import 'package:gslibrarydashboard/features/partners/screens/addPartnerPage.dart';
import 'package:gslibrarydashboard/features/partners/screens/partnerPage.dart';
import 'package:gslibrarydashboard/features/partners/controllers/partnerController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());
  final AuthorController authorController = Get.put(AuthorController());
  final InvestorController investorController = Get.put(InvestorController());
  final CategoryController categoryController = Get.put(CategoryController());
  final PromoController promoController = Get.put(PromoController());
  final PartnerController partnerController = Get.put(PartnerController());
  final ExchangeRateController exchangeRateController =
      Get.put(ExchangeRateController());

  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return Theme(
      data: Theme.of(context),
      child: Obx(
        () => AdminScaffold(
          backgroundColor: getBackgroundColor(context),
          appBar: AppBar(
            backgroundColor: getCardColor(context),
            title: getMaxLineFont(
              context,
              'GSLIBRARY',
              85,
              getPrimaryColor(context),
              1,
              customFont: Constants.headerFontsFamily,
              fontWeight: FontWeight.w700,
            ),
            systemOverlayStyle: getBrightnessLight(),
            elevation: 0,
            toolbarHeight: 70.h,
            // leadingWidth: Responsive.isDesktop(context) ? 0 : 100.w,
            actions: [
              Container(
                decoration: getDefaultDecoration(
                    borderColor: getBorderColor(context),
                    borderWidth: 0.5,
                    radius: getResizeRadius(context, 40)),
                margin: EdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                child: Row(
                  children: [
                    imageSvg('dark_mode.svg',
                        height: 20.h,
                        width: 20.h,
                        color: themeController.checkDarkTheme()
                            ? getPrimaryColor(context)
                            : getSubFontColor(context), onTap: () {
                      /* if (!themeController.checkDarkTheme()) {
                        themeController.changeTheme(context);
                      } */
                    }),
                    Container(
                      height: 20.h,
                      color: getBorderColor(context),
                      width: 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 15.h),
                    ),
                    imageSvg('light_mode.svg',
                        height: 20.h,
                        width: 20.h,
                        color: themeController.checkDarkTheme()
                            ? getSubFontColor(context)
                            : getPrimaryColor(context), onTap: () {
                      if (themeController.checkDarkTheme()) {
                        themeController.changeTheme(context);
                      }
                    }),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.h),
              ),

              // buildPopupMenuButton((value) {
              //   handleClick(value);
              // }).marginSymmetric(horizontal: 20.h),

              GestureDetector(
                onTap: () {
                  _showPopupMenu();
                },
                child: Container(
                        alignment: Alignment.center,
                        child: imageAsset(
                            themeController.checkDarkTheme()
                                ? 'profile_dark.png'
                                : 'profile.png',
                            height: 40.h,
                            width: 40.h))
                    .marginSymmetric(horizontal: 20.h),
              )
            ],
          ),
          sideBar: SideBar(
            backgroundColor: getCardColor(context),
            iconColor: Theme.of(context).primaryColor,
            activeBackgroundColor: themeController.checkDarkTheme()
                ? darkSubCardColor
                : alphaColor,
            activeIconColor: Theme.of(context).primaryColor,
            textStyle: TextStyle(
              decoration: TextDecoration.none,
              fontSize: getResizeFont(context, 50),
              fontStyle: FontStyle.normal,
              color: getSubFontColor(context),
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
            activeTextStyle: TextStyle(
              decoration: TextDecoration.none,
              fontSize: getResizeFont(context, 50),
              fontStyle: FontStyle.normal,
              color: getPrimaryColor(context),
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
            items: const [
              AdminMenuItem(
                title: 'Dashboard',
                route: '/',
                icon: Icons.dashboard,
              ),
              AdminMenuItem(
                  title: 'Code Promos',
                  icon: Icons.padding,
                  children: [
                    AdminMenuItem(
                      title: 'Liste des codes promos',
                      icon: Icons.list,
                      route: '/promos',
                    ),
                    AdminMenuItem(
                      title: 'ajouter un code',
                      icon: Icons.add,
                      route: '/promos/add',
                    ),
                  ]),
              AdminMenuItem(
                title: 'Utilisateurs',
                route: '/users',
                icon: Icons.dashboard,
              ),
              AdminMenuItem(
                title: 'Transfert de livre',
                route: '/transferts',
                icon: Icons.book,
              ),
              AdminMenuItem(
                title: 'Investisseurs',
                icon: Icons.person,
                children: [
                  AdminMenuItem(
                    title: 'Liste des investisseurs',
                    icon: Icons.list,
                    route: '/investors',
                  ),
                  AdminMenuItem(
                    title: 'ajouter un investisseur',
                    icon: Icons.add,
                    route: '/investors/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Categories',
                icon: Icons.category,
                children: [
                  AdminMenuItem(
                    title: 'Liste des categories',
                    icon: Icons.list,
                    route: '/categories',
                  ),
                  AdminMenuItem(
                    title: 'Ajouter une categorie',
                    icon: Icons.add,
                    route: '/categories/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Auteurs',
                icon: Icons.person,
                children: [
                  AdminMenuItem(
                    title: 'Liste des Auteur',
                    icon: Icons.list,
                    route: '/authors',
                  ),
                  AdminMenuItem(
                    title: 'Ajouter un auteur',
                    icon: Icons.add,
                    route: '/authors/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Livres',
                icon: Icons.person,
                children: [
                  AdminMenuItem(
                    title: 'Liste des livres',
                    icon: Icons.list,
                    route: '/books',
                  ),
                  AdminMenuItem(
                    title: 'ajouter un livre',
                    icon: Icons.add,
                    route: '/books/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Sliders',
                icon: Icons.category,
                children: [
                  AdminMenuItem(
                    title: 'Sliders',
                    icon: Icons.list,
                    route: '/sliders',
                  ),
                  AdminMenuItem(
                    title: 'Ajouter un slider',
                    icon: Icons.add,
                    route: '/sliders/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Transactions',
                icon: Icons.history,
                route: '/transactions',
                children: [
                  AdminMenuItem(
                    title: 'Commandes',
                    icon: Icons.list,
                    route: '/transactions/commandes',
                  ),
                  AdminMenuItem(
                    title: 'Nouvelle commande',
                    icon: Icons.add,
                    route: '/transactions/commandes/add',
                  ),
                  AdminMenuItem(
                    title: 'Paiements',
                    icon: Icons.list,
                    route: '/transactions/retraits',
                  ),
                  AdminMenuItem(
                    title: 'Nouveau paiement',
                    icon: Icons.add,
                    route: '/transactions/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Pays',
                icon: Icons.flag_rounded,
                route: '/countries',
                children: [
                  AdminMenuItem(
                    title: 'Pays',
                    icon: Icons.list,
                    route: '/countries',
                  ),
                  AdminMenuItem(
                    title: 'Nouveau Pays',
                    icon: Icons.add,
                    route: '/countries/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Methode de paiements',
                icon: Icons.flag_rounded,
                route: '/paymentMethods',
                children: [
                  AdminMenuItem(
                    title: 'Methode de paiements',
                    icon: Icons.list,
                    route: '/paymentMethods',
                  ),
                  AdminMenuItem(
                    title: 'Nouvelle Methode de paiement',
                    icon: Icons.add,
                    route: '/paymentMethods/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Taux d\'echanges',
                icon: Icons.currency_exchange,
                route: '/exchanges-rates',
                children: [
                  AdminMenuItem(
                    title: 'Taux d\'echanges',
                    icon: Icons.list,
                    route: '/exchanges-rates',
                  ),
                  AdminMenuItem(
                    title: 'nouveau taux d\'echange',
                    icon: Icons.add,
                    route: '/exchanges-rates/add',
                  ),
                ],
              ),
              AdminMenuItem(
                title: 'Partenaires',
                icon: Icons.person,
                route: '/partners',
                children: [
                  AdminMenuItem(
                    title: 'Partenaires',
                    icon: Icons.list,
                    route: '/partners',
                  ),
                  AdminMenuItem(
                    title: 'nouveau partenaire',
                    icon: Icons.add,
                    route: '/partners/add',
                  ),
                ],
              ),
            ],
            selectedRoute: homeController.selectedItem!.value.route!,
            onSelected: (item) {
              setState(() {
                homeController.selectedItem!.value = item;
              });
            },
          ),
          body: Obx(
            () {
              switch (homeController.selectedItem!.value.route) {
                case '/':
                  return DashboardPage();
                case '/users':
                  return UserPage();
                case '/transferts':
                  return TransfertPage();
                case '/categories':
                  return CategoryScreen();
                case '/categories/add':
                  return AddCategoryScreen();
                case '/authors':
                  return AuthorScreen();
                case '/authors/add':
                  return AddAuthorScreen();
                case '/books':
                  return StoryScreen();
                case '/books/add':
                  return AddStoryScreen();
                case '/transactions/commandes':
                  return CommandePage();
                case '/transactions/retraits':
                  return RetraitPage();
                case '/transactions/add':
                  return NewRetrait();
                case '/transactions/commandes/add':
                  return NewCommande();
                case '/sliders/add':
                  return AddSliderScreen();
                case '/sliders':
                  return SliderScreen();
                case '/investors/add':
                  return AddInvestorPage();
                case '/investors':
                  return InvestorPage();
                case '/promos':
                  return PromoScreen();
                case '/promos/add':
                  return AddPromoScreen();
                case '/countries':
                  return CountryPage();
                case '/countries/add':
                  return AddCountryPage();
                case '/paymentMethods':
                  return PaymentMethodPage();
                case '/paymentMethods/add':
                  return AddPaymentMethodPage();
                case '/exchanges-rates':
                  return ExchangeRatePage();
                case '/exchanges-rates/add':
                  return AddExchangeRatePage();
                case '/partners':
                  return PartnerPage();
                case '/partners/add':
                  return AddPartnerPage();

                default:
                  return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget imageAsset(String icon,
      {required double height,
      required double width,
      Color? color,
      BoxFit? boxFit}) {
    return Image.asset(
      Constants.assetPath + icon,
      height: height,
      width: width,
      color: color == null ? null : color,
      fit: boxFit == null ? null : boxFit,
    );
  }

  Widget imageSvg(String icon,
      {required double height,
      required double width,
      Color? color,
      String? folder,
      Function? onTap,
      BoxFit? boxFit}) {
    return GestureDetector(
      child: SvgPicture.asset(
        folder == null ? Constants.assetSvgPath + icon : folder + icon,
        height: height,
        width: width,
        // ignore: deprecated_member_use
        color: color == null ? null : color,
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }

  void _showPopupMenu() async {
    double width = isWeb(context) ? 120.w : 150.h;

    double right = isWeb(context) ? 50.h : 15.h;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(50.w, 50.h, right, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      color: getCardColor(context),
      items: [
        PopupMenuItem<String>(
            child: Container(
              width: width,
              child: DrawerListTile(
                title: "Change Password",
                iconData: Icons.account_circle_sharp,
                space: 0,
                press: () {},
              ),
            ),
            value: 'Change Password'),
        PopupMenuItem<String>(
            child: Container(
              width: width,
              child: DrawerListTile(
                title: "Se Deconnecter",
                iconData: Icons.account_circle_sharp,
                space: 0,
                color: Colors.red,
                visibility: false,
                press: () {
                  // onTap(homePage);

                  // getCommonDialog(
                  //     context: context,
                  //     subTitle: "Log Out",
                  //     title: "Are you sure want to Log out ?",
                  //     function: () {
                  //       LoginData.sendLoginPage();
                  //     });

                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: getCustomFont(
                            "Se Deconnecter",
                            getResizeFont(context, 70),
                            getFontColor(context),
                            1,
                            fontWeight: FontWeight.w600),
                        content: getCustomFont(
                            "Voulez-vous vous deconnecter ?",
                            getResizeFont(context, 50),
                            getFontColor(context),
                            1),
                        actions: <Widget>[
                          TextButton(
                            child: getCustomFont(
                                "OUI",
                                getResizeFont(context, 50),
                                getPrimaryColor(context),
                                1,
                                fontWeight: FontWeight.w500),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              Get.find<AuthController>().signOut();
                              // LoginData.sendLoginPage();
                            },
                          ),
                          TextButton(
                            child: getCustomFont(
                                "NON",
                                getResizeFont(context, 50),
                                getPrimaryColor(context),
                                1,
                                fontWeight: FontWeight.w500),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();

                              Navigator.of(dialogContext).pop();

                              // Dismiss alert dialog
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // LoginData.sendLoginPage();

                  // loginController.logout();
                  // Get.toNamed(KeyUtil.loginWidget);
                },
              ),
            ),
            value: 'Log Out'),
      ],
      elevation: 1.0,
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.iconData,
    required this.press,
    this.visibility,
    this.color,
    this.space,
    this.child,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback press;
  final Color? color;
  final Widget? child;
  final double? space;
  final bool? visibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 25.h,
          ),
          child: InkWell(
            onTap: () {
              press();
            },
            child: Row(
              children: [
                Expanded(
                    child: getMaxLineFont(context, title, 50,
                        color == null ? getFontColor(context) : color!, 1,
                        fontWeight: FontWeight.w500)),
                child == null ? Container() : child!
              ],
            ),
          ),
        ),
        Visibility(
          visible: (visibility == null) ? true : visibility!,
          child: Container(
            color: getBorderColor(context),
            width: double.infinity,
            height: 0.5,
          ),
        )
      ],
    ).marginSymmetric(horizontal: space == null ? 35.w : space!);
  }
}
