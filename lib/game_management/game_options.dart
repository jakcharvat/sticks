class OpponentType {
  static const List<String> _options = ["🤖 Computer", "🙋‍♂️ A Friend"];
  String _currentOption = "🤖 Computer";

  void setOpponent(String newOpponent) {
    assert(_options.contains(newOpponent), "Cannot set opponent $newOpponent. Allowed values are $_options");

    _currentOption = newOpponent;
  }

  List<String> get options => _options;
  String get currentOpponent => _currentOption;
  bool get isAiPlaying => _currentOption == "🤖 Computer";
}

class PlayerOrder {
  static const List<String> _options = ["First", "Second"];
  String _currentOption = "First";

  void setOrder(String newOrder) {
    assert(_options.contains(newOrder), "Cannot set order $newOrder. Allowed values are $_options");

    _currentOption = newOrder;
  }

  List<String> get options => _options;
  String get currentOrder => _currentOption;
  bool get isAiPlayingFirst => _currentOption == "Second";
}

class BinaryVisibility {
  static const List<String> _options = ["Hide", "Show"];
  String _currentOption = "Hide";

  void setBinaryIndicatorVisibility(String newVisibility) {
    assert(_options.contains(newVisibility), "Cannot set visibility $newVisibility. Allowed values are $_options");

    _currentOption = newVisibility;
  }

  List<String> get options => _options;
  String get currentVisibility => _currentOption;
  bool get shouldShowBinary => _currentOption == "Show";
}

class RowCount {
  static List<int> _options = [for (int i = 4; i <= 25; i++) i];
  int _currentOption = 4;

  void setRowCount(int newCount) {
    assert(_options.contains(newCount), "Cannot set row count $newCount. Allowed values are $_options");

    _currentOption = newCount;
  }

  List<int> get options => _options;
  int get currentCount => _currentOption;
}

class AutoRemove {
  static const List<String> _options = ["Automatically", "Manually"];
  String _currentOption = "Automatically";

  void setAutoRemove(String newRemove) {
    assert(_options.contains(newRemove), "Cannot set auto-remove $newRemove. Allowed values are $_options");

    _currentOption = newRemove;
  }

  List<String> get options => _options;
  String get currentOption => _currentOption;
  bool get shouldAutomaticallyRemoveSticks => _currentOption == "Automatically";
}