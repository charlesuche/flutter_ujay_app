import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ujay_app/app/controllers/searchServices.dart';
import 'package:ujay_app/app/constants/secrets.dart';

class MyLocation extends StatefulWidget {
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  final TextEditingController searchController = TextEditingController();
  late LocationData _currentPosition;
  late LatLng destinationLocation;
  late String _address, _dateTime;
  //late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Polyline> _polylines = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  late QuerySnapshot snapshotData;
  bool isExecuted = false;
  bool sitesToggle = false;
  List<LatLng> routeCoords = [];
  var _destinationMarkersCount = 0;

  late GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
    getMarkerData();
    setPolylines();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 18),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget SearchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print(snapshotData.docs[index]['name']);
            },
            child: ListTile(
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(snapshotData.docs[index]['name']),
              subtitle: Text(snapshotData.docs[index]['searchKey']),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Color(0xFF000000).withOpacity(0.5),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                isExecuted = false;
              });
            }),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        actions: [
          GetBuilder<SearchController>(
              init: SearchController(),
              builder: (val) {
                return IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFF000000).withOpacity(0.5),
                    ),
                    onPressed: () {
                      val.queryData(searchController.text).then((value) {
                        snapshotData = value;
                        setState(() {
                          isExecuted = true;
                        });
                      });
                    });
              }),
        ],
        title: TextField(
          cursorColor: Color(0xFF000000),
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Find place on campus', border: InputBorder.none),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   foregroundColor: Colors.black,
      //   child: const Icon(Icons.center_focus_strong),
      //   onPressed: () =>
      //       mapController.animateCamera(CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(9.948446, 8.890408), zoom: 17),
      //   )),
      // ),
      body: isExecuted
          ? SearchedData()
          : SafeArea(
              child: Container(
                child: Center(
                  child: Stack(
                    children: [
                      GoogleMap(
                        markers: Set<Marker>.of(markers.values),
                        polylines: Set<Polyline>.from(_polylines),
                        initialCameraPosition: CameraPosition(
                            target: _initialcameraposition, zoom: 15),
                        mapType: MapType.satellite,
                        onMapCreated: _onMapCreated,
                        compassEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        onTap: (argument) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                      ),
                      // SizedBox(
                      //   height: 3,
                      // ),
                      // if (_dateTime != null)
                      //   Text(
                      //     "Date/Time: $_dateTime",
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       color: Colors.white,
                      //     ),
                      //   ),

                      // SizedBox(
                      //   height: 3,
                      // ),
                      // ignore: unnecessary_null_comparison
                      // if (_currentPosition != null)
                      //   Text(
                      //     "Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}",
                      //     style: TextStyle(
                      //         fontSize: 22,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // SizedBox(
                      //   height: 3,
                      // ),
                      // if (_address != null)
                      //   Text(
                      //     "Address: $_address",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // SizedBox(
                      //   height: 3,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude!, _currentPosition.longitude!);

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        // _getAddress(_currentPosition.latitude!, _currentPosition.longitude!)
        //     .then((value) {
        //   setState(() {
        //     _address = "${value.first.addressLine}";
        //   });
        // }
      });
    });
  }

  // Future<List<Address>> _getAddress(double lat, double lang) async {
  //   final coordinates = new Coordinates(lat, lang);
  //   List<Address> add =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   return add;
  // }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        print(specify['name']);

        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            )),
            elevation: 10.0,
            enableDrag: true,
            builder: (BuildContext context) {
              return ListView(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(specify['imgUrl']),
                            fit: BoxFit.cover)),
                    //child: Text(specify['name']),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Column(
                      children: [
                        Text(
                          specify['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          specify['desc'].toString(),
                        ),
                        ListTile(
                          title: Text('Offices'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        Divider(
                          color: Colors.black,
                          height: 5,
                        ),
                        ListTile(
                          title: Text('Direction'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
      },
      markerId: markerId,
      draggable: false,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(
        title: specify['name'],
      ),
    );

    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('POI').get().then((markerData) {
      if (markerData.docs.isNotEmpty) {
        setState(() {
          sitesToggle = true;
        });
        for (int i = 0; i < markerData.docs.length; i++) {
          initMarker(markerData.docs[i].data(), markerData.docs[i].id);
        }
      }
    });
  }

  setPolylines() async {
    setState(() {
      _polylines = [];
      routeCoords = [];

      //remove previous destination marker
      if (_destinationMarkersCount > 1) {
        markers.remove(markers.length - 2);
      }
    });

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(_currentPosition.latitude!, _currentPosition.longitude!),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        routeCoords.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("###################################");
      print("Polyline result returned empty set!");
      print("###################################");
    }
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Color.fromARGB(255, 40, 122, 198),
        points: routeCoords,
      );

      _polylines.add(polyline);
    });
  }
}
