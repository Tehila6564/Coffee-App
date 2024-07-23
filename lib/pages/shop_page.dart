import 'package:cofee_app/auth/product_auth.dart';
import 'package:cofee_app/components/coffee_tile.dart';
import 'package:cofee_app/model/coffee.dart';
import 'package:cofee_app/model/coffee_item.dart';
import 'package:cofee_app/pages/coffee_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class ShopPage extends StatefulWidget{
  State<ShopPage> createState()=>_ShopPageState();

}

class _ShopPageState extends State<ShopPage>{
void goToCoffeePage(Coffee coffee) {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) => CoffeeOrderPage(coffee: coffee),

      ),

    );

  }
  Widget build(BuildContext context){
     final productService = Provider.of<ProductService>(context);
    return Consumer<CoffeeShop>(
builder:(context, value, child)=> Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
  Padding(
    padding: EdgeInsets.only(left: 25,top: 25),
    child:Text(
      "how do you like your coffee?",
      style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
              child: FutureBuilder<List<Coffee>>(
                future: productService.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products available'));
                  }

                  final products = snapshot.data!;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        leading: Image.asset(product.imagePath),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward, color: Colors.brown[300],),
                          onPressed: ()  {
                          goToCoffeePage(product);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}