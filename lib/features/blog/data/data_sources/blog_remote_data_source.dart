import 'dart:io';

import 'package:blogs_app/core/error/expecions.dart';
import 'package:blogs_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<void> deleteBlog(String blogId);

  Future<List<BlogModel>> getAllBlogs();

  Future<BlogModel> updateBlog(BlogModel blog);
}

class BlogRemoteDataSourceImpl extends BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*,profiles(name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } catch (e) {
      ServerExeption(e.toString());
    }
  }

  @override
  Future<BlogModel> updateBlog(BlogModel blog) async {
    try {
      final updateBlog = await supabaseClient
          .from('blogs')
          .update(blog.toJson())
          .eq('id', blog.id);
      return BlogModel.fromJson(updateBlog.first);
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }
}
