import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

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

  List<PieChartSectionData> _generateChartData(int completed, int total) {
    return [
      PieChartSectionData(
        value: completed.toDouble(),
        color: Colors.green,
        title: '${((completed / total) * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        value: (total - completed).toDouble(),
        color: Colors.red,
        title: '',
        radius: 50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOD Dashboard', style: TextStyle(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Faculty and Their Assigned Subjects',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            ...facultyList.map((faculty) {
              var assignedSubjects = subjects.where((subject) {
                var facultyNames = subject['faculty_list'] != null
                    ? List<String>.from(subject['faculty_list'])
                    : [];
                return facultyNames.contains(faculty['userName']);
              }).toList();

              return ExpansionTile(
                title:
                    Text(faculty['userName'], style: TextStyle(fontSize: 16)),
                subtitle: Text('${assignedSubjects.length} assigned subjects'),
                children: assignedSubjects.map((subject) {
                  var subjectData = subject.data() as Map<String, dynamic>;
                  var completedFieldsCount =
                      _getCompletedFieldsCount(subjectData);
                  var totalFieldsCount = subjectData.length;
                  return ListTile(
                    title: Text(subject['subject_name']),
                    subtitle: Text(
                        'Completion: $completedFieldsCount/$totalFieldsCount fields'),
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 16),
            Text(
              'Class Coordinators and Their Assigned Subjects',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            ...ccList.map((cc) {
              var assignedSubjects = subjects
                  .where((subject) => subject['cc_id'] == cc.id)
                  .toList();

              return ExpansionTile(
                title: Text(cc['userName'], style: TextStyle(fontSize: 16)),
                subtitle: Text('${assignedSubjects.length} assigned subjects'),
                children: assignedSubjects.map((subject) {
                  var subjectData = subject.data() as Map<String, dynamic>;
                  var completedFieldsCount =
                      _getCompletedFieldsCount(subjectData);
                  var totalFieldsCount = subjectData.length;
                  return ListTile(
                    title: Text(subject['subject_name']),
                    subtitle: Text(
                        'Completion: $completedFieldsCount/$totalFieldsCount fields'),
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 16),
            Text(
              'Subjects Statistics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            ...subjects.map((subject) {
              var subjectData = subject.data() as Map<String, dynamic>;
              var completedFieldsCount = _getCompletedFieldsCount(subjectData);
              var totalFieldsCount = subjectData.length;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['subject_name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completion: $completedFieldsCount/$totalFieldsCount',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: PieChart(
                              PieChartData(
                                sections: _generateChartData(
                                    completedFieldsCount, totalFieldsCount),
                                centerSpaceRadius: 30,
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
