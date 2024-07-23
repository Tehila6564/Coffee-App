import 'package:cofee_app/components/app_bar.dart';
import 'package:cofee_app/const.dart';
import 'package:cofee_app/pages/cart_page.dart';
import 'package:cofee_app/pages/coffee_manager.dart';
import 'package:cofee_app/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({required this.email});

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateButtomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    final List _pages = [
      ShopPage(),
      CartPage(email: widget.email),
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyAppBar(
        onTabChange: navigateButtomBar,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Image.asset(
                  "lib/images/espresso.png",
                  height: 160,
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  email: widget.email,
                                )),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text("About"),
                    ),
                  ),
                ),
                widget.email == "tehila6564@gmail.com"
                    ? Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoffeeManager(),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text("manage products"),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 30,
                      )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 25, bottom: 25),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Logout"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Divider(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
