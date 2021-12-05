import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection('POI')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}

// GeoPoint geoPoint = document.getGeoPoint("position");
// And then use:

// double lat = geoPoint.getLatitude();
// double lng = geoPoint.getLongitude();
// LatLng latLng = new LatLng(lat, lng);

class SearchController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) {
    return FirebaseFirestore.instance
        .collection('POI')
        .where(
          'name',
          isGreaterThanOrEqualTo: queryString,
        )
        .get();
  }
}
