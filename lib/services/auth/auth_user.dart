import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
      id: user.uid,
      email: user.email ?? '',
      isEmailVerified: user.emailVerified);
  //the factory AuthUser.fromFirebase(User user) is a factory constructor.
  //It's used to create an instance of the AuthUser class based on a User object obtained from Firebase Authentication.
}
