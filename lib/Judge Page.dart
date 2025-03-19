import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Case {
  String id;
  String name;
  String judgeName;
  String status;
  String nextDate;
  String proof; // New field

  Case({
    required this.id,
    required this.name,
    required this.judgeName,
    required this.status,
    required this.nextDate,
    required this.proof, // Include proof in the constructor
  });

  factory Case.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Case(
      id: doc.id,
      name: data['name'] ?? '',
      judgeName: data['judgeName'] ?? '',
      status: data['status'] ?? '',
      nextDate: data['nextDate'] ?? '',
      proof: data['proof'] ?? '', // Initialize proof from Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'judgeName': judgeName,
      'status': status,
      'nextDate': nextDate,
      'proof': proof, // Add proof to the map
    };
  }
}

class CaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Case>> getCases() async {
    QuerySnapshot snapshot = await _db.collection('cases').get();
    return snapshot.docs.map((doc) => Case.fromFirestore(doc)).toList();
  }

  Future<void> addCase(Case caseItem) async {
    await _db.collection('cases').add(caseItem.toMap());
  }

  Future<void> updateCase(String id, Case caseItem) async {
    await _db.collection('cases').doc(id).update(caseItem.toMap());
  }

  Future<void> deleteCase(String id) async {
    await _db.collection('cases').doc(id).delete();
  }
}

class JudgePage extends StatefulWidget {
  @override
  _JudgePageState createState() => _JudgePageState();
}

class _JudgePageState extends State<JudgePage> {
  final CaseService _caseService = CaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Case> _cases = [];
  String _caseName = '';
  String _judgeName = '';
  String _status = '';
  String _nextDate = '';
  String _proof = ''; // New field

  @override
  void initState() {
    super.initState();
    _fetchCases();
  }

  Future<void> _fetchCases() async {
    final cases = await _caseService.getCases();
    setState(() {
      _cases = cases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Judge Cases'),
        actions: [
          TextButton(
            onPressed: () => _showAddCaseDialog(context),
            child: Text(
              "Add Case",
              style: TextStyle(color: Colors.yellow),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _cases.isEmpty
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.yellow,
            ))
          : ListView.builder(
              itemCount: _cases.length,
              itemBuilder: (context, index) {
                final caseItem = _cases[index];
                return Container(
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow, width: 2),
                    borderRadius:
                        BorderRadius.circular(16.0), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      iconColor: Colors.black,
                      leading: IconButton(
                        onPressed: () {
                          const snackBar = SnackBar(
                            showCloseIcon: true,
                            closeIconColor: Colors.yellow,
                            backgroundColor: Colors.black,
                            content: Text(
                              'This Is A CBI Case',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: Icon(Icons.check),
                      ),
                      title: Text(caseItem.name),
                      tileColor: Colors.yellow,
                      textColor: Colors.black,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Judge: ${caseItem.judgeName}'),
                          Text('Status: ${caseItem.status}'),
                          Text('Next Date: ${caseItem.nextDate}'),
                          Text('Proof: ${caseItem.proof}'), // Display proof
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditCaseDialog(context, caseItem);
                          } else if (value == 'delete') {
                            _deleteCase(caseItem.id);
                          }
                        },
                        iconColor: Colors.black,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteCase(String id) async {
    await _caseService.deleteCase(id);
    _fetchCases(); // Refresh the case list
  }

  void _showAddCaseDialog(BuildContext context) {
    _showCaseDialog(context, 'Add Case', (String name, String judgeName,
        String status, String nextDate, String proof) {
      final newCase = Case(
        id: '',
        name: name,
        judgeName: judgeName,
        status: status,
        nextDate: nextDate,
        proof: proof, // Include proof
      );
      _caseService.addCase(newCase).then((_) {
        _fetchCases(); // Refresh the case list
      });
    });
  }

  void _showEditCaseDialog(BuildContext context, Case caseItem) {
    _showCaseDialog(context, 'Edit Case', (String name, String judgeName,
        String status, String nextDate, String proof) {
      final updatedCase = Case(
        id: caseItem.id,
        name: name,
        judgeName: judgeName,
        status: status,
        nextDate: nextDate,
        proof: proof, // Include proof
      );
      _caseService.updateCase(caseItem.id, updatedCase).then((_) {
        _fetchCases(); // Refresh the case list
      });
    }, caseItem: caseItem);
  }

  void _showCaseDialog(BuildContext context, String title,
      Function(String, String, String, String, String) onSave,
      {Case? caseItem}) {
    if (caseItem != null) {
      _caseName = caseItem.name;
      _judgeName = caseItem.judgeName;
      _status = caseItem.status;
      _nextDate = caseItem.nextDate;
      _proof = caseItem.proof; // Initialize proof
    } else {
      _caseName = '';
      _judgeName = '';
      _status = '';
      _nextDate = '';
      _proof = ''; // Reset proof
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _caseName,
                  decoration: InputDecoration(
                    labelText: 'Case Name',
                    labelStyle:
                        TextStyle(color: Colors.yellow), // Yellow label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow,
                          width: 2), // Yellow border when focused
                    ),
                  ),
                  onChanged: (value) => _caseName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter case name' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _judgeName,
                  decoration: InputDecoration(
                    labelText: 'Judge Name',
                    labelStyle:
                        TextStyle(color: Colors.yellow), // Yellow label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow,
                          width: 2), // Yellow border when focused
                    ),
                  ),
                  onChanged: (value) => _judgeName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter judge name' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle:
                        TextStyle(color: Colors.yellow), // Yellow label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow,
                          width: 2), // Yellow border when focused
                    ),
                  ),
                  onChanged: (value) => _status = value,
                  validator: (value) => value!.isEmpty ? 'Enter status' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _nextDate,
                  decoration: InputDecoration(
                    labelText: 'Next Date',
                    labelStyle:
                        TextStyle(color: Colors.yellow), // Yellow label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow,
                          width: 2), // Yellow border when focused
                    ),
                  ),
                  onChanged: (value) => _nextDate = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter next date' : null,
                ),
                SizedBox(height: 10),
                // New proof field
                TextFormField(
                  initialValue: _proof,
                  decoration: InputDecoration(
                    labelText: 'Proof',
                    labelStyle:
                        TextStyle(color: Colors.yellow), // Yellow label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow), // Yellow border when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.yellow,
                          width: 2), // Yellow border when focused
                    ),
                  ),
                  onChanged: (value) => _proof = value,
                  validator: (value) => value!.isEmpty ? 'Enter proof' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  onSave(_caseName, _judgeName, _status, _nextDate, _proof);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
