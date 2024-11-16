import 'package:flutter/material.dart';
import 'screens/admin_page.dart';
import 'screens/authority_page.dart';
import 'screens/cc_page.dart';
import 'screens/faculty_page.dart';
import 'screens/hod_page.dart';
import 'screens/homepage.dart';
import 'screens/login.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => LoginPage(),
  '/admin': (context) => AdminPage(),
  '/authority': (context) => AuthorityPage(),
  '/cc': (context) => CcPage(),
  '/faculty': (context) => FacultyPage(),
  '/hod': (context) => HodPage(),
  '/home': (context) => HomePage(),
};
