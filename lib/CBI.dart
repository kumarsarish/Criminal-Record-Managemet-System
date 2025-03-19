import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // For swipe actions

class CasesPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream that listens to changes in Firestore and updates the UI
  Stream<QuerySnapshot> getCases() {
    return _firestore.collection('cases').snapshots();
  }

  // Method to delete a case from Firestore
  Future<void> deleteCase(String caseId) async {
    await _firestore.collection('cases').doc(caseId).delete();
  }

  // Method to show a dialog for editing case details
  void _showEditDialog(BuildContext context, String caseId) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _judgeController = TextEditingController();
    final TextEditingController _nextDateController = TextEditingController();
    final TextEditingController _proofController = TextEditingController();
    final TextEditingController _statusController = TextEditingController();

    // Load the current case details into the controllers
    _loadCaseDetails(caseId, _nameController, _judgeController,
        _nextDateController, _proofController, _statusController);

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dialog from closing when tapped outside
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Case'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _proofController,
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
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel',style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              onPressed: () {
                _saveCaseDetails(
                    caseId,
                    _nameController.text,
                    _judgeController.text,
                    _nextDateController.text,
                    _proofController.text,
                    _statusController.text);
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text('Save Changes',style: TextStyle(color: Colors.yellow),),
            ),
          ],
        );
      },
    );
  }

  // Method to load case details into the controllers for editing
  Future<void> _loadCaseDetails(
      String caseId,
      TextEditingController nameController,
      TextEditingController judgeController,
      TextEditingController nextDateController,
      TextEditingController proofController,
      TextEditingController statusController) async {
    DocumentSnapshot caseDoc =
        await _firestore.collection('cases').doc(caseId).get();
    if (caseDoc.exists) {
      var caseData = caseDoc.data() as Map<String, dynamic>;
      nameController.text = caseData['name'] ?? '';
      judgeController.text = caseData['judgeName'] ?? '';
      nextDateController.text = caseData['nextDate'] ?? '';
      proofController.text = caseData['proof'] ?? '';
      statusController.text = caseData['status'] ?? '';
    }
  }

  // Method to save the edited case details to Firestore
  Future<void> _saveCaseDetails(String caseId, String name, String judgeName,
      String nextDate, String proof, String status) async {
    await _firestore.collection('cases').doc(caseId).update({
      'name': name,
      'judgeName': judgeName,
      'nextDate': nextDate,
      'proof': proof,
      'status': status,
    });
  }

  // Method to delete a case from Firestore
  Future<void> deletecase(String caseId) async {
    await _firestore.collection('cases').doc(caseId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CBI Cases'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.yellow,
            ));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No cases found.'));
          }

          // List of cases
          final cases = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final caseData = cases[index].data() as Map<String, dynamic>;
              final caseId = cases[index].id;

              return Slidable(
                key: ValueKey(caseId),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        deletecase(caseId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Case Deleted')),
                        );
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow, width: 2),
                    borderRadius:
                    BorderRadius.circular(16.0), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.yellow,
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      title: Text(caseData['name'] ?? 'Unknown Case'),
                      subtitle: Text(
                          'Judge: ${caseData['judgeName']}\nNext Date: ${caseData['nextDate']}\nProof: ${caseData['proof']}\nStatus: ${caseData['status']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Show the edit dialog when the edit icon is pressed
                          _showEditDialog(context, caseId);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
