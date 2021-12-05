// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ujay_app/model/polylines/polylineList.dart';

// class PolylineService {
//   final databaseReference = FirebaseFirestore.instance;

//   // Future<PolylineList> postPolylines() async {
//   //   return await rootBundle
//   //       .loadString('assets/json/polyline.json')
//   //       .then((onValue) {
//   //     databaseReference
//   //         .collection('pathPolylines')
//   //         .document()
//   //         .setData({'polylines': json.decode(onValue)});
//   //   });
//   // }

//   Future<List<LatLng>> fetchPolylines() async {
//     List<LatLng> pathPolylineList = [];
//     await databaseReference
//         .collection('POI')
//         .get()
//         .then((value) {
//       value.docs.forEach((element) =>

//           PolylineList.fromJson(element.data['polylines'])
//               .polylineList
//               .forEach((element) {
//             pathPolylineList.add(LatLng(element.lat, element.lng));
//           }));
//     });
//     return pathPolylineList;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';

const LatLng SOURCE_LOCATION = LatLng(38.423151, 27.13885);
const LatLng DEST_LOCATION = LatLng(38.420284, 27.14101);

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  static late BitmapDescriptor sourceIcon;
  static late BitmapDescriptor destinationIcon;
  Set<Marker> _markers = Set<Marker>();

  double pinPillPosition = PIN_INVISIBLE_POSITION;

  late LatLng currentLocation;
  late LatLng destinationLocation;
  bool userBadgeSelected = true;

  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();

    // set up initial location
    this.setInitialLocation();

    // set up the marker icons
    this.setSourceAndDestinationMarkerIcons();
  }

  void setSourceAndDestinationMarkerIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              devicePixelRatio: 4.0,
            ),
            'assets/image/source_pin.png')
        .then((value) => sourceIcon = value);
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.0,
        ),
        'assets/image/destination_pin.png');
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        target: SOURCE_LOCATION,
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                onTap: (LatLng loc) {
                  //tapping on the map will dismiss the bottom pill
                  setState(() {
                    this.pinPillPosition = PIN_INVISIBLE_POSITION;
                    this.userBadgeSelected = false;
                  });
                },
                polylines: _polylines,
                initialCameraPosition: initialCameraPosition,
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: false,
                tiltGesturesEnabled: true,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  showPinsOnMap();
                  // showPinsOnMap();
                },
              ),
            ),
            // Positioned(
            //   top: 30,
            //   left: 0,
            //   right: 0,
            //   child: MapUserBadge(
            //     isSelected: userBadgeSelected,
            //   ),
            // ),
            // AnimatedPositioned(
            //   duration: const Duration(milliseconds: 200),
            //   curve: Curves.easeInOut,
            //   left: 0,
            //   right: 0,
            //   bottom: this.pinPillPosition,
            //   //child: MapBottomPill(),
            // ),
          ],
        ),
      ),
    );
  }

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          infoWindow: InfoWindow(title: "Me"),
          markerId: MarkerId('sourcePin'),
          position: currentLocation,
          icon: sourceIcon,
          onTap: () {
            setState(() {
              this.pinPillPosition = PIN_INVISIBLE_POSITION;
              this.userBadgeSelected = true;
              _polylines.clear();
              polylineCoordinates.clear();
            });
          }));
      _markers.add(Marker(
          markerId: MarkerId('destinationPin'),
          position: destinationLocation,
          icon: destinationIcon,
          onTap: () {
            setState(() {
              this.pinPillPosition = PIN_VISIBLE_POSITION;
              this.userBadgeSelected = false;
              setPolylines();
            });
          }));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "YOUR_API_KEY",
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(
          Polyline(
            width: 5,
            polylineId: PolylineId("polyline"),
            color: Color(0xFF08A5C8),
            points: polylineCoordinates,
          ),
        );
      });
    }
  }
}

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Location location = new Location();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Geolocator _geolocator = Geolocator();
//   final TextEditingController _addressTextController = TextEditingController();
//   final String googleAPIKey = "AIzaSyA0gnpxGUi6nCT-W8YpefhEFOU8ml0Wt54";
//   late GoogleMapController mapController;
//   List<Marker> allMarkers = [];
//   var _markerId = 0;
//   String searchAddress = "";
//   //List<Placemark> destination = [];
//   late LatLng currentLocation;
//   late LatLng destinationLocation;
//   List<Polyline> _polylines = [];
//   List<LatLng> routeCoords = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   var _destinationMarkersCount = 0;
//   late BitmapDescriptor potholeIcon;

//   void setPotholeIcon() {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(size: Size(1, 1)), "assets/icons8-p-26.png")
//         .then((onValue) {
//       potholeIcon = onValue;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> children;
//     return Scaffold(
//       body: FutureBuilder(
//           future: _setCurrentLocation(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Stack(
//                 children: <Widget>[
//                   GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                         target:
//                             currentLocation,
//                         zoom: 15),
//                     onMapCreated: _onMapCreated,
//                     myLocationEnabled: true,
//                     mapType: MapType.normal,
//                     compassEnabled: true,
//                     mapToolbarEnabled: true,
//                     myLocationButtonEnabled: true,
//                     markers: Set<Marker>.from(allMarkers),
//                     polylines: Set<Polyline>.from(_polylines),
//                     onTap: (argument) {
//                       FocusScope.of(context).requestFocus(new FocusNode());
//                     },
//                   ),
//                   Positioned(
//                     top: 60.0,
//                     right: 15.0,
//                     left: 15.0,
//                     child: Container(
//                       height: 50.0,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: Colors.white,
//                       ),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Enter Destination",
//                           border: InputBorder.none,
//                           contentPadding:
//                               EdgeInsets.only(left: 15.0, top: 15.0),
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.search),
//                             onPressed: () {
//                               if (searchAddress != "") {
//                                 _setDestinationAndNavigate();
//                               }
//                               _addressTextController.clear();
//                               FocusScope.of(context)
//                                   .requestFocus(new FocusNode());
//                             },
//                             iconSize: 30.0,
//                           ),
//                         ),
//                         controller: _addressTextController,
//                         enableSuggestions: true,
//                         onChanged: (value) {
//                           setState(() {
//                             searchAddress = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             } else if (snapshot.hasError) {
//               children = <Widget>[
//                 Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: 60,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Text('Error: ${snapshot.error}'),
//                 )
//               ];
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: children,
//                 ),
//               );
//             } else {
//               children = <Widget>[
//                 SizedBox(
//                   child: CircularProgressIndicator(),
//                   width: 60,
//                   height: 60,
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 16),
//                   child: Text('Loading Map...'),
//                 )
//               ];
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: children,
//                 ),
//               );
//             }
//           }),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animateToUserLocation();
//     _initializeMarkers();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _initializeMarkers() async {
//     setState(() {
//       allMarkers = [];
//     });
//     setPotholeIcon();
//     QuerySnapshot querySnapshot =
//         await _firestore.collection("POI").get();

//     querySnapshot.docs.forEach((DocumentSnapshot document) {
//       GeoPoint pos = document.data['location']['geopoint'];
//       setState(() {
//         allMarkers.add(
//           Marker(
//             markerId: MarkerId("$_markerId"),
//             position: LatLng(pos.latitude, pos.longitude),
//             icon: potholeIcon,
//             visible: true,
//           ),
//         );
//         _markerId++;
//       });
//     });
//   }

//   _onMapCreated(GoogleMapController controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }

//   Future _setCurrentLocation() async {
//     var value = await location.getLocation();
//     setState(() {
//       currentLocation = LatLng(value.latitude!, value.longitude!);
//     });
//     return currentLocation;
//   }

//   _setDestinationAndNavigate() {
//     _geolocator
//         .placemarkFromAddress(searchAddress)
//         .then((result) {
//           setState(() {
//         destinationLocation =
//             LatLng(result[0].position.latitude, result[0].position.longitude);
//       });
//     });
//     _moveToDestinationLocation();
//     setPolylines();
//   }

//   _moveToDestinationLocation() {
//     var marker = Marker(
//       markerId: MarkerId("$_markerId"),
//       position:
//           LatLng(destinationLocation.latitude, destinationLocation.longitude),
//       icon:
//           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       visible: true,
//     );
//     setState(() {
//       allMarkers.add(marker);
//       _markerId++;
//       _destinationMarkersCount++;
//     });
//      mapController.animateCamera(CameraUpdate.newLatLng(
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
//         allMarkers.removeAt(allMarkers.length - 2);
//       }
//     });

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleAPIKey,
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

// zoomInMarker(double latitude, double longitude) {
//   if (mapController == null) return;
//   mapController
//       .animateCamera(
//     CameraUpdate.newCameraPosition(
//       CameraPosition(
//           target: LatLng(latitude, longitude
//               // specify['location'].latitude,
//               // specify['location'].longitude,
//               ),
//           zoom: 17.0,
//           bearing: 90.0,
//           tilt: 45.0),
//     ),
//   )
//       .then((value) {
//     setState(() {
//       resetToggle = true;
//     });
//   });
// }

// void setCustomMapPin() async {
//   pinLocationIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(devicePixelRatio: 2.5),
//       'assets/images/destination_poin.png');
// }
