// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // אימות משתמש

//   final FirebaseFirestore _firebaseFirestore =
//       FirebaseFirestore.instance; // מסד נתונים

//   User? getCurrentUser() {
//     return _firebaseAuth.currentUser;
//   }

//   Future<UserCredential> signInWithEmailPassword(
//       String email, String password) async {
//     try {
//       // Attempt to sign in with email and password
//       UserCredential userCredential =
//           await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Ensure userCredential.user is not null
//       if (userCredential.user == null) {
//         throw Exception('User not found after sign-in');
//       }

//       // Update Firestore with user details
//       await _firebaseFirestore
//           .collection('Users')
//           .doc(userCredential.user!.uid)
//           .set(
//         {
//           'uid': userCredential.user!.uid,
//           'email': email,
//         },
//         SetOptions(merge: true),
//       );

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       // Handle specific FirebaseAuth exceptions
//       print('Firebase Auth Exception: ${e.message}');
//       throw Exception('Firebase Auth Error: ${e.code}');
//     } on FirebaseException catch (e) {
//       // Handle other Firebase exceptions
//       print('Firebase Exception: ${e.message}');
//       throw Exception('Firebase Error: ${e.code}');
//     } catch (e) {
//       // Handle any other exceptions
//       print('General Exception: $e');
//       throw Exception('An unexpected error occurred');
//     }
//   }

//   Future<UserCredential> signUpWithEmailPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       _firebaseFirestore.collection('Users').doc(userCredential.user!.uid).set({
//         'uid': userCredential.user!.uid,
//         'email': email,
//       });

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }

//   Future<void> signOut() async {
//     return await _firebaseAuth.signOut();
//   }

// }
