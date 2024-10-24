import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollMonitor extends ChangeNotifier {
  bool _isNavBarVisible = true;
  final ScrollController _scrollController = ScrollController();

  ScrollMonitor() {
    _scrollController.addListener(_scrollListener);
  }

  bool get isNavBarVisible => _isNavBarVisible;
  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isNavBarVisible) {
        _isNavBarVisible = false;
        notifyListeners();
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isNavBarVisible) {
        _isNavBarVisible = true;
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