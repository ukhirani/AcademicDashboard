import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'roles/admin_page.dart';
import 'roles/cc_page.dart';
import 'roles/faculty_page.dart';
import 'roles/hod_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<String> userRoles = [];
  String? selectedRole;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user_collection')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        userRoles = List<String>.from(userDoc['roles'] ?? []);
        if (userRoles.isNotEmpty) {
          if (!mounted) return; // Ensure the widget is still mounted
          setState(() {
            selectedRole = userRoles.first;
          });
          _navigateToRolePage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No roles found for this user.')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User roles not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  void _navigateToRolePage() {
    if (selectedRole == null) return;

    Widget nextPage;

    switch (selectedRole) {
      case 'Admin':
        nextPage = AdminPage(roles: userRoles, onRoleSwitch: _onRoleSwitch);
        break;
      case 'Class Coordinator':
        nextPage = CCPage(roles: userRoles, onRoleSwitch: _onRoleSwitch);
        break;
      case 'Faculty':
        nextPage = FacultyPage(roles: userRoles, onRoleSwitch: _onRoleSwitch);
        break;
      case 'Head Of Department':
        nextPage = HODPage(roles: userRoles, onRoleSwitch: _onRoleSwitch);
        break;
      default:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid role selected.')));
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  void _onRoleSwitch(String newRole) {
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      selectedRole = newRole;
    });
    _navigateToRolePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, color: Colors.blue, size: 60.0),
              const SizedBox(height: 16.0),
              Text(
                'ACADEMIC DASHBOARD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
