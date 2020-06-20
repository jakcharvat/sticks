import 'package:flutter/foundation.dart';
import 'package:sticky_game/utils/binary.dart';

import 'game_row.dart';

class StickyGameManager {

  final int rows;
  // A list of the numbers of sticks in each row
  List<int> _gameRows = [];

  // A representation of the whole board
  List<GameRow> _board = [];

  // Tracks the status of the current game
  GameStatus _gameStatus = GameStatus.waitingToStart;

  // Tracks the current player
  Player _currentPlayer = Player.first;

  StickyGameManager({@required this.rows}) {
    const firstRowSticks = 1;
    const stickDifferenceBetweenRows = 2;

    for (int i = 0; i < this.rows; i++) {
      _gameRows.add(firstRowSticks + (i * stickDifferenceBetweenRows));
      _board.add(GameRow(_gameRows[i]));
    }
  }

  /// Returns the number of sticks present in the given row. Not their status, only the number of sticks at the start, where
  /// the first row has index 0.
  int sticksAtRow(int row) {
    return _gameRows[row];
  }

  void remove(int row, int stick) {
    _board[row].removeStick(stick);

    bool isEmpty = true;
    for (var row in _board) {
      if (!row.isEmpty) {
        isEmpty = false;
      }
    }

    if (isEmpty) {
      _gameStatus = GameStatus.finished;
      return;
    }

    _currentPlayer = _currentPlayer == Player.first ? Player.second : Player.first;


  }

  void hover(int row, int stick, bool shouldBeHovered) {
    _board[row].hoverStick(stick, shouldBeHovered);
  }

  List<GameRow> get board => _board;
  GameStatus get status => _gameStatus;
  Player get currentPlayer => _currentPlayer;
  Binary get totalBinary {
    Binary totalBinary = Binary(0);

    for (var row in _board) {
      totalBinary += row.binary;
    }

    return totalBinary;
  }

  @override
  String toString() {

    String finalString = "";

    _board.asMap().forEach((int index, GameRow row) {
      finalString += "${index == 0 ? "" : "\n"}$row";
    });

    return finalString;
  }

}

enum GameStatus {
  waitingToStart,
  ongoing,
  finished
}

enum Player {
  first,
  second
}
