import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vteme_tg_miniapp/core/models/category.dart';

class LocalCategoriesRepository {
  LocalCategoriesRepository({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

  Future<List<RegCategory>> fetchCategoriesData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('categories').get();

    final List<RegCategory> allCats = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return RegCategory(
          description: data['description'],
          name: data['name'],
          regulationIds: (data['regulationIds'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          id: doc.id);
    }).toList();
    return allCats;
  }
}
