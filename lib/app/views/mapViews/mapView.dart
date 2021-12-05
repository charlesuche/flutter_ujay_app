// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:ujay_app/app/controllers/searchServices.dart';

// class MapView extends StatefulWidget {
//   @override
//   _MapViewState createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   final TextEditingController searchController = TextEditingController();
//   late QuerySnapshot snapshotData;
//   bool isExcuted = false;
//   late BitmapDescriptor sourceIcon;
//   late BitmapDescriptor destinationIcon;
//   late BitmapDescriptor pinLocationIcon;
//   final Location location = new Location();
//   final Geolocator _geolocator = Geolocator();
//   late LatLng currentLocation;
//   late LatLng destinationLocation;
//   var _destinationMarkersCount = 0;
//   List<LatLng> routeCoords = [];
//   List<Polyline> _polylines = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   late GoogleMapController mapController;
//   var queryResultSet = [];
//   var tempSearchPlace = [];
//   // var sites = [];
//   // var sitesActual;
//   var currentBearing;
//   bool mapToggle = false;
//   bool sitesToggle = false;
//   bool resetToggle = false;

//   @override
//   Widget build(BuildContext context) {
//     // ignore: non_constant_identifier_names
//     Widget SearchedData() {
//       return ListView.builder(
//         itemCount: snapshotData.docs.length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               print(snapshotData.docs[index]['name']);
//               mapController
//                   .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//                 target: LatLng(destinationLocation.latitude,
//                     destinationLocation.longitude),
//                 zoom: 14.5,
//                 tilt: 50.0,
//               )));
//             },
//             child: ListTile(
//               trailing: Icon(Icons.arrow_forward_ios),
//               title: Text(snapshotData.docs[index]['name']),
//               subtitle: Text(snapshotData.docs[index]['searchKey']),
//             ),
//           );
//         },
//       );
//     }

//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               color: Color(0xFF000000).withOpacity(0.5),
//               icon: Icon(Icons.arrow_back_ios),
//               onPressed: () {
//                 setState(() {
//                   isExcuted = false;
//                 });
//               }),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           shape:
//               BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//           actions: [
//             GetBuilder<SearchController>(
//                 init: SearchController(),
//                 builder: (val) {
//                   return IconButton(
//                       icon: Icon(
//                         Icons.search,
//                         color: Color(0xFF000000).withOpacity(0.5),
//                       ),
//                       onPressed: () {
//                         val.queryData(searchController.text).then((value) {
//                           snapshotData = value;
//                           setState(() {
//                             isExcuted = true;
//                           });
//                         });
//                       });
//                 }),
//           ],
//           // title: TextField(
//             cursorColor: Color(0xFF000000),
//             controller: searchController,
//             decoration: InputDecoration(
//                 hintText: 'Find place on campus', border: InputBorder.none),
//           ),
//         ),
//         body: isExcuted
//             ? SearchedData()
//             : Stack(
//                 children: [
//                   Positioned.fill(
//                     child: GoogleMap(
//                       markers: Set<Marker>.of(markers.values),
//                       polylines: Set<Polyline>.from(_polylines),
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: true,
//                       mapToolbarEnabled: true,
//                       compassEnabled: true,
//                       zoomControlsEnabled: false,
//                       mapType: MapType.satellite,
//                       initialCameraPosition: _initialCameraPosition,
//                       onMapCreated: _onMapCreated,
//                       onTap: (argument) {
//                         FocusScope.of(context).requestFocus(new FocusNode());
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Theme.of(context).primaryColor,
//           foregroundColor: Colors.black,
//           child: const Icon(Icons.center_focus_strong),
//           onPressed: () => mapController.animateCamera(
//               CameraUpdate.newCameraPosition(_initialCameraPosition)),
//         ));
//   }

//   void _onMapCreated(controller) {
//     //_controller.complete(controller);
//     setState(() {
//       mapController = controller;
//     });
//   }

//   initiateSearch(value) {
//     if (value.length == 0) {
//       setState(() {
//         queryResultSet = [];
//         tempSearchPlace = [];
//       });
//     }
//     var capitalizedValue =
//         value.substring(0, 1).toUpperCase() + value.substring(1);
//     if (queryResultSet.length == 0 && value.length == 1) {
//       SearchService().searchByName(value).then((QuerySnapshot docs) {
//         for (int i = 0; i < docs.docs.length; ++i) {
//           queryResultSet.add(docs.docs[i].data);
//         }
//       });
//     } else {
//       tempSearchPlace = [];
//       queryResultSet.forEach((element) {
//         if (element['name'].startWith(capitalizedValue)) {
//           setState(() {
//             tempSearchPlace.add(element);
//           });
//         }
//       });
//     }
//   }

//   @override
//   void initState() {
//     getMarkerData();
//     mapToggle = true;
//     //setCustomMapPin();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   static const _initialCameraPosition =
//       CameraPosition(target: LatLng(9.948446, 8.890408), zoom: 17);

//   void initMarker(specify, specifyId) async {
//     var markerIdVal = specifyId;
//     final MarkerId markerId = MarkerId(markerIdVal);
//     final Marker marker = Marker(
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       onTap: () {
//         print(specify['name']);

//         showModalBottomSheet(
//             context: context,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             )),
//             elevation: 10.0,
//             enableDrag: true,
//             builder: (BuildContext context) {
//               return ListView(
//                 children: [
//                   Container(
//                     height: 250,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: NetworkImage(specify['imgUrl']),
//                             fit: BoxFit.cover)),
//                     //child: Text(specify['name']),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 20, right: 20, top: 25),
//                     child: Column(
//                       children: [
//                         Text(
//                           specify['name'],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 22.0,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                         Text(
//                           specify['desc'].toString(),
//                         ),
//                         ListTile(
//                           title: Text('Offices'),
//                           trailing: Icon(Icons.arrow_forward_ios),
//                           onTap: () {},
//                         ),
//                         Divider(
//                           color: Colors.black,
//                           height: 5,
//                         ),
//                         ListTile(
//                           title: Text('Direction'),
//                           trailing: Icon(Icons.arrow_forward_ios),
//                           onTap: () {
//                             Get.to(MapView());
//                           },
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             });
//       },
//       markerId: markerId,
//       draggable: false,
//       position:
//           LatLng(specify['location'].latitude, specify['location'].longitude),
//       infoWindow: InfoWindow(
//         title: specify['name'],
//       ),
//     );

//     setState(() {
//       markers[markerId] = marker;
//       print(markerId);
//     });
//   }

//   getMarkerData() async {
//     FirebaseFirestore.instance.collection('POI').get().then((markerData) {
//       if (markerData.docs.isNotEmpty) {
//         setState(() {
//           sitesToggle = true;
//         });
//         for (int i = 0; i < markerData.docs.length; i++) {
//           initMarker(markerData.docs[i].data(), markerData.docs[i].id);
//         }
//       }
//     });
//   }

//   Future _setCurrentLocation() async {
//     var value = await location.getLocation();
//     setState(() {
//       currentLocation = LatLng(value.latitude!, value.longitude!);
//     });
//     return currentLocation;
//   }

//   _moveToDestinationLocation() {
//     var marker = Marker(
//       markerId: MarkerId("$MarkerId"),
//       position:
//           LatLng(destinationLocation.latitude, destinationLocation.longitude),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       visible: true,
//     );
//     setState(() {
//       //markers.addAll(marker);
//       //_markerId++;
//       _destinationMarkersCount++;
//     });
//     mapController.animateCamera(CameraUpdate.newLatLng(
//       destinationLocation,
//     ));
//   }

//   _animateToUserLocation() async {
//     await mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: currentLocation, zoom: 15)));
//   }

//   setPolylines() async {
//     setState(() {
//       _polylines = [];
//       routeCoords = [];

//       //remove previous destination marker
//       if (_destinationMarkersCount > 1) {
//         markers.remove(markers.length - 2);
//       }
//     });

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyCxZ3jXf61IUjFH-h876XFf5UgDQ9K9pKU",
//       PointLatLng(currentLocation.latitude, currentLocation.longitude),
//       PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
//       travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         routeCoords.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print("###################################");
//       print("Polyline result returned empty set!");
//       print("###################################");
//     }
//     setState(() {
//       Polyline polyline = Polyline(
//         polylineId: PolylineId("poly"),
//         color: Color.fromARGB(255, 40, 122, 198),
//         points: routeCoords,
//       );

//       _polylines.add(polyline);
//     });
//   }
// }
