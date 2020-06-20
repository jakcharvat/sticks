import 'package:flutter/foundation.dart';

class GameOptions {
  List<GameOption<dynamic>> _options = [
    GameOption<String>(
      "opponent",
      description: "Opponent",
      options: [
        GameOptionValue<String>("player", "A Friend 🙋‍♂️"),
        GameOptionValue<String>("ai", "Computer 🤖"),
      ],
      type: OptionType.select,
      currentValue: GameOptionValue<String>("ai", "Computer 🤖"),
    )
  ];

  List<GameOption<dynamic>> get asList => _options;
}

class GameOption<T> {
  final String description;
  final String label;
  final List<GameOptionValue<T>> options;
  final OptionType type;
  final GameOptionValue<T> currentValue;

  GameOption(this.label, {
    @required this.description,
    @required this.options,
    @required this.type,
    @required this.currentValue,
  });

  Type get typeOf => T;
}

class GameOptionValue<T> {
  final T label;
  final String value;

  GameOptionValue(this.value, this.label);
}

enum OptionType {
  toggle,
  select,
}