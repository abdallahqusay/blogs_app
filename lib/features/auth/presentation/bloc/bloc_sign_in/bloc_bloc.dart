import 'dart:async';

import 'package:blogs_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';

class SignInBloc extends Bloc<BlocEvent, BlocState> {
  final UserSignIn _userSignIn;
  final AppUserCubit _appUserCubit;  
  SignInBloc(this._userSignIn, this._appUserCubit) : super(BlocInitial()) {
    on<ClickedSignIn>(clickedSignIn);
  }

  FutureOr<void> clickedSignIn(
    ClickedSignIn event,
    Emitter<BlocState> emit,
  ) async {
    emit(BlocLoading());
    final result = await _userSignIn.call(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(BlocFaiulre(failure.message)),
      (user) {
        _appUserCubit.updateUser(user);
         emit(BlocSucsess(user));
      }
    );
  }
  
}
