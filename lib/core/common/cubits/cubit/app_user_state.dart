part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class UserIsLoggedIn extends AppUserState{
  final User user;

  UserIsLoggedIn(this.user);
}
