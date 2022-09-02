import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String?> squares = [];
  int stepNumber = 0;
  bool xIsNext = true;
  List<GameState> history = [GameState()];

  @override
  Widget build(BuildContext context) {
    GameState current = history[stepNumber];
    String? winner = calculateWinner(current.squares);
    String status = "";
    if (winner != "") {
      status = "Winner: $winner";
    } else {
      status = "Next player: ${xIsNext ? "X" : "O"}";
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoardWidget(current.squares, handleClick),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(status),
                ...history.map((step) {
                  int move = history.indexOf(step);
                  String desc = move != 0 ? 'Go to move #$move' : 'Go to game start';
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (move > 0) Text(move.toString()),
                        ElevatedButton(
                          child: Text(desc),
                          onPressed: () {
                            jumpTo(move);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList()
              ],
            )
          ],
        ),
      ),
    );
  }

  void handleClick(int i) {
    var historySlice = history.sublist(0, stepNumber + 1);
    var current = historySlice.last;
    var squares = current.squares.sublist(0);
    if (calculateWinner(squares) != "" || squares.length < i) {
      return;
    }
    squares[i] = xIsNext ? "X" : "O";
    setState(() {
      history = [...historySlice, GameState(squares: squares)];
      stepNumber = historySlice.length;
      xIsNext = !xIsNext;
    });
  }

  void jumpTo(int step) {
    setState(() {
      stepNumber = step;
      xIsNext = step % 2 == 0;
    });
  }

  String calculateWinner(squares) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];
    for (int i = 0; i < lines.length; i++) {
      //const a, b, c = lines[i];
      int a = lines[i][0];
      int b = lines[i][1];
      int c = lines[i][2];
      if (squares[a] != "" && squares[a] == squares[b] && squares[a] == squares[c]) {
        return squares[a];
      }
    }
    return "";
  }
}

class GameState {
  List<String> squares;

  GameState({this.squares = const ["", "", "", "", "", "", "", "", ""]});
}

class BoardWidget extends StatelessWidget {
  final List<String> squares;
  final Function(int i) squareClick;

  const BoardWidget(this.squares, this.squareClick, {Key? key}) : super(key: key);

  SquareWidget renderSquare(i) {
    return SquareWidget(squares[i], () => squareClick(i));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [renderSquare(0), renderSquare(1), renderSquare(2)],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [renderSquare(3), renderSquare(4), renderSquare(5)],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [renderSquare(6), renderSquare(7), renderSquare(8)],
        )
      ],
    );
  }
}

class SquareWidget extends StatelessWidget {
  final String value;
  final Function() onClick;

  const SquareWidget(this.value, this.onClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: SquareStyleWidget(
        child: Text(value),
      ),
    );
  }
}

class SquareStyleWidget extends StatelessWidget {
  final Widget child;

  const SquareStyleWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(width: 0),
      ),
      child: Center(child: child),
    );
  }
}
