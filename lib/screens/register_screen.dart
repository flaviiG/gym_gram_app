import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/providers/workouts_provider.dart';
import 'package:gym_gram_app/screens/home_screen.dart';
import 'package:gym_gram_app/screens/login_screen.dart';
import 'package:gym_gram_app/services/auth_api.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:gym_gram_app/widgets/authentication_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  //
  //
  String _message = 'Create your account';
  Color? _messageColor;
  bool _isLoading = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<void> _register(String email, String username, String password,
      String passwordConfirm) async {
    setState(() {
      _isLoading = true;
    });
    if (password != passwordConfirm) {
      setState(() {
        _message = 'Passwords don\'t match';
        _messageColor = CupertinoColors.systemRed;
        _isLoading = false;
      });
      return;
    }
    try {
      AuthApi authApi = AuthApi();
      String? jwt = await authApi.register(email, username, password);

      if (jwt != null) {
        await storage.write(key: 'jwt', value: jwt);

        await ref.read(userProvider.notifier).fetchUser();

        ref.invalidate(workoutsProvider);
        ref.invalidate(savedWorkoutsProvider);
        // ref.invalidate(feedAsyncProvider);
        if (!context.mounted) {
          return;
        }

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const HomePage()));
      }
    } catch (err) {
      final messages = err.toString().split(':');
      messages.removeAt(0);
      String message = messages.join('');

      if (messages[0].contains('Duplicate fields value')) {
        final String fieldName = messages[1].split(',')[0];
        message = '$fieldName is already taken';
      }

      setState(() {
        _message = message;
        _messageColor = CupertinoColors.systemRed;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff545454), Color(0xff000000), Color(0xff250404)],
            stops: [0.1, 0.5, 0.75],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 20),
                    // logo
                    Image.asset(
                      'assets/images/gymGram.png',
                      height: 120,
                    ),

                    const SizedBox(height: 50),

                    // welcome back, you've been missed!
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'FjallaOne',
                        color: _messageColor,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 50),

                    TextInput(
                      placeholder: 'Email',
                      controller: emailController,
                      isPassword: false,
                    ),

                    const SizedBox(height: 10),

                    TextInput(
                      placeholder: 'Username',
                      controller: usernameController,
                      isPassword: false,
                    ),

                    const SizedBox(height: 10),

                    TextInput(
                      placeholder: 'Password',
                      controller: passwordController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 10),
                    TextInput(
                      placeholder: 'Confirm password',
                      controller: passwordConfirmController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 10),

                    LoginButton(
                        child: _isLoading
                            ? const AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CircularProgressIndicator.adaptive())
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                        onClick: () {
                          _register(
                              emailController.text,
                              usernameController.text,
                              passwordController.text,
                              passwordConfirmController.text);
                        }),

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ForgotPasswordPage()))
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const SizedBox(height: 50),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style:
                              TextStyle(color: Colors.grey[100], fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const LoginScreen()));
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: CupertinoColors.activeOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
