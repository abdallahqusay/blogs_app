import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/theme/app_pallet.dart';
import 'package:blogs_app/features/auth/presentation/bloc/bloc_sign_up/auth_bloc.dart';
import 'package:blogs_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:blogs_app/features/auth/presentation/widgets/auth_fielc.dart';
import 'package:blogs_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignupScreen());
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
  

    if (state is AuthSucsess) {
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up successful! UID: ${state.user}')),
      );
      Navigator.pushReplacement(context, SigninScreen.route());
    }

    if (state is AuthFaiulre) {
      print(" Signup Failed: ${state.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.message}')),
      );
    }
  },
  builder: (context, state) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AuthField(hintText: "Name", controller: nameController),
              SizedBox(height: 15),
              AuthField(hintText: "Email", controller: emailController),
              SizedBox(height: 15),
              AuthField(
                hintText: "Password",
                controller: passwordController,
                isObscureText: true,
              ),
              SizedBox(height: 20),

          
              if (state is AuthLoading)
                Loader()
              else
                AuthGradientButton(
                  buttonText: "Sign Up.",
                  onPressed: () {
                    print(" Button Pressed!");
                    if (formkey.currentState!.validate()) {
                      print(" Form Validated!");
                      context.read<AuthBloc>().add(
                            ClickedSignUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              name: nameController.text.trim(),
                            ),
                          );
                    }
                  },
                ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, SigninScreen.route());
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "Sign In",
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
  }}