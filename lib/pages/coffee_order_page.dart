import 'package:cofee_app/components/my_button.dart';
import 'package:cofee_app/components/my_chip.dart';
import 'package:cofee_app/const.dart';
import 'package:cofee_app/model/coffee.dart';
import 'package:cofee_app/model/coffee_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

class CoffeeOrderPage extends StatefulWidget {
  Coffee coffee;
  CoffeeOrderPage({required this.coffee});
  State<CoffeeOrderPage> createState() => _CoffeeOrderPageState();
}

class _CoffeeOrderPageState extends State<CoffeeOrderPage> {
  int quantity = 1;
  late ConfettiController _confetiiController;

  void initState() {
    super.initState();
    _confetiiController = ConfettiController(duration: Duration(seconds: 3));
  }

  final List<bool> _sizeSelection = [true, false, false];

  void selectSize(String size) {
    setState(() {
      _sizeSelection[0] = size == 'S';
      _sizeSelection[1] = size == 'M';
      _sizeSelection[2] = size == 'L';
    });
  }

  void addToCart() {
    if (quantity > 0) {
      Provider.of<CoffeeShop>(context, listen: false)
          .addToCart(widget.coffee, quantity);
      _confetiiController.play();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            "Sucssessfuly added to cart",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: Text(
                "ok",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ).then((_) {
        _confetiiController.stop();
      });
    }
  }

  void increment() {
    setState(() {
      if (quantity < 10) {
        quantity++;
      }
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 0) {
        quantity--;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[900],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.coffee.imagePath,
                    height: 120,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      Text(
                        "Q U A N T I T Y",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: decrement,
                            icon: Icon(Icons.remove),
                            color: Colors.grey,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 60,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: increment,
                            icon: Icon(Icons.add),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "S I Z E",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => selectSize('S'),
                        child: MyChip(
                          text: 'S',
                          isSelected: _sizeSelection[0],
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => selectSize('M'),
                        child: MyChip(
                          text: 'M',
                          isSelected: _sizeSelection[1],
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => selectSize('L'),
                        child: MyChip(
                          text: 'L',
                          isSelected: _sizeSelection[2],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  MyButton(
                    text: 'add to cart',
                    onTap: addToCart,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetiiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.pink,
              ],
            ),
          )
        ],
      ),
    );
  }
}
