import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const android = FirebaseOptions(
      apiKey: 'AIzaSyCXhcDNWB3u9FJ5ZKIxz0fVWRSd7rmKjLo',
      appId: '1:1060539087508:android:f3d2b60dcccc6f7c8a1281',
      messagingSenderId: '1060539087508',
      projectId: 'coffee-app-dea50',
      storageBucket: 'coffee-app-dea50.appspot.com');
}
