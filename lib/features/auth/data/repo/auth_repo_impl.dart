import 'package:blogs_app/core/error/expecions.dart';
import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/network/conec_checker.dart';
import 'package:blogs_app/features/auth/data/datasourcse/auth_remote_data_source.dart';
import 'package:blogs_app/features/auth/data/models/user_model.dart';

import 'package:blogs_app/features/auth/domain/entity/user.dart';

import 'package:fpdart/fpdart.dart';

import '../../domain/repositery/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConecChecker conecChecker;

  AuthRepoImpl(this.authRemoteDataSource, this.conecChecker);
  @override
  Future<Either<Fauiler, User>> signinWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if(!await(conecChecker.isConnected)){
        return left(Fauiler('No internet Connection'));
      }
      final user = await authRemoteDataSource.signinWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerExeption catch (e) {
      return left(Fauiler(e.message));
    }
  }

  @override
  Future<Either<Fauiler, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if(!await(conecChecker.isConnected)){
        return left(Fauiler('No internet Connection'));
      }
      final user = await authRemoteDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerExeption catch (e) {
      return left(Fauiler(e.message));
    }
  }

  @override
Future<Either<Fauiler, User>> currentUser() async {
  if (!await conecChecker.isConnected) {
    return left(Fauiler("No internet connection."));
  }

  final session = authRemoteDataSource.currentUserSession;
  if (session == null) {
    return left(Fauiler("No user session found."));
  }
  return right(UserModel(
    id: session.user.id,
    email: session.user.email ?? '',
    name: '',
  ));
}

}
