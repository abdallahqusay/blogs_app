import 'package:blogs_app/core/theme/app_pallet.dart';
import 'package:blogs_app/features/blog/persentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/persentation/screens/add_new_blogScreen.dart';
import 'package:blogs_app/features/blog/persentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogScreen());
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(GetAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Blog App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogscreen.route());
            },
            icon: Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFaiulre) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            
            return Center(child: CircularProgressIndicator());
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallete.gradient1
                      : index % 3 == 1
                      ? AppPallete.gradient2
                      : Colors.blue,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
