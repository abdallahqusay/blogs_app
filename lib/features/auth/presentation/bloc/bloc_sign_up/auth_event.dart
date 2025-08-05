part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class ClickedSignUp extends AuthEvent {
  final String email;
   final String password;
    final String name;

  ClickedSignUp({required this.email, required this.password, required this.name});
}

