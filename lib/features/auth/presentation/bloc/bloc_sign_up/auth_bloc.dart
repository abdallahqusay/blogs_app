import 'dart:async';

import 'package:blogs_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blogs_app/features/auth/domain/entity/user.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
    final AppUserCubit _appUserCubit; 

  AuthBloc(this._appUserCubit, {required UserSignUp userSignUp})
    : _userSignUp = userSignUp,
      

      super(AuthInitial()) {
    on<ClickedSignUp>(clickedSignUp);
  }

  FutureOr<void> clickedSignUp(
    ClickedSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final response = await _userSignUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) {
        emit(AuthFaiulre(failure.message));
      },
      (user) {
        _appUserCubit.updateUser(user);
        emit(AuthSucsess(user));
      },
    );
  }
}
