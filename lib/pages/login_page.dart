import 'package:app_dev/components/my_Button.dart';
import 'package:app_dev/components/my_textfield.dart';
import 'package:app_dev/pages/homepage.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  Login({super.key, this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  void login(){
    // fill out auth here
    Navigator.push(context,MaterialPageRoute(builder: (context) => const Homepage(),),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Icon(
            Icons.store_mall_directory_rounded,
            size: 72,
            color: Theme.of(context).colorScheme.inversePrimary,),
          const SizedBox(height: 25),

          //message
          Text("SCALEUP",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
          ),
          //email
          const SizedBox(height: 25),
          MyTextfield(controller: emailController, hintText: "Email", obscureText: false),
          //password

          const SizedBox(height: 10),
          MyTextfield(controller: passwordController, hintText: "Password", obscureText: true),
          //new to the platform?
          const SizedBox(height: 25),
          MyButton(text: "Sign In", onTap: login
            ,),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New to the platform?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onTap,
                child: Text("Register Now",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
              )
              )
            ],
          )
        ],
      )
      )
    );
  }
}