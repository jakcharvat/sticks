import 'package:sticky_game/game_management/alternate_sticky_game_manager.dart';

abstract class AlternateAI {
  final AlternateStickyGameManager manager;

  AlternateAI(this.manager);

  bool removeStick();
}