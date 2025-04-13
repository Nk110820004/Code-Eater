import 'package:flutter/material.dart';

import '../components/my_Button.dart';
import '../components/my_textfield.dart';
class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap,});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
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
                  Icons.store_mall_directory_outlined,
                  size: 72,
                  color: Theme.of(context).colorScheme.inversePrimary,),
                const SizedBox(height: 25),

                //message
                Text("Lets Create An Account For You",
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
                const SizedBox(height: 10),
                MyTextfield(controller: confirmpasswordController, hintText: "Confirm Password", obscureText: true),
                //new to the platform?
                const SizedBox(height: 25),
                MyButton(text: "Sign Up", onTap: (){

                },),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have An Account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,

                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Login Now",
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
