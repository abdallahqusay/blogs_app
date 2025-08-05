import 'dart:async';

import 'package:blogs_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/auth/domain/entity/user.dart';
import 'package:blogs_app/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class CurntUserBloc extends Bloc<BlocEvent, BlocState> {
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;  
  CurntUserBloc(this._currentUser, this._appUserCubit) : super(BlocInitial()) {
    on<IsUserLoggedIn>(isUserLoggedIn);
  }

  FutureOr<void> isUserLoggedIn(
    IsUserLoggedIn event,
    Emitter<BlocState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold((l) => emit(BlocFaiulre(l.message)), (user) {
      print(user.id);
      _appUserCubit.updateUser(user);
      emit(BlocSucsess(user));
    });
  }
}
