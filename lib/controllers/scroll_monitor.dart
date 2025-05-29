import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollMonitor extends ChangeNotifier {
  final Map<String, ScrollController> _scrollControllers = {};
  final Map<String, double> _lastOffsets = {};
  bool _isScrollingDown = false;
  static const double scrollThreshold = 50.0;

  ScrollMonitor();

  ScrollController getScrollController(String key) {
    if (!_scrollControllers.containsKey(key)) {
      final controller = ScrollController();
      _scrollControllers[key] = controller;
      _lastOffsets[key] = 0.0;
      controller.addListener(() => _scrollListener(key));
    }
    return _scrollControllers[key]!;
  }

  // For backward compatibility
  ScrollController get scrollController => getScrollController('default');

  bool get isScrollingDown => _isScrollingDown;

  set isScrollingDown(bool value) {
    if (_isScrollingDown != value) {
      _isScrollingDown = value;
      notifyListeners();
    }
  }

  void _scrollListener(String key) {
    if (!_scrollControllers.containsKey(key) || !_scrollControllers[key]!.hasClients) {
      return;
    }

    final ScrollController controller = _scrollControllers[key]!;
    final double currentOffset = controller.offset;
    final double lastOffset = _lastOffsets[key] ?? 0.0;

    if ((currentOffset - lastOffset).abs() < scrollThreshold) {
      return; // Ignore small scroll changes
    }

    final ScrollDirection direction = controller.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && !_isScrollingDown) {
      isScrollingDown = true;
    } else if (direction == ScrollDirection.forward && _isScrollingDown) {
      isScrollingDown = false;
    }

    _lastOffsets[key] = currentOffset;
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    _scrollControllers.clear();
    _lastOffsets.clear();
    super.dispose();
  }
}
