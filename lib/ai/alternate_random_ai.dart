import 'package:sticky_game/ai/alternate_ai.dart';
import 'package:sticky_game/game_management/alternate_game_row.dart';
import 'package:sticky_game/game_management/alternate_sticky_game_manager.dart';

import 'dart:math';

class AlternateRandomAI extends AlternateAI {
  final Random random = Random();

  AlternateRandomAI(AlternateStickyGameManager manager) : super(manager);

  bool removeStick() {
    List<int> rows = [];
    manager.board.asMap().forEach((int index, AlternateGameRow row) {
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
      stick = random.nextInt(manager.board[row].currentNumberOfSticks - 1 );
    } catch (e) {
      stick = 0;
    }

    print("should remove row $row, stick $stick");
    manager.removeAllToTheRight(row, stick);
    return true;
  }
}