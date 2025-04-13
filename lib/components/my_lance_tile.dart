import 'package:flutter/material.dart';

import '../models/people.dart';
class lanceTile extends StatelessWidget {
  final Person lance;
  final void Function()? onTap;
  const lanceTile({super.key,
  required this.lance,
  required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lance.name),
                        Text(lance.price.toString(), style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                        const SizedBox(height: 10,),
                        Text(lance.description,
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                      ],
                    ),),
                const SizedBox(width:15),
                ClipRRect(borderRadius:BorderRadius.circular(8),
                    child: Image.asset(lance.imagePath, height: 120, width: 100,)),
              ],
            ),
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.tertiary,
        endIndent: 25,
        indent: 25,)
      ],
    );
  }
}
