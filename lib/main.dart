import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snake_game/model/food.dart';
import 'package:snake_game/model/snake.dart';
import 'package:snake_game/model/snake_direction.dart';
import 'package:snake_game/model/snake_move_result.dart';
import 'package:snake_game/model/snake_point.dart';
import 'package:snake_game/ui/gamepad.dart';
import 'package:snake_game/ui/snake_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static double snakeDimension = 20;

  Snake snake = Snake();
  Food food = Food(SnakePoint(160, 100));

  double layoutWidth;
  double layoutHeight;

  bool playing = false;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() {
    if (!playing) {
      return;
    }

    Future.delayed(Duration(milliseconds: 250), () {
      SnakeMoveResult moveResult = snake.move(food, layoutWidth, layoutHeight);

      switch (moveResult) {
        case SnakeMoveResult.moved:
          break;
        case SnakeMoveResult.borderCollission:
        case SnakeMoveResult.selfCollission:
          playing = false;
          break;
        case SnakeMoveResult.collidedWithFood:
          food = spawnFood(snake);
          break;
      }

      setState(() {});

      if (playing) {
        _tick();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      this.layoutWidth = constraints.maxWidth;
                      this.layoutHeight = constraints.maxHeight;
                      return CustomPaint(
                        foregroundPainter: SnakePainter(this.snake, this.food, this.layoutWidth, this.layoutHeight),
                      );
                    },
                  ),
                ),
              ),
              Gamepad(_setDirection)
            ],
          ),
          playing
              ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Score: ${snake.points.length - 1}'
                  ,style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          )
              : GestureDetector(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Center(
                      child: Text(
                        'TOUCH TO PLAY',
                        style: TextStyle(color: Colors.green, fontSize: 24),
                      ),
                    ),
                  ),
                  onTap: () {
                    playing = true;
                    snake = Snake();
                    food = Food(SnakePoint(160, 100));

                    setState(() {});

                    _tick();
                  },
                )
        ],
      ),
    );
  }

  void _setDirection(SnakeDirection direction) {
    snake.direction = direction;
    setState(() {});
  }

  SnakePoint _randomFood() {
    Random random = Random();

    int x = random.nextInt(layoutWidth.round() - (_MyHomePageState.snakeDimension.round() * 4)) + (_MyHomePageState.snakeDimension.round() * 2);
    int y = random.nextInt(layoutHeight.round() - (_MyHomePageState.snakeDimension.round() * 4)) + (_MyHomePageState.snakeDimension.round() * 2);

    x = x - (x % 20);
    y = y - (y % 20);

    return SnakePoint(x.toDouble(), y.toDouble());
  }

  Food spawnFood(Snake snake) {
    SnakePoint candidate = _randomFood();

    while (snake.isInSnakeAllReady(candidate)) {
      candidate = _randomFood();
    }

    return Food(candidate);
  }
}


