import 'package:flutter/material.dart';

class TransparentRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  TransparentRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          opaque: false,
          transitionDuration: const Duration(milliseconds: 50),
          reverseTransitionDuration: const Duration(milliseconds: 50),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
