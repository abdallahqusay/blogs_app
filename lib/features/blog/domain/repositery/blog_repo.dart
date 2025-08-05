import 'dart:io';
import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepo {
  Future<Either<Fauiler, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  });
  Future<Either<Fauiler, List<Blog>>> getAllBlogs();

  Future<Either<Fauiler, void>> deleteBlog(String blogId);
  Future<Either<Fauiler, Blog>> updateBlog({
    required String id,
    required String title,
    required String content,
    required String posterId
    
  });
}
