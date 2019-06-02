import "package:flutter/widgets.dart";

class HomeProvider extends InheritedWidget {

  HomeProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

}
