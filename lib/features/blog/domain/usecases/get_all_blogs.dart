import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repositery/blog_repo.dart';
import 'package:fpdart/fpdart.dart';


class GetAllBlogss implements Usecase<List<Blog>,NoParams> {
  final BlogRepo blogRepo;

  GetAllBlogss(this.blogRepo);
  @override
  Future<Either<Fauiler, List<Blog>>> call( NoParams params) async{
    return await blogRepo.getAllBlogs();
    
  }
}