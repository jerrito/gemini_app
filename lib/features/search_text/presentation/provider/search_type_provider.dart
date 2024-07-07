import 'package:flutter/material.dart';

class SearchTypeProvider extends ChangeNotifier {
  int? _type;
  bool? _isTextImage;

  int? get type => _type;
  bool? get isTextImage => _isTextImage;

  searchType(int? type, bool? isTextImage) {
    type = _type;
    isTextImage = _isTextImage;

    notifyListeners();
  }
}
