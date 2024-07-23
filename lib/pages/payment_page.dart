import 'package:cofee_app/auth/email_service.dart';
import 'package:cofee_app/model/coffee_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:cofee_app/pages/cart_page.dart';
import 'package:provider/provider.dart'; 

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final String email;
  PaymentPage({required this.totalPrice, required this.email});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel data) {
    setState(() {
      cardNumber = data.cardNumber;
      expiryDate = data.expiryDate;
      cardHolderName = data.cardHolderName;
      cvvCode = data.cvvCode;
      isCvvFocused = data.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange:
                  (creditCardBrand) {}, // Required callback
            ),
            CreditCardForm(
              formKey: formKey,
              onCreditCardModelChange: onCreditCardModelChange,
              themeColor: Colors.blue,
              obscureCvv: true,
              obscureNumber: true,
              cardNumberDecoration: InputDecoration(
                labelText: 'Card Number',
                hintText: 'XXXX XXXX XXXX XXXX',
                border: OutlineInputBorder(),
              ),
              expiryDateDecoration: InputDecoration(
                labelText: 'Expiry Date',
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
              ),
              cvvCodeDecoration: InputDecoration(
                labelText: 'CVV',
                hintText: 'XXX',
                border: OutlineInputBorder(),
              ),
              cardHolderDecoration: InputDecoration(
                labelText: 'Card Holder',
                border: OutlineInputBorder(),
              ),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Successful')),
                    );

                    Provider.of<CoffeeShop>(context, listen: false).clearCart();
                    
                   Navigator.pop(context);
                      Navigator.pop(context);
                   
                    orderDatail(widget.email, widget.totalPrice);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid details')),
                    );
                  }
                },
                child: Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}