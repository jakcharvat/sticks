import 'package:flutter/material.dart';
import 'package:sticky_game/ai/binary_ai.dart';
import 'package:sticky_game/ai/random_ai.dart';
import 'package:sticky_game/game_management/sticky_game_manager.dart';

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {

  static const int numberOfSimulations = 10000;

  bool shouldContinueSimulating = true;

  int simulationCount = 0;
  int simulationsSuccessful = 0;

  bool simulating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
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
                    "NIM Simulation",
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${simulating || simulationCount != 0 ? "Simulating" : "Simulate"} "
                          "$numberOfSimulations games "
                          "${simulating == false && simulationCount != 0 ? "finished" : ""}",
                      style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 20.0,),
                    Text(
                      "Games simulated: $simulationCount",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16.0
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      "Games won: $simulationsSuccessful",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16.0
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 45.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: simulating ? <Widget>[
                          SizedBox(height: 20.0,),
                          Container(
                            width: 400.0,
                            height: 5.0,
                            alignment: Alignment.center,
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Colors.white,
                                accentColor: Colors.white,
                              ),
                              child: LinearProgressIndicator(
                                value: simulationCount / numberOfSimulations,
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                        ] : <Widget> [
                          simulationsSuccessful != 0 ? Text(
                            "Accuracy: ${(simulationsSuccessful / simulationCount * 100).toStringAsFixed(2)}%",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16.0
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                    RaisedButton(
                      child: Text(simulating ? "Cancel Simulation" : simulationCount == 0 ? "Run Simulation" : "Rerun Simulation"),
                      onPressed: simulating ? () {
                        shouldContinueSimulating = false;
                      } : () {
                        simulate();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void simulate() async {
    setState(() {
      simulating = true;
      simulationsSuccessful = 0;
      simulationCount = 0;
    });

    await Future.delayed(Duration(milliseconds: 1));

    for (int i = 0; i < numberOfSimulations; i++) {
      if (!shouldContinueSimulating) break;

      setState(() {
        simulationCount ++;
      });

      await Future.delayed(Duration.zero);

      StickyGameManager manager = StickyGameManager(rows: 4);

      while (manager.status != GameStatus.finished) {
        RandomAI randomAI = RandomAI(manager);
        randomAI.removeStick();

        if (manager.status == GameStatus.finished) continue;

        BinaryAI binaryAI = BinaryAI(manager);
        binaryAI.removeStick();

//        BinaryAI binaryAI = BinaryAI(manager);
//        binaryAI.removeStick();
//
//        if (manager.status == GameStatus.finished) continue;
//
//        RandomAI randomAI = RandomAI(manager);
//        randomAI.removeStick();
      }

      Player winner = manager.currentPlayer;

      if (winner != Player.second) {
        setState(() {
          simulationsSuccessful ++;
        });
      }
    }

    setState(() {
      shouldContinueSimulating = true;
      simulating = false;
    });

  }

  @override
  void dispose() {
    shouldContinueSimulating = false;

    super.dispose();
  }
}
