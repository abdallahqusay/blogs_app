
import 'package:blogs_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blogs_app/core/theme/theme.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_in/bloc_bloc.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_up/auth_bloc.dart';
import 'package:blogs_app/features/auth/presentation/bloc/curntuser_bloc/bloc_bloc.dart';
import 'package:blogs_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:blogs_app/features/blog/persentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/persentation/screens/blog_screen.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<SignInBloc>()),
        BlocProvider(create: (_) => serviceLocator<CurntUserBloc>()),
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<CurntUserBloc>().add(IsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is UserIsLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if(isLoggedIn){
            return BlogScreen();
          }
          return const SigninScreen();
        },
      ),
    );
  }
}
