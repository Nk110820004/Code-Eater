import 'package:app_dev/components/my_Button.dart';
import 'package:app_dev/models/people.dart';
import 'package:app_dev/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatefulWidget {
  final Person person;
  final Map<Addon, bool> selectedAddons = {};

  PersonPage({super.key, required this.person}){
   for (Addon addon in person.availableAddons){
     selectedAddons[addon] = false;
   }
  }

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  void addToCart(Person person, Map<Addon, bool> selectedAddons) {
    Navigator.pop(context);
    List<Addon> currentlySelectedAddon = [];
    for(Addon addon in widget.person.availableAddons){
      if(widget.selectedAddons[addon] == true){
        currentlySelectedAddon.add(addon);
      }

    }
    context.read<Org>().addToCart(person, currentlySelectedAddon);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
    Scaffold(

    body: SafeArea(
    child: SingleChildScrollView(
    child: Column(
    children: [
    Image.asset(
      widget.person.imagePath,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
    ),
    Padding(
    padding: const EdgeInsets.all(25.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    widget.person.name,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    ),
    ),
    Text(
    '₹'+widget.person.price.toString(),
    style: TextStyle(
    fontSize: 16,
    color: Theme.of(context).colorScheme.primary,
    ),
    ),
    const SizedBox(height: 10),
    Text(widget.person.description),
    const SizedBox(height: 10),
    Text("Add-ons",
    style:TextStyle(
    color: Theme.of(context).colorScheme.inversePrimary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    // Replace ListView.builder with Column of CheckboxListTiles
    ...widget.person.availableAddons.map((addon) =>
    Container(
    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.tertiary),
    borderRadius: BorderRadius.circular(8),),
    child: CheckboxListTile(
    title: Text(addon.name),
    subtitle: Text('₹'+addon.price.toString(), style: TextStyle(
    color: Theme.of(context).colorScheme.primary,
    ),
    ),
    value: widget.selectedAddons[addon],
    onChanged: (value) {},
    ),
    )
    ).toList(),
    ],
    ),
    ),
    MyButton(text: "Add Service to cart", onTap: () => addToCart(widget.person, widget.selectedAddons)),
    const SizedBox(height: 25,)
    ],
    ),
    ),
    ),
    ),
      SafeArea(
        child: Opacity(
          opacity: 0.6,
          child: Container(
              margin: EdgeInsets.only(left: 25),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle ),
          child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_outlined))),
        ),
      ),
        
      ],
    );
  }
}
