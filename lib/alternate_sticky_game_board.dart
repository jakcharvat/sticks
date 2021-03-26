import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_game/ai/alternate_ai.dart';
import 'package:sticky_game/ai/alternate_binary_ai.dart';
import 'package:sticky_game/bloc/bloc.dart';
import 'package:sticky_game/game_management/alternate_sticky_game_manager.dart';
import 'package:sticky_game/main.dart';

import 'game_management/sticky_game_manager.dart';

class AlternateStickyGameBoard extends StatefulWidget {
  @override
  _AlternateStickyGameBoardState createState() => _AlternateStickyGameBoardState();
}

class _AlternateStickyGameBoardState extends State<AlternateStickyGameBoard> {

  static const double _stickHeight = 100.0;
  static const double _stickWidth = 40.0;

  AlternatePlayer _aiPlayer = AlternatePlayer.second;

  AlternateStickyGameManager _manager;
  AlternateAI _ai;

  bool _isAiPlaying = true;
  bool _hasFirstMoveHappened = false;

  bool _waiting = false;
  bool _showBinary = false;
  int _numberOfRows;

  Widget get _currentPlayerWidget {

    if (_isAiPlaying) {
      if (_manager.currentPlayer == _aiPlayer) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.white,
              accentColor: Colors.white
          ),
          child: AspectRatio(
              aspectRatio: 1.0,
              child: CircularProgressIndicator()),
        )
        ;
      } else {
        return Text(
          "Your Turn",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto Slab",
              fontSize: 30.0
          ),
        );
      }
    }

    return Text(
      "${_manager.currentPlayer == AlternatePlayer.first ? "First" : "Second"} Player's Turn",
      style: TextStyle(
          color: Colors.white,
          fontFamily: "Roboto Slab",
          fontSize: 30.0
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrefsBloc, PrefsState>(
      builder: (BuildContext context, PrefsState state) {
        if (state is PrefsSetState) {
          _numberOfRows = state.rowCount.currentCount;
          _manager = _manager ?? AlternateStickyGameManager(rows: _numberOfRows);

          _isAiPlaying = state.opponentType.isAiPlaying;
          _showBinary = state.binaryVisibility.shouldShowBinary;

          if (!_hasFirstMoveHappened && _isAiPlaying && state.playerOrder.isAiPlayingFirst) {
            _waiting = true;

            _playAiFirstMove();
          }

          if (state.playerOrder.isAiPlayingFirst) {
            _aiPlayer = AlternatePlayer.first;
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FittedBox(
              child: Opacity(
                opacity: _waiting ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: _waiting,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          height: 40.0,
                          child: _currentPlayerWidget
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: _buildRows(),
                              ),
                            ),
                          ),
                          SizedBox(width: _showBinary ? _stickWidth : 0.0,),
                          _showBinary ? Column (
                            children: _buildBinaryIndicators(),
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ) : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              colorBrightness: Brightness.light,
              child: Text("Move Finished"),
              onPressed: _onTurnHandoff,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildBinaryIndicators() {
    final List<Widget> indicators = [];

    for (int i = 0; i < _numberOfRows; i++) {
      indicators.add(Container(
        height: _stickHeight,
        child: Center(
          child: Text(
            _manager.board[i].binary.toString(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto Mono",
              fontSize: 20.0,
            ),
          ),
        ),
      ));
    }

    indicators.add(SizedBox(
      height: 20.0,
    ));

    indicators.add(Container(
      height: _stickHeight,
      child: Center(
        child: Text(
          _manager.totalBinary.toString(),
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto Mono",
            fontSize: 20.0,
          ),
        ),
      ),
    ));

    return indicators;
  }

  List<Widget> _buildRows() {
    final List<Widget> rows = [];

    for (int i = 0; i < _manager.rows; i ++) {
      rows.add(Container(
        height: _stickHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildSticksInRow(i),
        ),
      ));
    }

    return rows;
  }

  List<Widget> _buildSticksInRow(int row) {
    final List<Widget> sticks = [];

    for (int i = 0; i < _manager.sticksAtRow(row); i ++) {
      sticks.add(Container(
        width: _stickWidth,
        child: _manager.board[row].sticks[i].isRemoved
            ? Container()
            : Center(
          child: Material(
            borderRadius: BorderRadius.circular(6.0),
            color: _manager.board[row].sticks[i].isHovered ? Colors.grey.shade500 : Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.transparent,
              onTap: () {
                _onStickPress(row, i);
              },
              onHover: (bool isHovered) {
                _onStickHover(row, i, isHovered);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                      style: BorderStyle.solid,
                    )
                ),
              ),
            ),
          ),
        ),
      ));
    }

    return sticks;
  }

  void _playAiFirstMove() async {
    await Future.delayed(Duration(milliseconds: 500));

    _ai = AlternateBinaryAI(_manager);
    _ai.removeStick();
    _hasFirstMoveHappened = true;

    setState(() {});

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _waiting = false;
    });
  }

  void _onStickHover(int row, int stick, bool isHovered) {
    setState(() {
      _manager.hover(row, stick, isHovered);
    });
  }

  void _onStickPress(int row, int stick) async {
    setState(() {
      _hasFirstMoveHappened = true;
      _manager.remove(row, stick);

      if (_manager.status == AlternateGameStatus.finished) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => StickyGameResults(
              winner: _manager.currentPlayer == AlternatePlayer.first ? Player.second : Player.first,
              isAiPlaying: _isAiPlaying,
              aiPlayer: _isAiPlaying ? _aiPlayer == AlternatePlayer.first ? Player.first : Player.second : null,
            )
        ));
      }
    });
  }

  void _onTurnHandoff() async {
    setState(() {
      _manager.handoffPlayer();
    });

    if (_isAiPlaying) _waiting = true;

    if (_isAiPlaying) {
      await Future.delayed(Duration(milliseconds: 500));

      if (!mounted) return;
      setState(() {
        if (_isAiPlaying && _manager.status != AlternateGameStatus.finished) {
          _ai = AlternateBinaryAI(_manager);
          _ai.removeStick();
          _waiting = false;
        }
      });
    }

    if (_manager.status == AlternateGameStatus.finished) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => StickyGameResults(
            winner: _manager.currentPlayer == AlternatePlayer.first ? Player.second : Player.first,
            isAiPlaying: _isAiPlaying,
            aiPlayer: _isAiPlaying ? _aiPlayer == AlternatePlayer.first ? Player.first : Player.second : null,
          )
      ));
    } else {
      setState(() {
        _manager.handoffPlayer();
      });
    }
  }
}