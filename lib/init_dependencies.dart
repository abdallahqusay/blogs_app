import 'package:blogs_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blogs_app/core/network/conec_checker.dart';
import 'package:blogs_app/core/scerets/app_secrets.dart';
import 'package:blogs_app/features/auth/data/datasourcse/auth_remote_data_source.dart';
import 'package:blogs_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:blogs_app/features/auth/domain/repositery/auth_repo.dart';
import 'package:blogs_app/features/auth/domain/usecases/current_user.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_in/bloc_bloc.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_up/auth_bloc.dart';
import 'package:blogs_app/features/auth/presentation/bloc/curntuser_bloc/bloc_bloc.dart';
import 'package:blogs_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blogs_app/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blogs_app/features/blog/data/repo/blog_repo_impl.dart';
import 'package:blogs_app/features/blog/domain/repositery/blog_repo.dart';
import 'package:blogs_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blogs_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogs_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blogs_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blogs_app/features/blog/persentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // ✅ 1) ابدأ بـ Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // ✅ افتح الصندوق وسجّله في الـ Service Locator
  final blogsBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton<Box>(() => blogsBox);

  // ✅ 2) Supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // ✅ 3) بقية الـ features
  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocator
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<ConecChecker>(
      () => ConecCheckerImpl(InternetConnection()),
    )
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(
        serviceLocator<AuthRemoteDataSource>(),
        serviceLocator<ConecChecker>(),
      ),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(() => AppUserCubit())
    ..registerFactory(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        serviceLocator<AppUserCubit>(),
      ),
    )
    ..registerFactory(
      () => SignInBloc(
        serviceLocator<UserSignIn>(),
        serviceLocator<AppUserCubit>(),
      ),
    )
    ..registerFactory(
      () => CurntUserBloc(
        serviceLocator<CurrentUser>(),
        serviceLocator<AppUserCubit>(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator<Box>()),
    )
    ..registerFactory<BlogRepo>(
      () => BlogRepoImpl(
        serviceLocator<BlogRemoteDataSource>(),
        serviceLocator<BlogLocalDataSource>(),
        serviceLocator<ConecChecker>(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogss(serviceLocator()))
    ..registerFactory(() => DeleteBlog(serviceLocator()))
    ..registerFactory(() => UpdateeBlog(serviceLocator()))
    
    ..registerLazySingleton(
      () => BlogBloc(
        updateBlog: serviceLocator<UpdateeBlog>(),
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogss>(),
        deleteBlog: serviceLocator<DeleteBlog>(),
      ),
    );
}
