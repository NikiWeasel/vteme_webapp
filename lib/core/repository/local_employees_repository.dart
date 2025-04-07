import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';

class LocalEmployeesRepository {
  LocalEmployeesRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  Future<List<Employee>> fetchAllEmployeesData() async {
    final QuerySnapshot snapshot =
        await firebaseFirestore.collection('users').get();

    final List<Employee> allEmployees = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Employee(
          name: data['name'],
          surname: data['surname'],
          isAdmin: data['is_admin'],
          description: data['description'],
          email: data['email'],
          number: data['number'],
          imageUrl: data['image_url'],
          employeeId: doc.id,
          categoryIds: ((data['categoriesIds'] as List<dynamic>))
              .map((e) => e.toString())
              .toList());
    }).toList();

    if (allEmployees.isEmpty) {
      throw Exception('Данные пользователей не найдены');
    }
    return allEmployees;
  }
}
