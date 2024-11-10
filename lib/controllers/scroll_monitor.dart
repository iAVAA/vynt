import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vynt/constants.dart' as constants;

class ScrollMonitor extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  double navBarOffset = 0.0;
  double _lastOffset = 0.0;

  ScrollMonitor() {
    _scrollController.addListener(_scrollListener);
  }

  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    double currentOffset = _scrollController.offset;
    double deltaOffset = currentOffset - _lastOffset;
    _lastOffset = currentOffset;

    navBarOffset -= deltaOffset;
    navBarOffset = navBarOffset.clamp(-constants.minNavBarHeight, 0.0);
    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      snapNavBar();
    }
    notifyListeners();
  }

  void updateNavBarOffset(double delta) {
    navBarOffset += delta;
    navBarOffset = navBarOffset.clamp(-constants.minNavBarHeight, 0.0);
    notifyListeners();
  }

  void snapNavBar() {
    double snapThreshold = -constants.minNavBarHeight / 4;
    if (navBarOffset > snapThreshold) {
      navBarOffset = 0.0;
    } else {
      navBarOffset = -constants.minNavBarHeight;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}