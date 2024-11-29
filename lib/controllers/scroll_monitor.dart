import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollMonitor extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;
  double _lastOffset = 0.0;
  static const double scrollThreshold = 50.0;

  ScrollMonitor() {
    _scrollController.addListener(_scrollListener);
  }

  ScrollController get scrollController => _scrollController;

  bool get isScrollingDown => _isScrollingDown;

  set isScrollingDown(bool value) {
    if (_isScrollingDown != value) {
      _isScrollingDown = value;
      notifyListeners();
    }
  }

  void _scrollListener() {
    final double currentOffset = _scrollController.offset;

    if ((currentOffset - _lastOffset).abs() < scrollThreshold) {
      return; // Ignore small scroll changes
    }

    final ScrollDirection direction = _scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && !_isScrollingDown) {
      isScrollingDown = true;
    } else if (direction == ScrollDirection.forward && _isScrollingDown) {
      isScrollingDown = false;
    }

    _lastOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
