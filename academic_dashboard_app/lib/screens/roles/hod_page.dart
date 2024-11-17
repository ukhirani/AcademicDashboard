import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HODPage extends StatefulWidget {
  final List<String> roles;

  const HODPage({required this.roles});

  @override
  _HODPageState createState() => _HODPageState();
}

class _HODPageState extends State<HODPage> {
  List<QueryDocumentSnapshot> facultyList = [];
  List<QueryDocumentSnapshot> ccList = [];
  List<QueryDocumentSnapshot> subjects = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch all faculty members
      var facultySnapshot = await FirebaseFirestore.instance
          .collection('user_collection')
          .where('roles', arrayContains: 'Faculty')
          .get();
      facultyList = facultySnapshot.docs;

      // Fetch all class coordinators
      var ccSnapshot = await FirebaseFirestore.instance
          .collection('user_collection')
          .where('roles', arrayContains: 'Class Coordinator')
          .get();
      ccList = ccSnapshot.docs;

      // Fetch all subjects
      var subjectsSnapshot =
          await FirebaseFirestore.instance.collection('subjects').get();
      subjects = subjectsSnapshot.docs;

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  int _getCompletedFieldsCount(Map<String, dynamic> subjectData) {
    return subjectData.entries
        .where((entry) => entry.value != null)
        .length; // Counts non-null fields
  }

  List<QueryDocumentSnapshot> _getFacultySubjects(String facultyName) {
    return subjects.where((subject) {
      var facultyList = subject['faculty_list'] != null
          ? List<String>.from(subject['faculty_list'])
          : [];
      return facultyList.contains(facultyName);
    }).toList();
  }

  List<QueryDocumentSnapshot> _getCCSubjects(String ccId) {
    return subjects.where((subject) => subject['cc_id'] == ccId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOD Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Faculty and Their Assigned Subjects:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...facultyList.map((faculty) {
              var assignedSubjects = _getFacultySubjects(faculty['userName']);
              return ExpansionTile(
                title: Text(faculty['userName']),
                subtitle: Text(
                    'Subjects: ${assignedSubjects.length} assigned subjects'),
                children: assignedSubjects.map((subject) {
                  var subjectData = subject.data() as Map<String, dynamic>;
                  var completedFieldsCount =
                      _getCompletedFieldsCount(subjectData);
                  var totalFieldsCount = subjectData.length;
                  return ListTile(
                    title: Text(subjectData['subject_name'] ?? 'No Name'),
                    subtitle: Text(
                        'Completed Fields: $completedFieldsCount/$totalFieldsCount'),
                  );
                }).toList(),
              );
            }).toList(),
            SizedBox(height: 16),
            Text(
              'Class Coordinators and Their Assigned Subjects:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...ccList.map((cc) {
              var assignedSubjects = _getCCSubjects(cc.id);
              return ExpansionTile(
                title: Text(cc['userName']),
                subtitle: Text(
                    'Subjects: ${assignedSubjects.length} assigned subjects'),
                children: assignedSubjects.map((subject) {
                  var subjectData = subject.data() as Map<String, dynamic>;
                  var completedFieldsCount =
                      _getCompletedFieldsCount(subjectData);
                  var totalFieldsCount = subjectData.length;
                  return ListTile(
                    title: Text(subjectData['subject_name'] ?? 'No Name'),
                    subtitle: Text(
                        'Completed Fields: $completedFieldsCount/$totalFieldsCount'),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
