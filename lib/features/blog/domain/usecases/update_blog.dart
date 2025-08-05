
import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repositery/blog_repo.dart';
import 'package:fpdart/fpdart.dart';


class UpdateeBlog implements Usecase <Blog, UpdateBlogParms> {
  final BlogRepo blogRepo;

  UpdateeBlog(this.blogRepo);
  @override
  Future<Either<Fauiler, Blog>> call(UpdateBlogParms params) async{
 final updateBlog=  await blogRepo.updateBlog(id: params.id, title: params.title, content: params.content, posterId: params.posterId);
  return updateBlog;
  }


}
class UpdateBlogParms {
  final String id;
  final String title;
  final String content;
  final String posterId;

 

  UpdateBlogParms({
    required this.id,
required this.posterId,
    required this.title,
    required this.content,

   
  });
}