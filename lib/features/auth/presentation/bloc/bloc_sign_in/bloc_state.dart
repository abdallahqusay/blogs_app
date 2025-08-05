import 'package:blogs_app/features/auth/domain/entity/user.dart';
import 'package:flutter/material.dart';

@immutable
sealed class BlocState {}

final class BlocInitial extends BlocState {}

final class BlocLoading extends BlocState {}

final class BlocSucsess extends BlocState {
  final User user;

  BlocSucsess(this.user);
}

final class BlocFaiulre extends BlocState {
  final String message;

  BlocFaiulre(this.message);
}
