import 'package:blogs_app/core/theme/app_pallet.dart';
import 'package:blogs_app/core/utils/calc_reading_time.dart';
import 'package:blogs_app/core/utils/format_date.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:flutter/material.dart';

class BlogScrollViewerScreen extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
    builder: (context) => BlogScrollViewerScreen(blog: blog),
  );
  final Blog blog;
  const BlogScrollViewerScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)}.${calcReadingTime(blog.content)} min',
                  style: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                SizedBox(height: 20),
                Text(blog.content,style: TextStyle(fontSize: 16,height: 2),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
