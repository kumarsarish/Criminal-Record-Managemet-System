import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupDialog extends StatefulWidget {
  @override
  _SignupDialogState createState() => _SignupDialogState();
}

class _SignupDialogState extends State<SignupDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorMessage;

  Future<void> _signup() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Close the dialog and optionally navigate to a different screen
      Navigator.of(context).pop();
      // Show success message or navigate
      //print('User signed up: ${userCredential.user?.email}');
      const snackBar = SnackBar(
        content: Text('Kindly Login With Your Email & Password User Created Successfully',style: TextStyle(color: Colors.yellow),),
        closeIconColor: Colors.yellow,showCloseIcon: true,
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sign Up'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: _emailController,
              cursorColor: Colors.yellow,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _errorMessage,
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
            SizedBox(height: 20,),
            TextField(
              controller: _passwordController,
              cursorColor: Colors.yellow,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorMessage,
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
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: _signup,
          child: Text('Sign Up',style: TextStyle(color: Colors.yellow),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel',style: TextStyle(color: Colors.red),),
        ),
      ],
    );
  }
}
