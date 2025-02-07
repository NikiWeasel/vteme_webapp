import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';

class LocalPortfolioPhotosRepository {
  LocalPortfolioPhotosRepository(
      {required this.userUid, required this.firebaseStorage});

  final String userUid;
  final FirebaseStorage firebaseStorage;

  Future<List<String>> fetchPortfolioPhotos() async {

    final storageRef = firebaseStorage
        .ref()
        .child('employee_portfolio_images')
        .child(userUid);
    final listResult = await storageRef.listAll();

    return await Future.wait(
      listResult.items.map((item) async => await item.getDownloadURL()),
    );
  }

  List<String> addLocalPortfolioPhoto(List<String> urls,
      String imageUrl,) {
    return [...urls, imageUrl];
  }

  List<String> deleteLocalPortfolioPhoto(List<String> urls,
      String imageUrl,) {
    urls.remove(imageUrl);
    return urls;
  }
}
