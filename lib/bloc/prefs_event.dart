import 'package:equatable/equatable.dart';

abstract class PrefsEvent extends Equatable {
  const PrefsEvent();
}

class GetPrefs extends PrefsEvent {
  @override
  List<Object> get props => [];

}

class UpdateOpponentType extends PrefsEvent {
  final String newOpponent;

  UpdateOpponentType(this.newOpponent);


  @override
  List<Object> get props => [newOpponent];
}

class UpdatePlayerOrder extends PrefsEvent {
  final String newOrder;

  UpdatePlayerOrder(this.newOrder);

  @override
  List<Object> get props => [newOrder];
}

class UpdateBinaryVisibility extends PrefsEvent {
  final String newVisibility;

  UpdateBinaryVisibility(this.newVisibility);

  @override
  List<Object> get props => [newVisibility];
}

class UpdateRowCount extends PrefsEvent {
  final int newCount;

  UpdateRowCount(this.newCount);

  @override
  List<Object> get props => [newCount];
}

class UpdateAutoRemove extends PrefsEvent {
  final String newRemove;

  UpdateAutoRemove(this.newRemove);

  @override
  List<Object> get props => [newRemove];
}