import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/util/cupButton.dart';
import 'package:motor_controller_esp32/util/squareTile.dart';
import 'package:motor_controller_esp32/util/textfield.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        230,
        231,
        232,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
              ),
              // LOGO
              Image.asset(
                'lib/images/cricket.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 50,
              ),

              //WELCOME
              Text('WELCOME TO THE BOWLER',
                  style: GoogleFonts.josefinSans(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(
                height: 25,
              ),

              //USERNAME
              Textfield(
                controller: emailController,
                hintText: 'Email',
                obscure: false,
              ),
              const SizedBox(
                height: 25,
              ),

              //PASSWORD
              Textfield(
                  controller: passController,
                  hintText: 'Password',
                  obscure: true),
              const SizedBox(
                height: 25,
              ),
              //FORGOT PASSWORD
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              //SIGN IN
              CupButton(
                text: 'Login',
                onPressed: () {},
              ),
              const SizedBox(
                height: 25,
              ),

              //CONTINUE WITH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              //GOOGLE
              const SquareTile(imagePath: 'lib/images/google.png'),
              const SizedBox(
                height: 50,
              ),

              //REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
