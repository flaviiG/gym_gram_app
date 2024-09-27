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
    setState(() {
      _isLoading = true;
    });
    try {
      String? jwt = await login(username, password);

      if (jwt != null) {
        await storage.write(key: 'jwt', value: jwt);

        await ref.read(userProvider.notifier).fetchUser();

        ref.invalidate(workoutsProvider);
        ref.invalidate(savedWorkoutsAsyncProvider);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const SizedBox(height: 20),
                // logo
                Image.asset(
                  'assets/images/gymGram.png',
                  height: 70,
                ),

                const SizedBox(height: 80),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'FjallaOne',
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                Column(
                  children: [
                    TextInput(
                      label: 'Username',
                      placeholder: 'yourUsername',
                      controller: usernameController,
                      isPassword: false,
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      label: 'Password',
                      placeholder: '********',
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Column(
                  children: [
                    LoginButton(
                        child: _isLoading
                            ? const AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : const Text(
                                'Log in',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                        onClick: () {
                          _login(context, usernameController.text,
                              passwordController.text);
                        }),
                    const SizedBox(height: 5),
                    // Forgot password button
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
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 18,
                          ),
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
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
