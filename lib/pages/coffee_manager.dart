import 'package:cofee_app/auth/product_auth.dart';
import 'package:cofee_app/model/coffee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeManager extends StatefulWidget {
  @override
  _CoffeeManagerState createState() => _CoffeeManagerState();
}

class _CoffeeManagerState extends State<CoffeeManager> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePathController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imagePathController,
              decoration: InputDecoration(labelText: 'Image Path'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final price = double.tryParse(_priceController.text) ?? 0.0;
                final imagePath = _imagePathController.text;

                if (name.isNotEmpty && price > 0 && imagePath.isNotEmpty) {
                  await productService.addProduct(name, price, imagePath);
                  _nameController.clear();
                  _priceController.clear();
                  _imagePathController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product added successfully')),
                  );
                  // Refresh product list after adding
                  setState(() {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
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
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await productService.deleteProduct(product.name);
                            print("delete product: " + product.name);
                          
                            setState(() {});
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
      ),
    );
  }
}
