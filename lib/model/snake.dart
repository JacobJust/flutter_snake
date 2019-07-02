import 'package:snake_game/model/food.dart';
import 'package:snake_game/model/snake_point.dart';
import 'package:snake_game/model/snake_direction.dart';
import 'package:snake_game/model/snake_move_result.dart';

class Snake {
  static final double snakePointDimension = 20;

  List<SnakePoint> points = [];
  SnakeDirection direction;

  Snake() {
    add(100, 100);
    direction = SnakeDirection.right;
  }

  void add(double x, double y) {
    points.add(SnakePoint(x, y));
  }

  SnakeMoveResult move(Food food, double width, double height) {
    SnakePoint newHead = _calcNewHead();

    if (isInSnakeAllReady(newHead, includeNewHead: false)) {
      return SnakeMoveResult.selfCollission;
    } else if (isSnakeLeavingScreen(newHead, width, height)) {
      return SnakeMoveResult.borderCollission;
    }

    SnakePoint head = points[0];

    List<SnakePoint> movedPoints;

    bool canEatFood = (head.x == food.point.x && head.y == food.point.y);

    if (canEatFood) {
      if (points.length == 1) {
        movedPoints = [head];
      } else {
        movedPoints = points.sublist(0, points.length);
      }
    } else {
      if (points.length == 1) {
        movedPoints = [];
      } else {
        movedPoints = points.sublist(0, points.length - 1);
      }
    }

    movedPoints.insert(0, newHead);

    points = movedPoints;

    return canEatFood ? SnakeMoveResult.collidedWithFood : SnakeMoveResult.moved;
  }

  bool isInSnakeAllReady(SnakePoint candidate, {bool includeNewHead = true}) {
    SnakePoint newHead = _calcNewHead();

    if (includeNewHead && newHead.x == candidate.x && newHead.y == candidate.y) {
      return true;
    }

    return points.any((point) => point.x == candidate.x && point.y == candidate.y);
  }

  SnakePoint _calcNewHead() {
    int deltaX = 0;
    int deltaY = 0;

    switch (direction) {
      case SnakeDirection.down:
        deltaY = Snake.snakePointDimension.round();
        break;
      case SnakeDirection.up:
        deltaY = -Snake.snakePointDimension.round();
        break;
      case SnakeDirection.left:
        deltaX = -Snake.snakePointDimension.round();
        break;
      case SnakeDirection.right:
        deltaX = Snake.snakePointDimension.round();
        break;
    }

    SnakePoint newHead = SnakePoint(points[0].x + deltaX, points[0].y + deltaY);
    return newHead;
  }

  bool isSnakeLeavingScreen(SnakePoint newHead, double width, double height) => (newHead.x < 0 || (newHead.x + 20) >= width || newHead.y < 0 || (newHead.y + 20) > height);
}