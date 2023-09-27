import 'package:flutter/material.dart';

class PageAnimation {
  static Route createRoute(
      {required Widget page,
      required double beginOffset1,
      required double beginOffset2}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(beginOffset1, beginOffset2);
        const end = Offset.zero;

        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          key: GlobalKey(),
          child: child,
        );
      },
    );
  }
}
