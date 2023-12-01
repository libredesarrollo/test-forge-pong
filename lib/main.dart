import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:testpong/components/ball_body.dart';
import 'package:testpong/components/bar_body.dart';

import 'package:testpong/utils/boundaries.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends Forge2DGame with HasKeyboardHandlerComponents {
  MyGame() : super(gravity: Vector2(0, 0));

  double limitBall = 0;
  final BallBody _ballBody = BallBody();

  @override
  FutureOr<void> onLoad() {
    limitBall = camera.visibleWorldRect.bottomRight.toVector2().y + 50;

    world.add(BarBody(
        Vector2(0, camera.visibleWorldRect.bottomRight.toVector2().y * .9)));
    world.add(BarBody(
        Vector2(0, camera.visibleWorldRect.topRight.toVector2().y * .9),
        playerOne: false));
    world.add(_ballBody);
    world.addAll(createBoundaries(this));

    return super.onLoad();
  }

  _resetBall() {
    // _ballBody.body.linearVelocity = Vector2.all(0);
    final velocity = (Vector2.random() - Vector2.random()) * 50;
    _ballBody.body.linearVelocity = velocity;
    _ballBody.body.setTransform(Vector2(0, 0), 0);
  }

  @override
  void update(double dt) {
    if (_ballBody.isLoaded && _ballBody.position.y.abs() > limitBall) {
      _resetBall();
    }
    super.update(dt);
  }
}
