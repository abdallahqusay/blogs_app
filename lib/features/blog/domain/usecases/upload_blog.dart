import 'dart:io';
import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repositery/blog_repo.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParms> {
  final BlogRepo blogRepo;

  UploadBlog(this.blogRepo);
  @override
  Future<Either<Fauiler, Blog>> call(UploadBlogParms params) async {
    final blogData = await blogRepo.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
      posterId: params.posterId,
    );
    return blogData;
  }
}

class UploadBlogParms {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParms({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
