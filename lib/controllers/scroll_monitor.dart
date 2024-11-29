import 'package:flutter/material.dart';

class ScrollMonitor with ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  double _lastOffset = 0;
  bool _isScrollingDown = false;
  final double offsetThreshold = 50.0;

  ScrollMonitor() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentOffset = scrollController.offset;

    if ((currentOffset - _lastOffset).abs() >= offsetThreshold) {
      _isScrollingDown = currentOffset > _lastOffset;
      _lastOffset = currentOffset;
      notifyListeners();
    }
  }

  bool get isScrollingDown => _isScrollingDown;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}