import 'package:blogs_app/core/utils/calc_reading_time.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/persentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/persentation/screens/blog_scroll_viewer_screen.dart';
import 'package:blogs_app/features/blog/persentation/screens/edit_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;

  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogScrollViewerScreen.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(30).copyWith(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 50),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${calcReadingTime(blog.content)} min'),
                  IconButton(
                    onPressed: () {
                      context.read<BlogBloc>().add(DeleteBlogEvent(blog.id));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, EditBlogScreen.route(blog));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
