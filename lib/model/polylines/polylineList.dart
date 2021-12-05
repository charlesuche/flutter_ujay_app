import 'package:flutter/material.dart';

abstract class Page extends StatelessWidget {
  const Page(this.leading, this.title);

  final Widget leading;
  final String title;
}
// class PolylineList {
//   List<Polyline> polylineList;

//   PolylineList({required this.polylineList});

//   factory PolylineList.fromJson(List<dynamic> parsedJson) {
//     List<Polyline> polylineList = <Polyline>[];
//     polylineList = parsedJson.map((i) => Polyline.fromJson(i)).toList();

//     return PolylineList(polylineList: polylineList);
//   }
// }

// class Polyline {
//   double lat;
//   double lng;

//   Polyline({required this.lat, required this.lng});

//   factory Polyline.fromJson(Map<String, dynamic> jsonData) {
//     return Polyline(lat: jsonData['lat'], lng: jsonData['lng']);
//   }
// }
