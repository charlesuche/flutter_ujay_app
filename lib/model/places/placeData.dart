import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  //int id;
  String name;
  String location;
  String desc;
  String imgUrl;

  PlaceModel(
      {required this.desc,
      //required this.id,
      required this.imgUrl,
      required this.location,
      required this.name});

  factory PlaceModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return PlaceModel(
      desc: doc.data()!['desc'],
      //id: data['id'],
      imgUrl: doc.data()!['imgUrl'],
      location: doc.data()!['location'],
      name: doc.data()!['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //"id": id,
      "name": name,
      "location": location,
      "imgUrl": imgUrl,
      "desc": desc
    };
  }
}
