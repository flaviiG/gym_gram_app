import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/providers/workouts_provider.dart';
import 'package:gym_gram_app/screens/home_screen.dart';
import 'package:gym_gram_app/screens/register_screen.dart';
import 'package:gym_gram_app/services/auth_api.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:gym_gram_app/widgets/authentication_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  //
  //
  String _message = 'Welcome back, you\'ve been missed!';
  bool _isLoading = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  //
  //
  Future<void> _login(
      BuildContext context, String username, String password) async {
    AuthApi authApi = AuthApi();
    setState(() {
      _isLoading = true;
    });
    try {
      String? jwt = await authApi.login(username, password);

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
      print(err);
      setState(() {
        _message = err.toString().split(':')[1].trim();
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'FjallaOne',
                        // fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 50),

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

                    LoginButton(
                        child: _isLoading
                            ? const AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CircularProgressIndicator.adaptive())
                            : const Text(
                                'Log in',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                        onClick: () {
                          _login(context, usernameController.text,
                              passwordController.text);
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
                          'Not a member?',
                          style:
                              TextStyle(color: Colors.grey[100], fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const RegisterScreen()));
                          },
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              color: CupertinoColors.destructiveRed,
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
