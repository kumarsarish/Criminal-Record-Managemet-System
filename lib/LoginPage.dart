import 'package:acejoker/CBILogin.dart';
import 'package:acejoker/JudgeLogin.dart';
import 'package:acejoker/NewUser.dart';
import 'package:acejoker/PoliceLogin.dart';
import 'package:flutter/material.dart';
import 'package:acejoker/CBI.dart';
import 'package:acejoker/Judge Page.dart';
import 'package:acejoker/Police.dart';
import 'package:acejoker/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

void _showPasswordResetDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Reset Password'),
        content: TextField(
          cursorColor: Colors.yellow,
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Enter your email",
            labelStyle: TextStyle(color: Colors.yellow), // Yellow label color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(color: Colors.yellow), // Yellow border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(color: Colors.yellow), // Yellow border when enabled
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                  color: Colors.yellow, width: 2), // Yellow border when focused
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',style: TextStyle(color: Colors.red),),
          ),
          TextButton(
            onPressed: () async {
              String email = emailController.text.trim();
              if (email.isNotEmpty) {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  Navigator.of(context).pop();
                  _showSuccessDialog(context);
                } catch (e) {
                  // Handle error (e.g., email not found)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter an email address')),
                );
              }
            },
            child: Text('Send Reset Email',style: TextStyle(color: Colors.yellow),),
          ),
        ],
      );
    },
  );
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Email Sent'),
        content: Text(
            'A password reset email has been sent. Please check your inbox.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK',style: TextStyle(color: Colors.yellow),),
          ),
        ],
      );
    },
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // New variable to toggle password visibility
  bool _isPasswordVisible = false;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Login successful
      //print("Login successful");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      // Uncomment the following line and set your home route
      // Navigator.pushReplacementNamed(context, '/home'); // Replace with your home route
    } on FirebaseAuthException catch (e) {
      // Show error message in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An unknown error occurred',style: TextStyle(color: Colors.yellow),),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SignupDialog(),
              );
            },
            child: Text(
              "New User Sign Up",
              style: TextStyle(color: Colors.yellow),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.black,
        title: Text(
          "CRIMINAL RECORD MANAGEMENT SYSTEM",
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
      ),
      extendBodyBehindAppBar: true,
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
            image: AssetImage('assets/bg.jpeg'),
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
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "General User LOGIN",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 10),
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    obscureText: !_isPasswordVisible, // Toggle visibility
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle the state
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        _showPasswordResetDialog(context);
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _login,
        child: Icon(
          Icons.login_rounded,
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
