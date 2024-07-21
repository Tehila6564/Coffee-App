import 'package:flutter/material.dart';

import '../model/coffee.dart';

class CartTile extends StatelessWidget {
  final Coffee coffee;
  final void Function()? onPressed;

  CartTile({
    required this.coffee,
    required this.onPressed,
  });

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: ListTile(
        leading: Image.asset(coffee.imagePath),
        title: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            coffee.name       
        ),
       
        ),
         subtitle: Text(
          "total price :\$${(coffee.price * coffee.quantity).toStringAsFixed(2)}\n quantity:${coffee.quantity}",
          ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.brown[300],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
