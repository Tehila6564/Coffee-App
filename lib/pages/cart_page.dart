import 'package:cofee_app/components/cart_tile.dart';
import 'package:cofee_app/components/my_button.dart';
import 'package:cofee_app/model/coffee.dart';
import 'package:cofee_app/model/coffee_item.dart';
import 'package:cofee_app/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Your Cart",
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: value.userCart.length,
              itemBuilder: (context, index) {
                Coffee eachCoffee = value.userCart[index];
                return CartTile(
                  coffee: eachCoffee,
                  onPressed: () =>
                      Provider.of<CoffeeShop>(context, listen: false)
                          .removeFromCart(eachCoffee),
                );
              },
            ),
          ),
          SizedBox(
            height: 75,
          ),
          MyButton(
            text: 'pay now',
            onTap: () {
              Provider.of<CoffeeShop>(context, listen: false).clearCart();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(totalPrice: 3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
