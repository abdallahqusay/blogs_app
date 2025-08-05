import 'dart:io';
import 'package:blogs_app/core/error/expecions.dart';
import 'package:blogs_app/core/error/fauiler.dart';
import 'package:blogs_app/core/network/conec_checker.dart';
import 'package:blogs_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blogs_app/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blogs_app/features/blog/data/model/blog_model.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repositery/blog_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepoImpl implements BlogRepo {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConecChecker conecChecker;
  BlogRepoImpl(this.blogRemoteDataSource, this.blogLocalDataSource, this.conecChecker);
  @override
  Future<Either<Fauiler, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  }) async {
    try {
      if(!await(conecChecker.isConnected)){
        return left(Fauiler('Ni Internet Cinnection'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerExeption catch (e) {
      return left(Fauiler(e.message));
    }
  }
  
  @override
  Future<Either<Fauiler, List<Blog>>> getAllBlogs() async{
    try {
        if(!await(conecChecker.isConnected)){
        final blogs =blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
   final blogs=await blogRemoteDataSource.getAllBlogs();
   blogLocalDataSource.uploadLocalBlogs(blogs: blogs); 
   return right(blogs);
    }on ServerExeption catch (e) {
      return left(Fauiler(e.message));
    }
  }
  
  @override
  Future<Either<Fauiler, void>> deleteBlog(String blogId) async{
    try {
      await blogRemoteDataSource.deleteBlog(blogId);
      blogLocalDataSource.deleteLocalBlog(blogId);
    return right(null);
    }on ServerExeption catch (e) {
      return left(Fauiler(e.message));
    }
    
    
  }
  
  @override
  Future<Either<Fauiler, Blog>> updateBlog({required String id, required String title, required String content,  required String posterId, }) async{
    try {
    final updatedBlog = await blogRemoteDataSource.updateBlog(
      BlogModel(
        id: id,
        posterId: posterId, // لو عندك الـ posterId هاته من مكانه
        title: title,
        content: content,
        imageUrl: '', // مش هتغير الصورة هنا غالبًا
        topics:[],
        updatedAt: DateTime.now(),
      ),
    );

    return right(updatedBlog);
  } on ServerExeption catch (e) {
    return left(Fauiler(e.message));
  }
  }
 
}
