import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart'; // Import ForgotPasswordPage
import 'hod_home.dart'; // HOD home screen
import 'cc_home.dart'; // CC home screen
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final String uid = userCredential.user!.uid;

      // Fetch user role from Firestore
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final String role = userDoc.data()?['role'] ?? 'Unknown';

      // Navigate to the respective home page
      if (role == 'HOD') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HodHomePage()));
      } else if (role == 'CC') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CcHomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
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
              Icon(Icons.school, color: Colors.blue, size: 60.0),
              SizedBox(height: 16.0),
              Text(
                'ACADEMIC DASHBOARD',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32.0),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login', style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Center(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
