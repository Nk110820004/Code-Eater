import 'package:app_dev/components/drawer_tile.dart';
import 'package:flutter/material.dart';

import '../pages/homepage.dart';
import '../pages/login_page.dart';
import '../pages/settings.dart';
class IfDrawer extends StatefulWidget {
  const IfDrawer({super.key});

  @override
  State<IfDrawer> createState() => _IfDrawerState();
}

class _IfDrawerState extends State<IfDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //app logo
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: Icon(
              Icons.store_mall_directory_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 2,
            ),
          ),



          //home list tile
          DrawerTile(text: "H O M E", icon: Icons.home, onTap: () => Navigator.pop(context),
    ),
          //settings tile
       DrawerTile(
    text: "S E T T I N G S",
    icon: Icons.settings,
    onTap: () {Navigator.pop(context);Navigator.push(context, MaterialPageRoute(builder: (context) => const settings(),),);},),
          const Spacer(),

          //logout tile
          DrawerTile(
            text: "L O G O U T",
            icon: Icons.exit_to_app_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
          ),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
