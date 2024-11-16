import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacultyManager extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void addFaculty(BuildContext context) async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final department = departmentController.text.trim();
    final phone = phoneController.text.trim();
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    if (email.isEmpty || name.isEmpty || department.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required.')),
      );
      return;
    }

    try {
      // Check if this CC is assigning themselves as faculty
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(currentUid)
          .set({
        'email': email,
        'name': name,
        'department': department,
        'phone': phone,
        'role': 'faculty',
        'uid': currentUid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Faculty added successfully!')),
      );

      emailController.clear();
      nameController.clear();
      departmentController.clear();
      phoneController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add faculty: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: departmentController,
            decoration: InputDecoration(labelText: 'Department'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => addFaculty(context),
            child: Text('Add Faculty'),
          ),
        ],
      ),
    );
  }
}
