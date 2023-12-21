import 'dart:convert';
import 'package:gslibrarydashboard/features/auth/auth/model/adminUser.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrefData {
  static String pkgName = "story_admin_panel";
  static String login = pkgName + "login";
  static String keyIsAccess = pkgName + "access";
  static String keyLoginId = pkgName + "loginId";
  static String keyAction = pkgName + "action";

  static setLogin(bool s, String id, bool isAccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(login, s);
    prefs.setString(keyLoginId, id);
    prefs.setBool(keyIsAccess, isAccess);
  }
  static Future<int> getAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyAction) ?? 0;
  }

  static setAction(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(keyAction, value);
  }

  Future<AdminUser?> getAdminUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("user")==null){
      return null;
    }
    AdminUser? adminUser =
        AdminUser.fromJson(json.decode(prefs.getString("user")!));
    return adminUser;
  }

  static removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }

  static setAdminUser(AdminUser adminUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", json.encode(adminUser.toJson()));
  }
}
