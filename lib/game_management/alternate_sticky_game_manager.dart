import 'package:flutter/foundation.dart';
import 'package:sticky_game/game_management/alternate_game_row.dart';
import 'package:sticky_game/utils/binary.dart';

class AlternateStickyGameManager {

  final int rows;
  // A list of the numbers of sticks in each row
  List<int> _gameRows = [];

  // A representation of the whole board
  List<AlternateGameRow> _board = [];

  // Tracks the status of the current game
  AlternateGameStatus _gameStatus = AlternateGameStatus.waitingToStart;

  // Tracks the current player
  AlternatePlayer _currentPlayer = AlternatePlayer.first;

  int _rowBlock;

  AlternateStickyGameManager({@required this.rows}) {
    const firstRowSticks = 1;
    const stickDifferenceBetweenRows = 2;

    for (int i = 0; i < this.rows; i++) {
      _gameRows.add(firstRowSticks + (i * stickDifferenceBetweenRows));
      _board.add(AlternateGameRow(_gameRows[i]));
    }
  }

  /// Returns the number of sticks present in the given row. Not their status, only the number of sticks at the start, where
  /// the first row has index 0.
  int sticksAtRow(int row) {
    return _gameRows[row];
  }

  void remove(int row, int stick) {
    if (_rowBlock == row || _rowBlock == null) {
      _board[row].remove(stick);
      _rowBlock = row;
    }

    _checkIfGameFinished();
  }

  void removeAllToTheRight(int row, int stick) {
    print("REMOVING ROW $row, STICK $stick");
    print(this.board[row].sticks);
    print(this.board[row].sticks[stick]);
    print(this);

    _board[row].removeAllToRight(stick);

    _checkIfGameFinished();
  }

  void _checkIfGameFinished() {
    bool isEmpty = true;
    for (var row in _board) {
      if (!row.isEmpty) {
        isEmpty = false;
      }
    }

    if (isEmpty) {
      _gameStatus = AlternateGameStatus.finished;
    }
  }

  void handoffPlayer() {
    _rowBlock = null;
    _currentPlayer = _currentPlayer == AlternatePlayer.first ? AlternatePlayer.second : AlternatePlayer.first;
  }

  void hover(int row, int stick, bool shouldBeHovered) {
    _board[row].hover(stick, shouldBeHovered);
  }

  void hoverAllToTheRight(int row, int stick, bool shouldBeHovered) {
    _board[row].hoverAllToTheRight(stick, shouldBeHovered);
  }

  List<AlternateGameRow> get board => _board;
  AlternateGameStatus get status => _gameStatus;
  AlternatePlayer get currentPlayer => _currentPlayer;
  Binary get totalBinary {
    Binary totalBinary = Binary(0);

    for (var row in _board) {
      totalBinary += row.binary;
    }

    return totalBinary;
  }

  @override
  String toString() {

    String finalString = "\n";

    _board.asMap().forEach((int index, AlternateGameRow row) {
      finalString += "${index == 0 ? "" : "\n"}$row";
    });

    return finalString;
  }

}

enum AlternateGameStatus {
  waitingToStart,
  ongoing,
  finished
}

enum AlternatePlayer {
  first,
  second
}
