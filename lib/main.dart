import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/constants/firebaseCons.dart';
import 'app/controllers/authController.dart';
import 'routes/appRoutes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization.then((value) {
    Get.put(AuthController());
    //Get.put(AppController());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          // brightness: Brightness.dark,
          primaryColor: Colors.lightBlue,
          backgroundColor: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: AppRoutes.routes,
    );
  }
}
