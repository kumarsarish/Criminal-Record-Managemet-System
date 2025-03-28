import 'package:acejoker/ComplaintsPolice.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PolicePage extends StatefulWidget {
  @override
  _PolicePageState createState() => _PolicePageState();
}

class _PolicePageState extends State<PolicePage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true; // Loading state variable
  String searchQuery = ''; // To hold the search query

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      // Start loading
      setState(() {
        isLoading = true;
      });

      // Fetch users from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Criminals').get();

      // Convert Firestore documents to a list
      List<Map<String, dynamic>> usersList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Store data in the users array
      setState(() {
        users = usersList;
        filteredUsers = usersList; // Initialize filtered users
        isLoading = false; // Stop loading
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  void _filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUsers = users; // Reset to original list if query is empty
      });
    } else {
      setState(() {
        filteredUsers = users.where((user) {
          // Filter by ID (or any other field)
          return (user['Id'] as String)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void showUserDetailsDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${user['Name'] ?? 'N/A'}'),
                Text('ID: ${user['Id'] ?? 'N/A'}'),
                Text('Gender: ${user['Gender'] ?? 'N/A'}'),
                Text('Blood Group: ${user['Blood Group'] ?? 'N/A'}'),
                Text('Age: ${user['Age'] ?? 'N/A'}'),
                Text('City: ${user['City'] ?? 'N/A'}'),
                Text('Crime: ${user['Crime'] ?? 'N/A'}'),
                Text('Staus/Remarks: ${user['Remarks'] ?? 'N/A'}'),
                Text('Crime Date: ${user['Crime Date'] ?? 'N/A'}'),
                // Add more fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.yellow),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showAddUserDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController idController = TextEditingController();
    final TextEditingController genderController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Criminal'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                SizedBox(height: 10,),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'ID',
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
                SizedBox(height: 10,),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
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
          actions: <Widget>[
            TextButton(
              child: Text('Add', style: TextStyle(color: Colors.yellow)),
              onPressed: () async {
                // Add new user to Firestore
                await FirebaseFirestore.instance.collection('Criminals').add({
                  'Name': nameController.text,
                  'Id': idController.text,
                  'Gender': genderController.text,
                });

                // Close the dialog
                Navigator.of(context).pop();

                // Refresh the user list
                fetchUsers();
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
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
        title: Text('Police User'),
        forceMaterialTransparency: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PoliceComplaints()),
              );
            },
            child: Text(
              "View Complaints",
              style: TextStyle(color: Colors.yellow),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by ID',
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
                prefixIcon: Icon(Icons.search,
                    color: Colors.yellow), // Yellow search icon
              ),
              onChanged: (value) {
                searchQuery = value;
                _filterUsers(searchQuery); // Filter the users list
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.yellow,
                  )) // Show loading indicator
                : filteredUsers.isEmpty
                    ? Center(
                        child: Text('No data available.')) // Show empty state
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          // Get gender from user data
                          String gender = filteredUsers[index]['Gender'] ??
                              'Unknown'; // Adjust based on your data structure
                          Icon leadingIcon;

                          // Set the icon based on the gender
                          if (gender.toLowerCase() == 'male') {
                            leadingIcon = Icon(Icons.male, color: Colors.black);
                          } else if (gender.toLowerCase() == 'female') {
                            leadingIcon =
                                Icon(Icons.female, color: Colors.black);
                          } else {
                            leadingIcon = Icon(Icons.person,
                                color: Colors
                                    .black); // Default icon if gender is unknown
                          }
                          return Container(
                            margin: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              border:
                                  Border.all(color: Colors.yellow, width: 2),
                              borderRadius: BorderRadius.circular(
                                  16.0), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                textColor: Colors.black,
                                leading: leadingIcon,
                                trailing: IconButton(
                                  onPressed: () {
                                    showUserDetailsDialog(filteredUsers[index]);
                                  },
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(
                                    filteredUsers[index]['Name'] ?? 'No Name'),
                                subtitle:
                                    Text(filteredUsers[index]['Id'] ?? 'No Id'),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddUserDialog, // Show dialog to add a new user
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.yellow),
      ),
    );
  }
}
