import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujay_app/app/views/DetailInfo.dart';

Widget placeCard(BuildContext context, DocumentSnapshot document) {
  return Card(
      margin: EdgeInsets.only(right: 22.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      child: GestureDetector(
          onTap: () {
            Get.to(DetailInfo(), arguments: document.data());
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(document['imgUrl']),
              fit: BoxFit.cover,
              scale: 2.0,
            )),
            width: 200.0,
            child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            document['location'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          )));
}

// class Places {
//   int id;
//   String name;
//   String image;
//   bool isLiked;
//   bool isSelected;
//   String detail;
//   Places(
//       {required this.id,
//       required this.detail,
//       required this.image,
//       required this.isLiked,
//       required this.name,
//       this.isSelected = false});
// }

// class PlaceData {
//   static List<Places> placesList = [
//     Places(
//       name: 'Main Camp',
//       id: 1,
//       image: 'assets/images/ujbackg.png',
//       detail: '',
//       isLiked: false,
//     ),
//     Places(
//       name: 'Main Camp',
//       id: 1,
//       image: 'assets/images/ujbackg.png',
//       detail: '',
//       isLiked: false,
//     ),
//     Places(
//       name: 'Main Camp',
//       id: 1,
//       image: 'assets/images/ujbackg.png',
//       detail: '',
//       isLiked: false,
//     ),
//     Places(
//       name: 'Main Camp',
//       id: 1,
//       image: 'assets/images/ujbackg.png',
//       detail: '',
//       isLiked: false,
//     ),
//     Places(
//       name: 'Main Camp',
//       id: 1,
//       image: 'assets/images/ujbackg.png',
//       detail: '',
//       isLiked: false,
//     ),
//   ];
// }
