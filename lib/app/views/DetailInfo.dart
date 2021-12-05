import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailInfo extends StatefulWidget {
  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  var args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('POI').snapshots(),
          builder: (context, snapshot) {
            // ignore: unused_local_variable
            final data = snapshot.requireData;
            return Container(
              child: ListView(children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(args['imgUrl']),
                        fit: BoxFit.fitWidth,
                        scale: 2.0,
                      )),
                    ),
                    Center(child: Text(args['name']))
                  ],
                ),
              ]),
            );
          }),
    );
  }
}

// class DetailList extends StatelessWidget {
//   final db = FirebaseFirestore.instance;

//   Stream<List<PlaceModel>> placeStream() {
//     try {
//       // ignore: non_constant_identifier_names
//       return db.collection('POI').snapshots().map((POI) {
//         final List<PlaceModel> placesFromFirestore = <PlaceModel>[];
//         for (final DocumentSnapshot<Map<String, dynamic>> doc in POI.docs) {
//           placesFromFirestore.add(PlaceModel.fromDocumentSnapshot(doc: doc));
//         }
//         return placesFromFirestore;
//       });
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<PlaceModel>>(
//         stream: placeStream(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error loading data'));
//           } else if (snapshot.hasData) {
//             return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   PlaceModel listOfPlace = snapshot.data![index];
//                   return Card(
//                     child: ListTile(
//                       title: Text(listOfPlace.name),
//                       subtitle: Text(listOfPlace.desc),
//                     ),
//                   );
//                 });
//           } else
//             return Center(
//               child: Text('An Error Occured'),
//             );
//         });
//   }
// }
