import 'package:sticky_game/utils/binary.dart';

import 'alternate_stick.dart';

class AlternateGameRow {
  final int originalNumberOfSticks;
  int _currentNumberOfSticks;
  Binary _binaryNumberOfSticks;

  final List<AlternateStick> _sticks = [];

  AlternateGameRow(this.originalNumberOfSticks) {
    _currentNumberOfSticks = this.originalNumberOfSticks;
    _binaryNumberOfSticks = Binary(this._currentNumberOfSticks);

    for (int i = 0; i < originalNumberOfSticks; i++) {
      _sticks.add(AlternateStick());
    }
  }

  void remove(int number) {
    _sticks[number].remove();

    _currentNumberOfSticks --;
    _binaryNumberOfSticks = Binary(_currentNumberOfSticks);
  }

  void removeAllToRight(int number) {
    var orderedStickList = _orderedSticks;

    for (int i = number; i < _currentNumberOfSticks; i++) {
      orderedStickList[i].remove();
    }

    _currentNumberOfSticks = number;
    _binaryNumberOfSticks = Binary(_currentNumberOfSticks);
  }

  void hover(int number, bool shouldBeHovered) {
    _sticks[number].hover(shouldBeHovered);
  }

  void hoverAllToTheRight(int number, bool shouldBeHovered) {
    for (int i = number; i < _currentNumberOfSticks; i++) {
      _sticks[i].hover(shouldBeHovered);
    }
  }

  List<AlternateStick> get sticks => _sticks;
  List<AlternateStick> get _orderedSticks {
    final returnList = _sticks.where((stick) => !stick.isRemoved).toList()..addAll(_sticks.where((stick) => stick.isRemoved).toList());
    return returnList;
  }
  int get currentNumberOfSticks => _currentNumberOfSticks;
  Binary get binary => _binaryNumberOfSticks;
  bool get isEmpty => _currentNumberOfSticks == 0;

  @override
  String toString() {

    String finalString = "";

    _sticks.asMap().forEach((int index, AlternateStick stick) {
      finalString += "${index == 0 ? "" : " "}$stick";
    });

    return finalString;
  }

}