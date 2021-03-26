import './ai.dart';

import '../game_management/game_row.dart';
import '../game_management/sticky_game_manager.dart';
import 'dart:math';

class RandomAI extends AI {
  final StickyGameManager manager;

  final Random random = Random();

  RandomAI(this.manager) : super(manager);

  bool removeStick() {
    List<int> rows = [];
    manager.board.asMap().forEach((int index, GameRow row) {
      if (!row.isEmpty) {
        print("Row: $index: ${row.currentNumberOfSticks} sticks, isEmpty: ${row.isEmpty}");
        rows.add(index);
      }
    });

    print(rows);
    int row = (rows..shuffle()).first;
    print(rows);
    print(row);

    print(manager);
    int stick;
    try {
      stick = random.nextInt(manager.board[row].currentNumberOfSticks - 1);
    } catch (e) {
      stick = 0;
    }

    print("should remove row $row, stick $stick");
    manager.remove(row, stick, "RandomAI remove");
    return true;
  }
}