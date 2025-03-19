import 'package:acejoker/CBI.dart';
import 'package:acejoker/CBILogin.dart';
import 'package:acejoker/Judge Page.dart';
import 'package:acejoker/JudgeLogin.dart';
import 'package:acejoker/LoginPage.dart';
import 'package:acejoker/Police.dart';
import 'package:acejoker/PoliceLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JudgeLogin extends StatefulWidget {
  @override
  _JudgeLoginState createState() => _JudgeLoginState();
}

class _JudgeLoginState extends State<JudgeLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();  // New controller for the numeric field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Password visibility state
  bool _isPasswordVisible = false;

  void _signIn() async {
    String email = _usernameController.text;
    String password = _passwordController.text;

    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the signed-in user
      User? user = userCredential.user;

      if (user != null) {
        String securityCode = _securityCodeController.text;

        // Check if the security code matches
        if (securityCode == '654321') {
          // Security code is correct, navigate to the JudgePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JudgePage(),
            ),
          );
        } else {
          _showSnackbar('Invalid security code');
        }
      }
    } catch (e) {
      _showSnackbar(e.toString()); // Show the error message in a Snackbar
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(message, style: TextStyle(color: Colors.yellow)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "CRIMINAL RECORD MANAGEMENT SYSTEM",
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PoliceLogin()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Police",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JudgeLogin()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Judge",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CBILogin()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "CBI",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "User",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Judge.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2.7,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Judge Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 10),
                  child: TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Username (Email)",
                      labelStyle:
                      TextStyle(color: Colors.black), // Yellow label color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black), // Yellow border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black), // Yellow border when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 2), // Yellow border when focused
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 10),
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle:
                      TextStyle(color: Colors.black), // Yellow label color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black), // Yellow border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black), // Yellow border when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 2), // Yellow border when focused
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: Colors.black,
                          // Toggle the password visibility icon
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                            !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible, // Toggle obscure text
                  ),
                ),

                // New Numeric Field for Security Code
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 10),
                  child: TextField(
                    controller: _securityCodeController,
                    keyboardType: TextInputType.number, // Only numeric input
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Enter Judge Code",
                      labelStyle:
                      TextStyle(color: Colors.black), // Yellow label color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black), // Yellow border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black), // Yellow border when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 2), // Yellow border when focused
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signIn,
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.login_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
