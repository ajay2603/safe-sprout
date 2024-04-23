import 'package:flutter/widgets.dart';

class ChildrenListProvider extends ChangeNotifier {
  List childrenList = [];

  void setChildList(list) {
    childrenList = list;
    notifyListeners();
  }

  void addChild(id) {
    if (!childrenList.contains(id)) {
      childrenList.add(id);
    }
    notifyListeners();
  }
}
