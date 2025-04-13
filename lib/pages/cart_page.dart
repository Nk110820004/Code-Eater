import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/people.dart';
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Person>(builder: (context, person,child){
      final userCart = person.cart;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),

      );
    },);
  }
}
