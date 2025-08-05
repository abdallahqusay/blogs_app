import 'package:flutter/material.dart';

@immutable
sealed class BlocEvent {}

class ClickedSignIn extends BlocEvent {
  final String email;
  final String password;

  ClickedSignIn({required this.email, required this.password});
}
