import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/features/auth/domain/entity/user.dart';
import 'package:fpdart/fpdart.dart';


abstract interface class AuthRepo {
  Future<Either<Fauiler, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Fauiler, User>> signinWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Fauiler, User>> currentUser();
}
