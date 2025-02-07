import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';

class LocalRegulationsRepository {
  LocalRegulationsRepository({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

  Future<List<Regulation>> fetchRegulationsData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('regulations').get();

    final List<Regulation> allRegs = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Regulation(
          name: data['name'],
          duration: data['duration'],
          cost: data['cost'],
          id: doc.id);
    }).toList();
    return allRegs;
  }

  List<Regulation> addLocalRegulation(
    List<Regulation> regs,
    Regulation regulation,
  ) {
    return [...regs, regulation];
  }

  List<Regulation> deleteLocalRegulation(
    List<Regulation> regs,
    Regulation regulation,
  ) {
    return regs
        .where(
          (element) => element.id != regulation.id,
        )
        .toList();
  }

  List<Regulation> updateLocalRegulation(
    List<Regulation> regs,
    Regulation regulation,
  ) {
    var newRegs = regs
        .where(
          (element) => element.id != regulation.id,
        )
        .toList();
    return [...newRegs, regulation];
  }
}
