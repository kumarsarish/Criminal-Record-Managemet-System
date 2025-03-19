import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintsScreen extends StatefulWidget {
  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  List<Map<String, dynamic>> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Complaints').get();
      List<Map<String, dynamic>> complaintsList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {
        complaints = complaintsList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching complaints: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addComplaint(String criminal, String crime, String proof) async {
    try {
      await FirebaseFirestore.instance.collection('Complaints').add({
        'Criminal': criminal,
        'Crime': crime,
        'Proof': proof,
      });
      fetchComplaints(); // Refresh the list after adding
    } catch (e) {
      print('Error adding complaint: $e');
    }
  }

  void showAddComplaintDialog() {
    String criminal = '';
    String crime = '';
    String proof = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Complaint'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  criminal = value;
                },
                decoration: InputDecoration(
                  labelText: 'Criminal',
                  labelStyle:
                      TextStyle(color: Colors.yellow), // Yellow label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.yellow), // Yellow border color
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
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  crime = value;
                },
                decoration: InputDecoration(
                  labelText: 'Crime',
                  labelStyle:
                      TextStyle(color: Colors.yellow), // Yellow label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.yellow), // Yellow border color
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
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  proof = value;
                },
                decoration: InputDecoration(
                  labelText: 'Proof',
                  labelStyle:
                      TextStyle(color: Colors.yellow), // Yellow label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.yellow), // Yellow border color
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (criminal.isNotEmpty && crime.isNotEmpty) {
                  addComplaint(criminal, crime, proof);
                  Navigator.of(context).pop();
                } else {
                  // Show error if inputs are not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text(
                'Add Complaint',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.yellow,
            ))
          : complaints.isEmpty
              ? Center(child: Text('No complaints available.'))
              : ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.yellow,
                      margin: EdgeInsets.all(10.0),
                      child: ListTile(
                        textColor: Colors.black,
                        title: Text(complaints[index]['Criminal'] ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Crime: ${complaints[index]['Crime'] ?? 'No crime specified'}'),
                            Text(
                                'Proof: ${complaints[index]['Proof'] ?? 'No proof provided'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: showAddComplaintDialog,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        tooltip: 'Add Complaint',
      ),
    );
  }
}
