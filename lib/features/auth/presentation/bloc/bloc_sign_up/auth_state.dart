part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState{}

class AuthSucsess extends AuthState{
    final User user;

  AuthSucsess(this.user);
}

class AuthFaiulre extends AuthState{

    final String message;

  AuthFaiulre(this.message);
}
