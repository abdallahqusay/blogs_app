import 'package:blogs_app/core/constans/constants.dart';
import 'package:blogs_app/core/theme/app_pallet.dart';
import 'package:blogs_app/features/blog/data/model/blog_model.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/persentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/persentation/screens/blog_screen.dart';
import 'package:blogs_app/features/blog/persentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBlogScreen extends StatefulWidget {
  final Blog blog;

  const EditBlogScreen({super.key, required this.blog});

  static Route route(Blog blog) {
    return MaterialPageRoute(builder: (_) => EditBlogScreen(blog: blog));
  }

  @override
  State<EditBlogScreen> createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final formKey = GlobalKey<FormState>();
  late List<String> selectedTopics;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.blog.title);
    contentController = TextEditingController(text: widget.blog.content);
    selectedTopics = List.from(widget.blog.topics);
  }

  void updateBlog() {
    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty) {
      final updatedBlog = BlogModel(
        id: widget.blog.id,
        posterId: widget.blog.posterId,
        imageUrl: widget.blog.imageUrl,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        topics: selectedTopics,
        updatedAt: DateTime.now(),
      );

      context.read<BlogBloc>().add(
            UpdateBlog(
              blogId: updatedBlog.id,
              title: updatedBlog.title,
              content: updatedBlog.content,
              posterId: updatedBlog.posterId
            ),
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
        actions: [
          IconButton(onPressed: updateBlog, icon: const Icon(Icons.done)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFaiulre) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          } else if (state is BlogUploadSucsess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogScreen.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.blog.imageUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics.map((e) {
                          final isSelected = selectedTopics.contains(e);
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected
                                      ? selectedTopics.remove(e)
                                      : selectedTopics.add(e);
                                });
                              },
                              child: Chip(
                                label: Text(e),
                                color: isSelected
                                    ? const WidgetStatePropertyAll(
                                        AppPallete.gradient1)
                                    : null,
                                side: isSelected
                                    ? null
                                    : BorderSide(
                                        color: AppPallete.borderColor),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
