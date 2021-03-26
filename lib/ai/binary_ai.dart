import 'package:flutter/foundation.dart';
import 'package:sticky_game/ai/ai.dart';
import 'package:sticky_game/ai/random_ai.dart';
import 'package:sticky_game/game_management/game_row.dart';
import 'package:sticky_game/game_management/sticky_game_manager.dart';
import 'package:sticky_game/utils/binary.dart';


/// WORKS: DON'T TOUCH!!!!!
class BinaryAI extends AI {
  BinaryAI(StickyGameManager manager) : super(manager);

  @override
  bool removeStick() {
    final List<int> totalBinary = manager.totalBinary.asList;

    int nonSingleRows = 0;
    int numberOfRows = 0;
    for (GameRow row in manager.board) {
      if (row.currentNumberOfSticks > 1) nonSingleRows += 1;
      if (!row.isEmpty) numberOfRows += 1;
    }

    if (nonSingleRows == 1) {

      int nonSingleRowNumber = manager.board.indexWhere((GameRow row) => row.currentNumberOfSticks > 1);
      manager.remove(nonSingleRowNumber, numberOfRows.isEven ? 0 : 1, "BinaryAI, nonSingleRows == 1 remove");

      return true;
    }

    final List<int> differenceList = [];
    for (var bit in totalBinary) {
      if (bit.isOdd) {
        differenceList.add(1);
      } else if (differenceList.isNotEmpty) {
        differenceList.add(0);
      }
    }

    if (differenceList.isEmpty) {

      AI ai = RandomAI(manager);
      ai.removeStick();

      return true;
    }

    final Binary difference = Binary.fromList(differenceList);

    int matching = manager.board.indexWhere((GameRow row) => listEquals<int>(row.binary.asList,difference.asList));


    if (matching != -1) {
      manager.remove(matching, 0, "BinaryAI, matching != -1 remove");
      return true;
    }


    final List<List<int>> legalRows = [];
    for (GameRow row in manager.board) {


      if (row.binary.asList.length >= difference.asList.length) {
        legalRows.add(row.binary.asList);
      }
    }

    bool played = evenOutLists(legalRows, difference.asList);

    if (played) return true;

    return false;
  }

  bool evenOutLists(List<List<int>> rowList, List<int> differenceList) {


    bool success = false;
    bool hasIncreasedDifference = false;

//    List<List<int>> longerRowList = [];
    List<int> longerDifferenceList = [0];

    rowList.forEach((List<int> row) {

      if (success) return;

      if (row.length == differenceList.length) {
        List<int> finalBinary = [];
        row.asMap().forEach((index, bit) {
          if (differenceList[index] == 1) {
            finalBinary.add(bit == 1 ? 0 : 1);
          } else {
            finalBinary.add(bit);
          }
        });

        bool leadingZero = true;
        List<int> clearedRowList = row.where((int bit) {
          if (bit == 0 && leadingZero) {
            return false;
          }

          leadingZero = false;
          return true;
        }).toList();

        int rowNumber = manager.board.indexWhere((GameRow row) => listEquals<int>(row.binary.asList, clearedRowList));
        int newNumber = Binary.fromList(finalBinary).asInt;

        bool available;
        try {
          available = newNumber <= manager.board[rowNumber].currentNumberOfSticks;
        } catch (_) {
          available = false;
        }

        if (available) {
          manager.remove(rowNumber, newNumber, "BinaryAI, available remove");

          success = true;
        }
      } else {
        if (differenceList.length < row.length && !hasIncreasedDifference) {
          longerDifferenceList.addAll(differenceList);
          hasIncreasedDifference = true;
        }
      }

    });

    if (!success) {
      success = evenOutLists(rowList, longerDifferenceList);
    }

    return success;
  }
}