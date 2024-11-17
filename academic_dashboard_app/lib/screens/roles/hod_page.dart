import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HODPage extends StatefulWidget {
  final List<String> roles;

  const HODPage({required this.roles});

  @override
  _HODPageState createState() => _HODPageState();
}

class _HODPageState extends State<HODPage> {
  late Future<List<Map<String, dynamic>>> subjectDetailsFuture;
  late Future<List<Map<String, dynamic>>> facultyDetailsFuture;
  late Future<List<Map<String, dynamic>>> ccDetailsFuture;

  @override
  void initState() {
    super.initState();
    subjectDetailsFuture = _fetchSubjectDetails();
    facultyDetailsFuture = _fetchFacultyDetails();
    ccDetailsFuture = _fetchCCDetails();
  }

  Future<List<Map<String, dynamic>>> _fetchSubjectDetails() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('subjects').get();
    var subjects = snapshot.docs.map((doc) {
      var data = doc.data();
      var fieldsTotal = data.length;
      var fieldsCompleted = data.values.where((value) => value != null).length;
      return {
        'subjectName': data['subject_name'] ?? 'No name',
        'semester': data['semester'] ?? 'No semester',
        'fieldsCompleted': fieldsCompleted,
        'fieldsTotal': fieldsTotal,
      };
    }).toList();
    return subjects;
  }

  Future<List<Map<String, dynamic>>> _fetchFacultyDetails() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('user_collection')
        .where('roles', arrayContains: 'Faculty')
        .get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      return {
        'facultyName': data['userName'] ?? 'No name',
        'assignedSubjects': _getAssignedSubjects(data['faculty_list'] ?? []),
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchCCDetails() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('user_collection')
        .where('roles', arrayContains: 'CC')
        .get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      return {
        'ccName': data['userName'] ?? 'No name',
        'assignedSubjects': _getAssignedSubjects(data['faculty_list'] ?? []),
      };
    }).toList();
  }

  List<String> _getAssignedSubjects(List<dynamic> facultyList) {
    // Logic to extract assigned subjects
    return facultyList.map((subject) => subject.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOD Dashboard'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Subjects'),
              _buildSubjectList(),
              const SizedBox(height: 16),
              _buildSectionTitle('Faculty Details'),
              _buildFacultyList(),
              const SizedBox(height: 16),
              _buildSectionTitle('CC Details'),
              _buildCCList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
    );
  }

  Widget _buildSubjectList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: subjectDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No subjects found.'));
        }
        var subjects = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            var subject = subjects[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(subject['subjectName']),
                subtitle: Text(
                  'Semester: ${subject['semester']}\n'
                  'Fields Completed: ${subject['fieldsCompleted']} / ${subject['fieldsTotal']}',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFacultyList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: facultyDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No faculty details found.'));
        }
        var facultyDetails = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: facultyDetails.length,
          itemBuilder: (context, index) {
            var faculty = facultyDetails[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(faculty['facultyName']),
                subtitle: Text(
                    'Assigned Subjects: ${faculty['assignedSubjects'].join(', ')}'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCCList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ccDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No CC details found.'));
        }
        var ccDetails = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ccDetails.length,
          itemBuilder: (context, index) {
            var cc = ccDetails[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(cc['ccName']),
                subtitle: Text(
                    'Assigned Subjects: ${cc['assignedSubjects'].join(', ')}'),
              ),
            );
          },
        );
      },
    );
  }
}
