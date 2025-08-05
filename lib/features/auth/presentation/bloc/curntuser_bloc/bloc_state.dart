part of 'bloc_bloc.dart';

sealed class BlocState {}

final class BlocInitial extends BlocState {}

final class BlocFaiulre extends BlocState {
  final String message;

  BlocFaiulre(this.message);
}

final class BlocSucsess extends BlocState {
  final User user;

  BlocSucsess(this.user);
}
