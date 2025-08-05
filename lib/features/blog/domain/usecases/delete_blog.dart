import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/repositery/blog_repo.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements Usecase<void, String> {
  final BlogRepo blogRepo;

  DeleteBlog(  this.blogRepo);
 
  @override
  Future<Either<Fauiler, void>> call(String blogId) async {
    return await blogRepo.deleteBlog(blogId);
  }
}
