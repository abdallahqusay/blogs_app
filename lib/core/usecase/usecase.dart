import 'package:blogs_app/core/error/fauiler.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<sucsessType,Params> {
  Future<Either<Fauiler,sucsessType>> call(Params params);
}

class NoParams{}