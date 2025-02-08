import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';

class LocalPortfolioPhotosRepository {
  LocalPortfolioPhotosRepository({required this.firebaseStorage});

  // final String userUid;
  final FirebaseStorage firebaseStorage;

  Future<Map<String, List<String>>> fetchPortfolioPhotos() async {
    final storageRef = firebaseStorage.ref().child('employee_portfolio_images');
    final Map<String, List<String>> result = {};

    // .child(userUid);

    final listResult = await storageRef.listAll();
    //
    // return await Future.wait(
    //   listResult.items.map((item) async => await item.getDownloadURL()),
    // );
    await Future.wait(
      listResult.items.map((item) async {
        var name = item.name.split(' ')[0];
        if (!result.containsKey(name)) {
          result[name] = [];
        }
        result[name]?.add(await item.getDownloadURL());
      }),
    );
    return result;
  }

  List<String> addLocalPortfolioPhoto(
    List<String> urls,
    String imageUrl,
  ) {
    return [...urls, imageUrl];
  }

  List<String> deleteLocalPortfolioPhoto(
    List<String> urls,
    String imageUrl,
  ) {
    urls.remove(imageUrl);
    return urls;
  }
}
