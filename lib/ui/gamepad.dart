
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snake_game/model/snake_direction.dart';

class Gamepad extends StatelessWidget {
  final Function(SnakeDirection) receiver;

  Gamepad(this.receiver);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildFlatButton(SnakeDirection.left, Icons.keyboard_arrow_left),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildFlatButton(SnakeDirection.up, Icons.keyboard_arrow_up),
                  Container(height: 20,
                    width: 1,),
                  buildFlatButton(SnakeDirection.down, Icons.keyboard_arrow_down),
                ],
              ),
              buildFlatButton(SnakeDirection.right, Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }

  FlatButton buildFlatButton(SnakeDirection direction, IconData icon ) {
    return FlatButton(
              child: Icon(icon),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.grey,
              onPressed: () {
                receiver(direction);
              },
            );
  }
}
