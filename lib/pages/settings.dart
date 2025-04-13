import 'package:app_dev/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),),
            margin: const EdgeInsets.only(left: 25.00, top: 10, right: 25),
            padding: const EdgeInsets.all(25.00),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text(
                "Dark mode",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color:Theme.of(context).colorScheme.inversePrimary,
            ),
            ),

            CupertinoSwitch(value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
               onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
