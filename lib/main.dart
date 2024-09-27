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
      title: 'Gym Gram',
      theme: ThemeData(
        fontFamily: 'Jost',
        primaryColor: CupertinoColors.activeOrange,
        iconTheme: const IconThemeData(color: CupertinoColors.white),
        colorScheme:
            ColorScheme.fromSeed(seedColor: CupertinoColors.activeBlue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Jost',
        primaryColor: CupertinoColors.activeOrange,
        iconTheme: const IconThemeData(color: CupertinoColors.white),
        buttonTheme: const ButtonThemeData()
            .copyWith(buttonColor: CupertinoColors.white),
        colorScheme: ColorScheme.fromSeed(
            seedColor: CupertinoColors.activeBlue,
            brightness: Brightness.dark,
            primary: CupertinoColors.white),
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
            // show modal bottom info
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
            return const LoginScreen();
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
