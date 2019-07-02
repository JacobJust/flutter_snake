
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snake_game/model/food.dart';
import 'package:snake_game/model/snake.dart';

class SnakePainter extends CustomPainter {
  final Snake snake;
  final Food food;
  final double width;
  final double height;

  SnakePainter(this.snake, this.food, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    Paint border = Paint()..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    snake.points.forEach((point) {
      canvas.drawRect(Rect.fromLTWH(point.x, point.y, Snake.snakePointDimension, Snake.snakePointDimension), paint);
    });

    paint.color = Colors.yellow;

    canvas.drawRect(Rect.fromLTWH(food.point.x, food.point.y, Snake.snakePointDimension, Snake.snakePointDimension), paint);

    canvas.drawRect(Rect.fromLTWH(4, 0, width - 12, height - 8), border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}