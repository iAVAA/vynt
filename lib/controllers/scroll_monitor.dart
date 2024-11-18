import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollMonitor extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  bool isScrollingDown = false;
  static const double scrollThreshold = 100.0;
  double _lastOffset = 0.0;

  ScrollMonitor() {
    _scrollController.addListener(_scrollListener);
  }

  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    double currentOffset = _scrollController.offset;
    double offsetDifference = (currentOffset - _lastOffset).abs();

    if (offsetDifference > scrollThreshold) {
      ScrollDirection direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse && !isScrollingDown) {
        isScrollingDown = true;
        _lastOffset = currentOffset;
        notifyListeners();
      } else if (direction == ScrollDirection.forward && isScrollingDown) {
        isScrollingDown = false;
        _lastOffset = currentOffset;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}