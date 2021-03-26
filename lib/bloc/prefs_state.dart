import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sticky_game/game_management/game_options.dart';

abstract class PrefsState extends Equatable {
  const PrefsState();
}

class InitialPrefsState extends PrefsState {
  @override
  List<Object> get props => [];
}

class PrefsUpdatingState extends PrefsState {

  final OpponentType opponentType;
  final PlayerOrder playerOrder;
  final BinaryVisibility binaryVisibility;
  final RowCount rowCount;
  final AutoRemove autoRemove;

  PrefsUpdatingState({
    @required this.opponentType,
    @required this.playerOrder,
    @required this.binaryVisibility,
    @required this.rowCount,
    @required this.autoRemove,
  });

  @override
  List<Object> get props => [opponentType, playerOrder, binaryVisibility, rowCount];

}

class PrefsSetState extends PrefsState {
  final OpponentType opponentType;
  final PlayerOrder playerOrder;
  final BinaryVisibility binaryVisibility;
  final RowCount rowCount;
  final AutoRemove autoRemove;

  PrefsSetState({
    @required this.opponentType,
    @required this.playerOrder,
    @required this.binaryVisibility,
    @required this.rowCount,
    @required this.autoRemove,
  });

  @override
  List<Object> get props => [opponentType, playerOrder, binaryVisibility, rowCount];
}