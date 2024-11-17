import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeInController;
  late AnimationController _fadeOutController;

  @override
  void initState() {
    super.initState();
    // Initialize the fade-in and fade-out animation controllers
    _fadeInController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeOutController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _fadeInController.forward();

    // After 3 seconds, start the fade-out animation, then navigate to login page
    Future.delayed(Duration(seconds: 3), () {
      _fadeOutController.forward();
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var fadeIn = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(opacity: fadeIn, child: child);
            },
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: FadeTransition(
          opacity: _fadeInController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.school,
                    color: Colors.blue, size: 80.0), // Hat emoji icon
                const SizedBox(height: 16.0),
                Text(
                  'ACADEMIC DASHBOARD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
