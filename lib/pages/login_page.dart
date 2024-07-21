import 'dart:math';
import 'package:cofee_app/auth/users_auth.dart';
import 'package:cofee_app/components/my_button.dart';
import 'package:cofee_app/components/my_text_filed.dart';
import 'package:cofee_app/pages/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "lib/images/latte.png",
            height: 120,
          ),
          Text("היי ברוכים הבאים"),
          Text("הזינו את מספר הטלפון או המייל כדי להיכנס"),
          MyTextField(
            controller: emailController,
            hintText: "מייל",
            obscureText: false,
          ),
          SizedBox(
            height: 20,
          ),
          MyButton(
            onTap: () async {
              await registerIfNotExists(emailController.text, "123456");
              
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IntroScreen()));
            },
            text: 'אישור',
          ),
          ElevatedButton(
              onPressed: sendVerificationEmail, child: Text("send email"))
        ],
      ),
    );
  }

  String generateVerificationCode() {
    String code = "";
    for (int i = 0; i < 6; i++) {
      code += Random().nextInt(10).toString();
    }
    return code;
  }

  final smtpServer = gmail("tehila6564@gmail.com", "bfya kivk hpam uujt");

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    final message = Message()
      ..from = Address("tehila6564@gmail.com", 'Coffee App')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> sendVerificationEmail() async {
    String email = emailController.text;
    String code = generateVerificationCode();
    String subject = "Your Verification Code";
    String body = "Your verification code is: $code";

    await sendEmail(email, subject, body);
  }

  Future<void> registerIfNotExists(String email, String password) async {
    final authService = AuthService();

    try {
      print(email);
      print(password);
      await authService.signInWithEmailPassword(
        email,
        password,
      );
      print("sign in successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // User does not exist, so register the user
        try {
          await authService.signUpWithEmailPassword(
            emailController.text,
            passwordController.text,
          );
        } catch (e) {
          print("Error registering user: ${e}");
        }
      } else {
        print("Error checking user existence: ${e.message}");
      }
    } catch (e) {
      print("Unexpected error: ${e.toString()}");
    }
  }
}
