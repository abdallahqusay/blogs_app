import 'package:blogs_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource{
    Future <void> uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
    Future <void> deleteLocalBlog(String blogId);
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    for (int i = 0; i < box.length; i++) {
      blogs.add(BlogModel.fromJson(box.get(i.toString())));
    }
    return blogs;
  }

  @override
  Future <void> uploadLocalBlogs({required List<BlogModel> blogs}) async {
    await box.clear();

    final map = <String, Map<String, dynamic>>{};
    for (int i = 0; i < blogs.length; i++) {
      map[i.toString()] = blogs[i].toJson();
    }

    await box.putAll(map);
  }
  
  @override
  Future <void> deleteLocalBlog(String blogId)async {
    List<BlogModel>blogs =loadBlogs();
    blogs.removeWhere((blog)=>blog.id==blogId);
    await uploadLocalBlogs(blogs: blogs);
  }
}
