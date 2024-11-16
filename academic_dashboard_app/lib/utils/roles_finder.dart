import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getUserRoles(String email) async {
  List<String> roles = [];
  final roleCollections = ['hODs', 'cCs', 'faculty', 'authorities'];

  try {
    for (var collection in roleCollections) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        roles.add(collection); // Add collection name if user is present
      }
    }
  } catch (e) {
    print("Error fetching roles: $e");
  }
  return roles;
}
