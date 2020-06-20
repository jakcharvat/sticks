import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sticky_game/ai/ai.dart';
import 'package:sticky_game/ai/binary_ai.dart';
import 'package:sticky_game/game_management/sticky_game_manager.dart';
import 'package:sticky_game/main.dart';

class StickyGameBoard extends StatefulWidget {
  @override
  _StickyGameBoardState createState() => _StickyGameBoardState();
}

class _StickyGameBoardState extends State<StickyGameBoard> {

  static const int _numberOfRows = 4;
  static const double _stickHeight = 100.0;
  static const double _stickWidth = 40.0;

  static const bool _isAIPlaying = true;
  static const Player _aiPlayer = Player.second;

  StickyGameManager _manager = StickyGameManager(rows: _numberOfRows);
  AI _ai;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              "${_manager.currentPlayer == Player.first ? "First" : "Second"} Player's Turn",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Roboto Slab",
                fontSize: 30.0
              ),
            ),
          ),
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
              SizedBox(width: _stickWidth,),
              Column (
                children: _buildBinaryIndicators(),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
              )
            ],
          ),
        ],
      ),
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

  void _onStickHover(int row, int stick, bool isHovered) {
    setState(() {
      _manager.hover(row, stick, isHovered);
    });
  }

  void _onStickPress(int row, int stick) {
    setState(() {
      _manager.remove(row, stick);

      if (_manager.status == GameStatus.finished) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => StickyGameResults(
            winner: _manager.currentPlayer == Player.first ? Player.second : Player.first,
            isAiPlaying: _isAIPlaying,
            aiPlayer: _isAIPlaying ? _aiPlayer : null,
          )
        ));
      }

      if (_isAIPlaying && _manager.status != GameStatus.finished) {
        _ai = BinaryAI(_manager);

        _ai.removeStick();
      }
    });
  }
}