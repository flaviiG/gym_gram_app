import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/home_screen.dart';
import 'package:gym_gram_app/screens/login_screen.dart';
import 'package:gym_gram_app/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // The root of the application

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    //
    final userAsyncValue = ref.watch(fetchUserProvider(true));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: CupertinoColors.white),
        textTheme: Typography.whiteCupertino,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: AnimatedSwitcher(
        switchInCurve: Curves.easeIn,
        duration: const Duration(
            milliseconds: 600), // Adjust animation duration as needed
        child: userAsyncValue.when(
          loading: () {
            return const SplashScreen();
          },
          error: (error, stackTrace) =>
              error.toString() == 'Exception jwt expired'
                  ? const LoginScreen()
                  : Scaffold(
                      body: Center(
                        child: Text(error.toString()),
                      ),
                    ),
          data: (user) => user == null ? const LoginScreen() : const HomePage(),
        ),
      ),
    );
  }
}
