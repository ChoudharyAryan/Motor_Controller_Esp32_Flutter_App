import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motor_controller_esp32/views/MainPage.dart';
import 'package:motor_controller_esp32/services/auth/auth_exceptions.dart';
import 'package:motor_controller_esp32/services/auth/firebase_auth_provider.dart';
import 'package:motor_controller_esp32/util/GenericAlertDilog.dart';
import 'package:motor_controller_esp32/util/cupButton.dart';
import 'package:motor_controller_esp32/util/loading_screen/loading_screen.dart';
import 'package:motor_controller_esp32/util/squareTile.dart';
import 'package:motor_controller_esp32/util/textfield.dart';
import 'package:motor_controller_esp32/services/auth/bloc/auth_bloc_bloc.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final emailController = TextEditingController();

  final passController = TextEditingController();
  String welcomeText = 'Welcome To The Bowler';
  String forgotPass = 'Forgot Password';
  String cupText = 'Login';
  String continueText = 'or continue with';
  String bottomText1 = 'Not a member?';
  String bottomText2 = 'Register now';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.isLoading) {
            log('let it load i said let it load');
            LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'please wait',
            );
          } else {
            log('stop the loading');
            LoadingScreen().hide();
          }
          if (state is AuthStateLoggedOut) {
            log('LOGGED OUT');
            if (state.exception is UserNotFoundAuthException) {
              ShowErrorSnackBar(
                context,
                'Cannot find a user with the entered credentials!',
              );
            } else if (state.exception is WrongPasswordAuthException) {
              ShowErrorSnackBar(context, 'Wrong credentials');
            } else if (state.exception is GenericAuthException) {
              ShowErrorSnackBar(context, 'Authentication error');
            }
          } else if (state is AuthStateRegistring) {
            if (state.exception is WeakPasswordAuthException) {
              ShowErrorSnackBar(context, 'Weak password');
            } else if (state.exception is InvalidEmailAuthException) {
              ShowErrorSnackBar(context, 'Invalid email');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              ShowErrorSnackBar(context, 'Email already in use');
            } else if (state.exception is GenericAuthException) {
              ShowErrorSnackBar(context, 'Failed to register');
            }
          } else if (state is AuthStateForgotPassword) {
            if (state.hasSentEmail) {
              emailController.clear();
              ShowErrorSnackBar(context, 'Email sent check your inbox');
            } else if (state.exception is InvalidEmailAuthException) {
              ShowErrorSnackBar(context, 'Invalid email');
            } else if (state.exception is UserNotFoundAuthException) {
              ShowErrorSnackBar(context, 'User not found');
            } else if (state.exception is GenericAuthException) {
              ShowErrorSnackBar(context, 'Failed to send email');
            }
          } else if (state is AuthStateNeedsVerification) {
            ShowErrorSnackBar(context, 'Please verify your email');
          } else if (state is AuthStateLoggedIn) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return MainPage();
            }), (route) => false);
          }
          welcomeText = state is AuthStateUnInitialized ||
                  state is AuthStateLoggedOut
              ? 'Welcome To The Bowler'
              : state is AuthStateRegistring
                  ? 'Register Yourself'
                  : state is AuthStateNeedsVerification
                      ? '  we\'ve just sent you an email verification please click on the link to verify your email'
                      : state is AuthStateForgotPassword
                          ? 'Reset Your Password'
                          : 'what\'s left $state';
          forgotPass =
              state is AuthStateUnInitialized || state is AuthStateLoggedOut
                  ? 'Forgot Password'
                  : '';
          cupText =
              state is AuthStateUnInitialized || state is AuthStateLoggedOut
                  ? 'Login'
                  : state is AuthStateRegistring
                      ? 'Register'
                      : state is AuthStateNeedsVerification
                          ? 'Send Verification Email'
                          : state is AuthStateForgotPassword
                              ? 'Send Password Reset Email'
                              : '';
          continueText = state is AuthStateUnInitialized ||
                  state is AuthStateLoggedOut ||
                  state is AuthStateRegistring
              ? 'or continue with'
              : '';
          bottomText1 =
              state is AuthStateUnInitialized || state is AuthStateLoggedOut
                  ? 'Not a member?'
                  : state is AuthStateRegistring
                      ? 'Already registered?'
                      : state is AuthStateNeedsVerification
                          ? ''
                          : state is AuthStateForgotPassword
                              ? ''
                              : '';
          bottomText2 =
              state is AuthStateUnInitialized || state is AuthStateLoggedOut
                  ? 'Register now'
                  : state is AuthStateRegistring
                      ? 'Login now?'
                      : state is AuthStateNeedsVerification
                          ? 'Go to login page'
                          : state is AuthStateForgotPassword
                              ? 'Go to login page'
                              : '';
        },
        builder: (BuildContext context, AuthState state) {
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(welcomeText,
                              style: GoogleFonts.josefinSans(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        //USERNAME
                        Container(
                          child: state is AuthStateNeedsVerification
                              ? null
                              : Textfield(
                                  controller: emailController,
                                  hintText: 'Email',
                                  obscure: false,
                                ),
                        ),
                        SizedBox(
                          height: state is AuthStateUnInitialized ||
                                  state is AuthStateRegistring ||
                                  state is AuthStateLoggedOut
                              ? 25
                              : 0,
                        ),

                        //PASSWORD
                        Container(
                            child: state is AuthStateUnInitialized ||
                                    state is AuthStateRegistring ||
                                    state is AuthStateLoggedOut
                                ? Textfield(
                                    controller: passController,
                                    hintText: 'Password',
                                    obscure: true)
                                : null),
                        SizedBox(
                          height: state is AuthStateUnInitialized ||
                                  state is AuthStateRegistring ||
                                  state is AuthStateLoggedOut
                              ? 25
                              : 0,
                        ),
                        //FORGOT PASSWORD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  state is AuthStateLoggedOut ||
                                          state is AuthStateUnInitialized
                                      ? context.read<AuthBloc>().add(
                                          AuthEventForgotPassword(
                                              emailController.text))
                                      : null;
                                },
                                child: Text(
                                  forgotPass,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: state is AuthStateUnInitialized ||
                                  state is AuthStateRegistring ||
                                  state is AuthStateLoggedOut
                              ? 25
                              : 0,
                        ),

                        //SIGN IN
                        CupButton(
                          text: cupText,
                          onPressed: () {
                            context.read<AuthBloc>().add(state
                                        is AuthStateUnInitialized ||
                                    state is AuthStateLoggedOut
                                ? AuthEventLogin(
                                    emailController.text, passController.text)
                                : state is AuthStateRegistring
                                    ? AuthEventRegister(emailController.text,
                                        passController.text)
                                    : state is AuthStateForgotPassword
                                        ? AuthEventForgotPassword(
                                            emailController.text)
                                        : state is AuthStateNeedsVerification
                                            ? AuthEventSendEmailVerificationEmail(
                                                emailController.text)
                                            : const AuthEventLogOut());
                          },
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  continueText,
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

                        //REGISTER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(bottomText1),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<AuthBloc>().add(state
                                            is AuthStateUnInitialized ||
                                        state is AuthStateLoggedOut
                                    ? const AuthEventShouldRegister()
                                    : state is AuthStateRegistring
                                        ? const AuthEventLogOut()
                                        : state is AuthStateForgotPassword ||
                                                state
                                                    is AuthStateNeedsVerification
                                            ? const AuthEventLogOut()
                                            : const AuthEventLogOut());
                              },
                              child: Text(
                                bottomText2,
                                style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
