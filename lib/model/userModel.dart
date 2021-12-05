class UserModel {
  final String uid;
  final String email;
  final String name;
  //final String photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    //required this.photoUrl
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      //photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid, "email": email, "name": name,
        //"photoUrl": photoUrl
      };
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   String id;
//   String name;
//   String email;

//   UserModel({this.id, this.name, this.email});

//   UserModel.fromSnapshot(DocumentSnapshot snapshot) {
//     name = snapshot['name'];
//     email = snapshot['email'];
//     id = snapshot['id'];
//   }
// }
