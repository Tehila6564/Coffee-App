import 'package:cofee_app/auth/product_auth.dart';
import 'package:cofee_app/firebase_options.dart';
import 'package:cofee_app/model/coffee_item.dart';
import 'package:flutter/material.dart';

import 'package:cofee_app/pages/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CoffeeShop()),
        ChangeNotifierProvider(
            create: (context) =>
                ProductService()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),

      ),
    );
  }
}
