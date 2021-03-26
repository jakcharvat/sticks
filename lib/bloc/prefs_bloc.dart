import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sticky_game/game_management/game_options.dart';
import './bloc.dart';

class PrefsBloc extends Bloc<PrefsEvent, PrefsState> {
  @override
  PrefsState get initialState => InitialPrefsState();

  OpponentType _opponentType = OpponentType();
  PlayerOrder _playerOrder = PlayerOrder();
  BinaryVisibility _binaryVisibility = BinaryVisibility();
  RowCount _rowCount = RowCount();
  AutoRemove _autoRemove = AutoRemove();

  @override
  Stream<PrefsState> mapEventToState(
    PrefsEvent event,
  ) async* {

    if (event is GetPrefs) {
      yield _prefsSetState;
    }

    if (event is UpdateOpponentType) {
      yield _prefsUpdatingState;

      _opponentType.setOpponent(event.newOpponent);

      yield _prefsSetState;

    }

    if (event is UpdatePlayerOrder) {
      yield _prefsUpdatingState;

      _playerOrder.setOrder(event.newOrder);

      yield _prefsSetState;
    }

    if (event is UpdateBinaryVisibility) {
      yield _prefsUpdatingState;

      _binaryVisibility.setBinaryIndicatorVisibility(event.newVisibility);

      yield _prefsSetState;
    }
    
    if (event is UpdateRowCount) {
      yield _prefsUpdatingState;
      
      _rowCount.setRowCount(event.newCount);

      yield _prefsSetState;
    }

    if (event is UpdateAutoRemove) {
      yield _prefsUpdatingState;

      _autoRemove.setAutoRemove(event.newRemove);

      yield _prefsSetState;
    }
  }

  PrefsUpdatingState get _prefsUpdatingState => PrefsUpdatingState(
    opponentType: _opponentType,
    playerOrder: _playerOrder,
    binaryVisibility: _binaryVisibility,
    rowCount: _rowCount,
    autoRemove: _autoRemove,
  );

  PrefsSetState get _prefsSetState => PrefsSetState(
    opponentType: _opponentType,
    playerOrder: _playerOrder,
    binaryVisibility: _binaryVisibility,
    rowCount: _rowCount,
    autoRemove: _autoRemove,
  );
}
