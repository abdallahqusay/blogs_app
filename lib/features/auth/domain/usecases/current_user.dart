import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/auth/domain/entity/user.dart';
import 'package:blogs_app/features/auth/domain/repositery/auth_repo.dart';
import 'package:fpdart/fpdart.dart';


class CurrentUser implements Usecase<User ,NoParams> {
  final AuthRepo authRepo;

  CurrentUser(this.authRepo);
  @override
  Future<Either<Fauiler, User>> call(NoParams params)async {
    return await authRepo.currentUser();
    
  }

}