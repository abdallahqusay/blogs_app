import 'dart:async';
import 'dart:io';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blogs_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogs_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blogs_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogss _getAllBlogs;
  final DeleteBlog _deleteBlog;
  final UpdateeBlog _updateBlog;

  BlogBloc({
    required UpdateeBlog updateBlog,
    required DeleteBlog deleteBlog,
    required UploadBlog uploadBlog,
    required GetAllBlogss getAllBlogs,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       _deleteBlog = deleteBlog,
       _updateBlog =updateBlog,
       super(BlogInitial()) {
    on<BlogUpload>(_blogUpload);
    on<GetAllBlogs>(gettAllBlogs);
    on<DeleteBlogEvent>(deleteBlogEvent);
    on<UpdateBlog>(updateeBlog);
  }

  FutureOr<void> _blogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading());

    final res = await _uploadBlog(
      UploadBlogParms(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    res.fold(
      (l) => emit(BlogFaiulre(l.message)),
      (r) => emit(BlogUploadSucsess()),
    );
  }

  FutureOr<void> gettAllBlogs(
    GetAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFaiulre(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }

FutureOr<void> deleteBlogEvent(
  DeleteBlogEvent event,
  Emitter<BlogState> emit,
) async {
  emit(BlogLoading());
  final res = await _deleteBlog(event.blogId);

  if (res.isLeft()) {
    emit(BlogFaiulre(res.fold((l) => l.message, (_) => '')));
    return;
  }

  final allBlogs = await _getAllBlogs(NoParams());
  allBlogs.fold(
    (l) => emit(BlogFaiulre(l.message)),
    (blogs) => emit(BlogDisplaySuccess(blogs)),
  );
}

  FutureOr<void> updateeBlog(UpdateBlog event, Emitter<BlogState> emit)async {
    emit(BlogLoading());
    final res = await _updateBlog(UpdateBlogParms(id: event.blogId, title: event.title, content: event.content,posterId: event.posterId));
     res.fold(
      (l) => emit(BlogFaiulre(l.message)),
      (r) => emit(BlogUpdateSuccess(r)),
    );
  }
}
