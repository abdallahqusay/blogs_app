


import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/auth/domain/entity/user.dart';

import 'package:fpdart/fpdart.dart';

import '../repositery/auth_repo.dart';

class UserSignUp implements Usecase<User, SignUpParams> {
  final AuthRepo authRepo;

  UserSignUp(this.authRepo);
  @override
  Future<Either<Fauiler, User>> call(SignUpParams params)async {
  
    return await authRepo.signupWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
