import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultySubjectDetailsPage extends StatefulWidget {
  final String facultyName;

  FacultySubjectDetailsPage({required this.facultyName});

  @override
  _FacultySubjectDetailsPageState createState() =>
      _FacultySubjectDetailsPageState();
}

class _FacultySubjectDetailsPageState extends State<FacultySubjectDetailsPage> {
  late Map<String, dynamic> subjectData = {}; // Initialize the subjectData

  @override
  void initState() {
    super.initState();
    _fetchSubjectDetails();
  }

  _fetchSubjectDetails() async {
    // Get the subject details
    var subjectSnapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .where('faculty_list', arrayContains: widget.facultyName)
        .get();

    if (subjectSnapshot.docs.isNotEmpty) {
      setState(() {
        subjectData = subjectSnapshot.docs.first.data() as Map<String, dynamic>;
      });
    } else {
      // Handle case when no subject data is found
      setState(() {
        subjectData = {}; // If no data is found, set an empty map
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner until the data is fetched
    if (subjectData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Subject Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Subject Details - ${subjectData['subject_name'] ?? 'Unknown Subject'}')),
      body: ListView(
        children: [
          Text(
              'Subject Name: ${subjectData['subject_name'] ?? 'Not Provided'}'),
          Text('Semester: ${subjectData['semester'] ?? 'Not Provided'}'),
          Text(
              'Program Type: ${subjectData['degree_diploma'] ?? 'Not Provided'}'),
          Text(
              'Faculty Assigned: ${subjectData['faculty_list']?.join(', ') ?? 'Not Provided'}'),
          // Add other fields similarly
        ],
      ),
    );
  }
}
