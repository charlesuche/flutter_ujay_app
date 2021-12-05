// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DatabaseManager {
//   // Collection Reference
//   final CollectionReference userInfo =
//       FirebaseFirestore.instance.collection('UsersInfo');

//   Future<void> userSetup(String displayName, emailAddress) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser.uid.toString();
//     String email = auth.currentUser.email.toString();
//     userInfo
//         .add({'displayName': displayName, 'uid': uid, 'emailAddress': email});
//     return;
//   }

//   Future getUserDataList() async {
//     List itemLists = [];

//     try {
//       await userInfo.get().then((querySnapshot) => {
//             querySnapshot.docs.forEach((element) {
//               itemLists.add(element.data);
//             })
//           });
//       return itemLists;
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
