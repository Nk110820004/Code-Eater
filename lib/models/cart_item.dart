import 'package:app_dev/models/people.dart';
import 'package:flutter/cupertino.dart';

class CartItem{
  Person person;
  List<Addon> selectedAddons;
  int quantity;

  CartItem({
    required this.person,
  required this.selectedAddons,
  this.quantity =1,
});
  double get totalPrice{
    double addonsPrice = selectedAddons.fold(0, (sum,addon) => sum + addon.price);
    return (person.price + addonsPrice)+ quantity;
  }
}