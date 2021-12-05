import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujay_app/app/controllers/authController.dart';
import 'package:ujay_app/app/controllers/searchServices.dart';
import 'package:ujay_app/app/views/mapViews/mapScreen.dart';
import '../Widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  var queryResultSet = [];
  var tempSearchPlace = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchPlace = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data);
        }
      });
    } else {
      tempSearchPlace = [];
      queryResultSet.forEach((element) {
        if (element['name'].startWith(capitalizedValue)) {
          setState(() {
            tempSearchPlace.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return Scaffold(
          drawer: NavDrawer(),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 25),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello ${controller.firestoreUser.value!.name}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text('Welcome to University of Jos',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {},
                      )
                    ],
                  ),
                  SizedBox(height: 100),
                  Container(
                    height: 150,
                    width: 40,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text("Let\'s Discover Around",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 5),
                        Text("Find places on campus",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60)),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              MyLocation(),
                              fullscreenDialog: true,
                              transition: Transition.zoom,
                            );
                          },
                          child: Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.all(8 * 2),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.blue;
                                return Colors.white;
                              })),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/Artboard 1@2X-80.jpg")),
                            // color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                          ),
                            ),
                      ),
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.yellow[400],
                            borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                              'Audio Tour',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                          ),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.pink[400],
                            borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                              'VR Tour Guide',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                          ),
                            ),
                      ),
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent[400],
                            borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                              'AR Tour guide',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                          ),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                              '...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                          ),
                            ),
                      ),
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                              'Help',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                          ),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//   Widget buildResultCard(data) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 2.0,
//       child: Container(
//         child: Text(
//           data['name'],
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

//Container(
//   child: NestedScrollView(
//     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//       return <Widget>[
//         SliverAppBar(
//           backgroundColor: Color(0xff010024),
//           expandedHeight: 200,
//           floating: true,
//           pinned: true,
//           actions: [
//             IconButton(icon: Icon(Icons.person), onPressed: () => null)
//           ],
//           flexibleSpace: FlexibleSpaceBar(
//             background: Image.asset("assets/images/UJCampusTour.png"),
//             //title: Text('UJ Campus Tour'),
//             centerTitle: true,
//           ),
//         ),
//         //
//       ];
//     },
//     body: Center(
//       child: Container(
//         //height: 100,
//         width: MediaQuery.of(context).size.width,

//         child: ListView(
//           children: [
//             SizedBox(height: 80),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 children: [
//                   Icon(Icons.person_pin),
//                   SizedBox(
//                     width: 2,
//                   ),
//                   Text(
//                     'Discover',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //SizedBox(height: 5),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Get.to(MapPage());
//                 },
//                 child: Container(
//                   height: 70,
//                   width: 10,
//                   //color: Colors.deepPurpleAccent,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: [
//                       new BoxShadow(
//                         color: Colors.black26,
//                         offset: new Offset(5.0, 5.0),
//                         blurRadius: 5.0,
//                       )
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           //color: Colors.red,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4L-9Cw2Ksr6gqdtiiVyl7AozPUSVFTzym9Xo5qpGlqkyKUK3QumqUNRGSPwY8jZWYZjs&usqp=CAU'))),
//                         ),
//                         SizedBox(width: 8),
//                         Column(
//                           children: [
//                             SizedBox(height: 8),
//                             Text(
//                               'UNIJOS Self-Guided Tours',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 //fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.person_pin_circle_rounded,
//                                   color: Colors.blueGrey[200],
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text(
//                                   'University Of Jos, Main Camps',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Get.to(MapPage());
//                 },
//                 child: Container(
//                   height: 70,
//                   width: 10,
//                   //color: Colors.deepPurpleAccent,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: [
//                       new BoxShadow(
//                         color: Colors.black26,
//                         offset: new Offset(5.0, 5.0),
//                         blurRadius: 5.0,
//                       )
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           //color: Colors.red,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4L-9Cw2Ksr6gqdtiiVyl7AozPUSVFTzym9Xo5qpGlqkyKUK3QumqUNRGSPwY8jZWYZjs&usqp=CAU'))),
//                         ),
//                         SizedBox(width: 8),
//                         Column(
//                           children: [
//                             SizedBox(height: 8),
//                             Text(
//                               'UNIJOS Self-Guided Tours',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 //fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.person_pin_circle_rounded,
//                                   color: Colors.blueGrey[200],
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text(
//                                   'University Of Jos, Permanent Site',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   ),
// ),

// RaisedButton(
//                           padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
//                           onPressed: signOut,
//                           child: Text('Signout',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20.0,
//                                   fontWeight: FontWeight.bold)),
//                           color: Colors.orange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                         )

// DefaultTabController(
//   length: 1,
//   child: Expanded(
//     child: Column(
//       children: [
//         TabBar(
//           indicatorColor: Color(0xFFFFFFFF),
//           unselectedLabelColor: Color(0xFFFFFFFF),
//           labelColor: Color(0xFF080200),
//           labelPadding:
//               EdgeInsets.symmetric(horizontal: 8.0),
//           tabs: [
//             Tab(
//               text: "Discover",
//             ),
//             // Tab(
//             //   text: "Promotion",
//             // ),
//             // Tab(
//             //   text: "Favorites",
//             // ),
//           ],
//         ),
//         SizedBox(
//           height: 20.0,
//         ),
//         Container(
//           height: 300.0,
//           child: TabBarView(
//             children: [
//               //Now let's create our first tab page
//               Container(
//                   child: StreamBuilder<QuerySnapshot>(
//                 stream: db.collection('POI').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: Text('No data'));
//                   }
//                   if (snapshot.hasError) {
//                     return Center(
//                         child: Text('Error loading data'));
//                   }
//                   if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Center(
//                         child: CircularProgressIndicator());
//                   }
//                   final data = snapshot.requireData;
//                   return ListView.builder(
//                     itemCount: data.size,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder:
//                         (BuildContext context, index) {
//                       return placeCard(
//                           context, data.docs[index]);
//                     },
//                   );
//                 },
//               )),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
// Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Text('Faculties',
//         style: TextStyle(
//           color: Colors.black,
//           decoration: TextDecoration.none,
//           fontSize: 20,
//         )),
//     SizedBox(height: 10),
//     Container(
//       height: 250,
//       child: ListView.builder(
//           itemCount: faculty.length,
//           scrollDirection: Axis.horizontal,
//           itemBuilder: (context, index) => FacultyCard(
//               itemIndex: index,
//               faculty: faculty[index],
//               press: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => DetailsScreen(
//                 //       product: products[index],
//                 //     ),
//                 //   ),
//                 // );
//               })),
//     ),
//   ],
// ),
