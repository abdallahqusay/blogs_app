import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/theme/app_pallet.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_in/bloc_bloc.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_in/bloc_event.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_in/bloc_state.dart';
import 'package:blogs_app/features/auth/presentation/screens/home_screen.dart';
import 'package:blogs_app/features/auth/presentation/widgets/auth_fielc.dart';
import 'package:blogs_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SigninScreen()); // ✅ صححتها
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, BlocState>(
      listener: (context, state) {
        if (state is BlocFaiulre) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        } else if (state is BlocSucsess) {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In.",
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  AuthField(hintText: "Email", controller: emailController),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: "Password",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),

                  if (state is BlocLoading)
                    const Loader()
                  else
                    AuthGradientButton(
                      buttonText: "Sign In.",
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          context.read<SignInBloc>().add(
                                ClickedSignIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context, SigninScreen.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
