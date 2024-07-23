import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofee_app/auth/email_service.dart';
import 'package:cofee_app/components/my_button.dart';
import 'package:cofee_app/const.dart';
import 'package:cofee_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _verificationId;
  bool _isCodeSent = false;
  bool _isEmailSelected = false;

  void _verifyPhoneNumber() async {
    String phoneNumber = _phoneController.text.trim();

    if (!phoneNumber.startsWith("+")) {
      phoneNumber = "+972" + phoneNumber;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _checkIfNewUser();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Verification Failed: ${e.message}"),
          backgroundColor: Colors.red,
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _checkIfNewUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: _emailController.text.trim())
          .get();
      if (userDocs.docs.isEmpty) {
        _registerNewUser();
      } else {
        _navigateToHome();
      }
    }
  }

  void _sendVerificationEmail() async {
    String email = _emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a valid email address"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    String code = _generateVerificationCode();
    await sendVerificationEmail(email, code);
    setState(() {
      _verificationId = code;
      _isCodeSent = true;
    });
  }

  void _signInSMSCode() async {
    if (_verificationId != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _checkIfNewUser();
    }
  }

  void _signInWithEmailCode() async {
    if (_verificationId == _codeController.text) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _verificationId!,
        );
        _checkIfNewUser();
      } catch (e) {
        print("SignIn error: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Sign In Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ));
        _registerNewUser();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid Code"),
        backgroundColor: Colors.red,
      ));
    }
  }

  String _generateVerificationCode() {
    String code = "";
    for (int i = 0; i < 6; i++) {
      code += (0 + Random().nextInt(10)).toString();
    }
    return code;
  }

  void _registerNewUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').add({
        'name': _emailController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
      _navigateToHome();
    }
  }

  void _navigateToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("lib/images/latte.png", height: 100),
              SizedBox(height: 24),
              Text(
                "Hi, Welcome!",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              SizedBox(height: 8),
              Text("Enter email or phone number to enter"),
              SizedBox(height: 16),
              ToggleButtons(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Phone"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Email"),
                  ),
                ],
                isSelected: [_isEmailSelected == false, _isEmailSelected == true],
                onPressed: (index) {
                  setState(() {
                    _isEmailSelected = index == 1;
                    _isCodeSent = false;
                  });
                },
              ),
              SizedBox(height: 16),
              if (!_isEmailSelected) ...[
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixText: "+972",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ] else ...[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
              SizedBox(height: 16),
              if (!_isCodeSent) ...[
                MyButton(
                  text: _isEmailSelected
                      ? "Send me verification code via email"
                      : "Send me verification code",
                  onTap: _isEmailSelected ? _sendVerificationEmail : _verifyPhoneNumber,
                ),
              ] else ...[
                Text(
                  _isEmailSelected
                      ? "We sent you a verification code via email"
                      : "We sent you a verification code via phone",
                  style: TextStyle(color: Colors.brown),
                ),
                SizedBox(height: 8),
                Text(
                  _isEmailSelected ? _emailController.text : _phoneController.text,
                  style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "Verification Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                MyButton(
                  text: "OK",
                  onTap: _isEmailSelected ? _signInWithEmailCode : _signInSMSCode,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
