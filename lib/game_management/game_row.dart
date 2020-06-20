import 'package:sticky_game/utils/binary.dart';

import 'stick.dart';

class GameRow {
  final int originalNumberOfSticks;
  int _currentNumberOfSticks;
  Binary _binaryNumberOfSticks;

  final List<Stick> _sticks = [];

  GameRow(this.originalNumberOfSticks) {
    _currentNumberOfSticks = this.originalNumberOfSticks;
    _binaryNumberOfSticks = Binary(this._currentNumberOfSticks);

    for (int i = 0; i < originalNumberOfSticks; i++) {
      _sticks.add(Stick());
    }
  }

  void removeStick(int number) {
    for (int i = number; i < _currentNumberOfSticks; i++) {
      _sticks[i].remove();
    }

    _currentNumberOfSticks = number;
    _binaryNumberOfSticks = Binary(_currentNumberOfSticks);
  }

  void hoverStick(int number, bool shouldBeHovered) {
    for (int i = number; i < _currentNumberOfSticks; i++) {
      _sticks[i].hover(shouldBeHovered);
    }
  }

  List<Stick> get sticks => _sticks;
  int get currentNumberOfSticks => _currentNumberOfSticks;
  Binary get binary => _binaryNumberOfSticks;
  bool get isEmpty => _currentNumberOfSticks == 0;

  @override
  String toString() {

    String finalString = "";

    _sticks.asMap().forEach((int index, Stick stick) {
      finalString += "${index == 0 ? "" : " "}$stick";
    });

    return finalString;
  }

}