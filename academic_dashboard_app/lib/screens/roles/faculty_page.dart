import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'faculty_subject_details.dart';

class FacultyPage extends StatefulWidget {
  final String facultyName;

  const FacultyPage({required this.facultyName});

  @override
  _FacultyPageState createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  late Future<List<QueryDocumentSnapshot>> filteredSubjectsFuture;

  @override
  void initState() {
    super.initState();
    filteredSubjectsFuture = _fetchSubjects();
  }

  Future<List<QueryDocumentSnapshot>> _fetchSubjects() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('subjects').get();
      var subjects = snapshot.docs;
      return subjects.where((subject) {
        var facultyList = subject['faculty_list'] != null
            ? List<String>.from(subject['faculty_list'])
            : [];
        return facultyList.contains(widget.facultyName);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load subjects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading for the Faculty Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Logged in as: ${widget.facultyName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: filteredSubjectsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No subjects found for this faculty.'));
                }

                var filteredSubjects = snapshot.data!;

                return ListView.builder(
                  itemCount: filteredSubjects.length,
                  itemBuilder: (context, index) {
                    var subject = filteredSubjects[index];
                    var subjectId = subject.id;
                    var subjectName =
                        subject['subject_name'] ?? 'No name provided';
                    var semester =
                        subject['semester'] ?? 'No semester specified';

                    return ListTile(
                      title: Text(subjectName),
                      subtitle: Text('Semester: $semester'),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacultySubjectDetailsPage(
                              subjectId: subjectId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
