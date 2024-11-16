import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'role_selection_page.dart';

void navigateBasedOnRole(BuildContext context, String uid) async {
  List<String> roles = [];

  try {
    final admin =
        await FirebaseFirestore.instance.collection('admins').doc(uid).get();
    if (admin.exists) roles.add('admin');

    final hod =
        await FirebaseFirestore.instance.collection('hODs').doc(uid).get();
    if (hod.exists) roles.add('hODs');

    final cc =
        await FirebaseFirestore.instance.collection('cCs').doc(uid).get();
    if (cc.exists) roles.add('cCs');

    final faculty =
        await FirebaseFirestore.instance.collection('faculty').doc(uid).get();
    if (faculty.exists) roles.add('faculty');

    final authority = await FirebaseFirestore.instance
        .collection('authorities')
        .doc(uid)
        .get();
    if (authority.exists) roles.add('authorities');

    if (roles.length == 1) {
      switch (roles.first) {
        case 'admin':
          Navigator.pushReplacementNamed(context, '/adminPage');
          break;
        case 'hODs':
          Navigator.pushReplacementNamed(context, '/hodPage');
          break;
        case 'cCs':
          Navigator.pushReplacementNamed(context, '/ccPage');
          break;
        case 'faculty':
          Navigator.pushReplacementNamed(context, '/facultyPage');
          break;
        case 'authorities':
          Navigator.pushReplacementNamed(context, '/authorityPage');
          break;
      }
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RoleSelectionPage(roles: roles)));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error determining role: $e')));
  }
}
