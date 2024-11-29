import 'package:flutter/material.dart';

class IconAnimationController {
  final TickerProvider vsync;

  IconAnimationController({required this.vsync});

  late AnimationController likeController;
  late AnimationController bookmarkController;
  late AnimationController rotationController;
  late Animation<double> likeAnimation;
  late Animation<double> bookmarkAnimation;
  late Animation<double> rotationAnimation;

  void initLikeAnimation() {
    likeController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
    );

    likeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(likeController);
  }

  void initBookmarkAnimation() {
    bookmarkController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
    );

    bookmarkAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(bookmarkController);
  }

  void initRotationAnimation() {
    rotationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 5),
    )..repeat();

    rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(rotationController);
  }

  void dispose() {
    likeController.dispose();
    bookmarkController.dispose();
    rotationController.dispose();
  }

  void playLikeAnimation() {
    likeController.forward(from: 0.0);
  }

  void playBookmarkAnimation() {
    bookmarkController.forward(from: 0.0);
  }
}