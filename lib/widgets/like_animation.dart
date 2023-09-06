import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimation;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimation({
    required this.child,
    required this.isAnimation,
    this.duration = const Duration(
      milliseconds: 150,
    ),
    this.onEnd,
    this.smallLike = false,
    super.key,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/ 2,
      ),
    );

    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    if (widget.isAnimation != oldWidget.isAnimation) {
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }

  startAnimation() async {
    if (widget.isAnimation || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(
          milliseconds: 200,
        ),
      );

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }
}
