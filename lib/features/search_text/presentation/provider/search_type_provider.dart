import 'package:flutter/material.dart';

class SearchTypeProvider extends ChangeNotifier {
  int _checkIndex = 1;
  bool? _isTextImage;

  int get checkIndex => _checkIndex;
  bool? get isTextImage => _isTextImage;

  searchType(int? checkIndex, bool? isTextImage) {
    checkIndex = _checkIndex;
    isTextImage = _isTextImage;

    notifyListeners();
  }

  increase() {
    _checkIndex = checkIndex + 1;
    notifyListeners();
  }

  reset() {
    _checkIndex = 1;
  }
}
