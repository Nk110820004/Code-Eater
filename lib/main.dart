import 'package:app_dev/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:app_dev/themes/theme_provider.dart';
import 'auth/loginorreg.dart';
import 'themes//dark_mode.dart';
import 'themes//light_mode.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';

void main(){

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>ThemeProvider()),
      ChangeNotifierProvider(create: (context)=>Org()),
    ],
    child: const MyApp(),)
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: lightMode, // Default light theme
      darkTheme: darkMode, // Default dark theme
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

    );
  }
}
