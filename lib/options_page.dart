import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_game/bloc/bloc.dart';
import 'package:sticky_game/components/cupertino_pull_down_button.dart';
import 'package:sticky_game/components/option_description.dart';
import 'package:sticky_game/game_management/game_options.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          height: 80.0,
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 16.0,
                  child: IconButton(
                    highlightColor: Colors.white.withOpacity(0.05),
                    splashColor: Colors.white.withOpacity(0.15),
                    hoverColor: Colors.white.withOpacity(0.05),
                    focusColor: Colors.transparent,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Text(
                  "NIM Options",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "Roboto Slab",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildDescriptions(),
                  ),
                  SizedBox(width: 16.0,),
                  BlocBuilder<PrefsBloc, PrefsState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: _buildControlsColumn(state),
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            )
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDescriptions() {
    return <Widget>[
      OptionDescription("Opponent Type"),
      SizedBox(height: 10.0,),
      OptionDescription("Would you like to play first or second?"),
      SizedBox(height: 10.0,),
      OptionDescription("Row Count"),
      SizedBox(height: 10.0,),
      OptionDescription("Automatically remove all sicks to the right of the selected stick"),
      SizedBox(height: 10.0,),
      Container(
        height: 2.0,
        width: 50.0,
        color: Colors.white.withOpacity(0.2),
      ),
      SizedBox(height: 10.0,),
      OptionDescription("Binary Indicators"),
    ];
  }

  List<Widget> _buildControlsColumn(PrefsState state) {

    if (state is PrefsUpdatingState) {
      return _buildControls(
        state.opponentType, 
        state.playerOrder, 
        state.binaryVisibility,
        state.rowCount,
        state.autoRemove,
      );
    }

    if (state is PrefsSetState) {
      return _buildControls(
        state.opponentType, 
        state.playerOrder, 
        state.binaryVisibility,
        state.rowCount,
        state.autoRemove,
      );
    }

    return [Container()];
  }

  List<Widget> _buildControls(
      OpponentType opponentType, 
      PlayerOrder playerOrder, 
      BinaryVisibility binaryVisibility,
      RowCount rowCount,
      AutoRemove autoRemove,
  ) {

    PrefsBloc bloc = BlocProvider.of<PrefsBloc>(context);

    return <Widget>[
      CupertinoPullDownButton<String>(
        options: opponentType.options,
        currentOption: opponentType.currentOpponent,
        onChanged: (dynamic newValue) => bloc.dispatch(UpdateOpponentType(newValue)),
      ),
      SizedBox(height: 10.0,),
      CupertinoPullDownButton<String>(
        options: opponentType.isAiPlaying ? playerOrder.options : ["------"],
        currentOption: opponentType.isAiPlaying ? playerOrder.currentOrder : "------",
        onChanged: (dynamic newValue) => bloc.dispatch(UpdatePlayerOrder(newValue)),
        disabled: !opponentType.isAiPlaying,
      ),
      SizedBox(height: 10.0,),
      CupertinoPullDownButton<int>(
        options: rowCount.options,
        currentOption: rowCount.currentCount,
        onChanged: (dynamic newValue) => bloc.dispatch(UpdateRowCount(newValue)),
      ),
      SizedBox(height: 10.0,),
      CupertinoPullDownButton<String>(
        options: autoRemove.options,
        currentOption: autoRemove.currentOption,
        onChanged: (dynamic newValue) => bloc.dispatch(UpdateAutoRemove(newValue)),
      ),
      SizedBox(height: 10.0,),
      Container(
        height: 2.0,
        width: 50.0,
        color: Colors.white.withOpacity(0.2),
      ),
      SizedBox(height: 10.0,),
      CupertinoPullDownButton<String>(
        options: binaryVisibility.options,
        currentOption: binaryVisibility.currentVisibility,
        onChanged: (dynamic newValue) => bloc.dispatch(UpdateBinaryVisibility(newValue)),
      ),
    ];
  }
}
