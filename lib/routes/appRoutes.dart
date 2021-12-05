import 'package:get/get.dart';
import 'package:ujay_app/app/Widgets/splash.dart';
import 'package:ujay_app/app/views/HomePage.dart';
import 'package:ujay_app/app/views/Login.dart';
import 'package:ujay_app/app/views/SignUp.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => Splash()),
    GetPage(name: '/signin', page: () => Login()),
    GetPage(name: '/signup', page: () => SignUp()),
    GetPage(name: '/home', page: () => HomePage()),
    // GetPage(name: '/settings', page: () => SettingsUI()),
    // GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    // GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
  ];
}
