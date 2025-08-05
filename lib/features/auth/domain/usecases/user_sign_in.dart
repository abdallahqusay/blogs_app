import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/auth/domain/entity/user.dart';
import 'package:blogs_app/features/auth/domain/repositery/auth_repo.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements Usecase<User, SignInParams> {
  final AuthRepo authRepo;

  UserSignIn(this.authRepo);
  @override
  Future<Either<Fauiler, User>> call(SignInParams params)async {
  
    return await authRepo.signinWithEmailPassword(
      
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams {

  final String email;
  final String password;

  SignInParams({

    required this.email,
    required this.password,
  });
}
