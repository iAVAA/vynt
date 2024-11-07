import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollMonitor extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  bool isScrollingDown = false;
  static const double scrollThreshold = 75.0;
  double _lastOffset = 0.0;

  ScrollMonitor() {
    _scrollController.addListener(_scrollListener);
  }

  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    double currentOffset = _scrollController.offset;
    if ((currentOffset - _lastOffset).abs() > scrollThreshold) {
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
      _lastOffset = currentOffset;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}