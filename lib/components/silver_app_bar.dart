import 'package:flutter/material.dart';
class MySilverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySilverAppBar({super.key,
    required this.child,
  required this.title,});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      collapsedHeight: 120,
      floating: false,
      pinned: true,
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart,
        ))
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Influencers"),
        flexibleSpace: FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: child,
          ),
          centerTitle: true,
          titlePadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        ),
    );
  }
}
