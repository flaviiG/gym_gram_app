import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/home_screen.dart';
import 'package:gym_gram_app/screens/login_screen.dart';
import 'package:gym_gram_app/screens/splash_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // The root of the application

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    //
    final userAsync = ref.watch(fetchUserProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: CupertinoColors.activeBlue,
        iconTheme: const IconThemeData(color: CupertinoColors.white),
        textTheme: Typography.whiteCupertino,
        colorScheme:
            ColorScheme.fromSeed(seedColor: CupertinoColors.activeBlue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: CupertinoColors.activeBlue,
        iconTheme: const IconThemeData(color: CupertinoColors.white),
        textTheme: Typography.whiteCupertino,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CupertinoColors.activeBlue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: AnimatedSwitcher(
        switchInCurve: Curves.easeIn,
        duration: const Duration(
            milliseconds: 600), // Adjust animation duration as needed
        child: userAsync.when(
          loading: () {
            return const SplashScreen();
          },
          error: (error, stackTrace) {
            FlutterNativeSplash.remove();
            return error.toString() == 'Exception jwt expired'
                ? const LoginScreen()
                : Scaffold(
                    body: Center(
                      child: Text(error.toString()),
                    ),
                  );
          },
          data: (user) {
            FlutterNativeSplash.remove();
            return user == null ? const LoginScreen() : const HomePage();
          },
        ),
      ),
    );
  }
}
