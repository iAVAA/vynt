import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollMonitor extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  bool isScrollingDown = false;

  ScrollMonitor() {
    _scrollController.addListener(_scrollListener);
  }

  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        notifyListeners();
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}