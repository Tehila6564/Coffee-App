import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofee_app/model/coffee.dart';
import 'package:flutter/material.dart';

class ProductService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(String name, double price, String imagePath) async {
    final newCoffee = Coffee(
      name: name,
      price: price,
      imagePath: imagePath,
    );

    try {
      await _firestore.collection('coffee').add({
        'name': newCoffee.name,
        'price': newCoffee.price,
        'imagePath': newCoffee.imagePath,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<List<Coffee>> getProducts() async {
    try {
      final querySnapshot = await _firestore.collection('coffee').get();
      final coffeeList = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Coffee(
          name: data['name'],
          price: data['price'],
          imagePath: data['imagePath'],
        );
      }).toList();
      return coffeeList;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<void> deleteProduct(String itemName) async {
    try {
      // Assuming 'itemName' is a field in your documents that uniquely identifies them
      QuerySnapshot querySnapshot = await _firestore
          .collection('coffee')
          .where('name', isEqualTo: itemName)
          .get();

      if (querySnapshot.size > 0) {
        String docId = querySnapshot.docs[0].id; // Retrieve the document ID
        await _firestore.collection('coffee').doc(docId).delete();
        print('Product deleted successfully: $itemName');
        notifyListeners();
      } else {
        print('Product with name $itemName not found');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
