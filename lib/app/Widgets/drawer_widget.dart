import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujay_app/app/constants/controllers.dart';
import 'package:ujay_app/app/controllers/authController.dart';
import 'package:ujay_app/app/views/mapViews/mapScreen.dart';
import 'package:ujay_app/app/views/mapViews/mapView.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  //FirebaseAuth _auth = FirebaseAuth.instance;
  //User user;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        // controller.firestoreUser.value!.uid;
        return Drawer(
          child: Material(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    controller.firestoreUser.value!.name,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    controller.firestoreUser.value!.email,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  arrowColor: Colors.white60,
                  currentAccountPicture: CircleAvatar(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      'assets/images/ujbackg.png',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  )),
                ),
                ListTile(
                  leading: Icon(Icons.map, color: Colors.blue),
                  title: Text('Visitors Parking Location'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.people_sharp, color: Colors.blue),
                  title: Text('Meet Your Student Ambassadors'),
                  onTap: () => null,
                ),
                ListTile(
                  leading:
                      Icon(Icons.medical_services_rounded, color: Colors.red),
                  title: Text('COVID-19 Announcement'),
                  onTap: () => Get.to(
                    MyLocation(),
                    fullscreenDialog: true,
                    transition: Transition.zoom,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.map, color: Colors.blue),
                  title: Text('Explore Campus Map'),
                  // onTap: () => Get.to(
                  //   //MapView(),
                  //   fullscreenDialog: true,
                  //   transition: Transition.zoom,
                  // ),
                ),
                ListTile(
                  leading: Icon(Icons.house_siding, color: Colors.black),
                  title: Text('Campus Buildings'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.yellowAccent),
                  title: Text('Find My Admission Representative'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.chat_rounded, color: Colors.red[400]),
                  title: Text('Social Media'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.restaurant, color: Colors.blueAccent),
                  title: Text('Local Restaurant Suggestions'),
                  onTap: () => null,
                ),
                Divider(
                  color: Colors.black,
                  endIndent: 0.2,
                  indent: 0.2,
                ),
                ListTile(
                  onTap: () => null,
                  leading: Icon(Icons.share, color: Colors.blue),
                  title: Text('Share'),
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.black),
                  title: Text('Settings'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.black),
                  title: Text('Log Out'),
                  onTap: authController.signOut,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
