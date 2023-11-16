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
  MyGame() : super(gravity: Vector2(0, 20));

  @override
  FutureOr<void> onLoad() {
    world.add(BarBody(
        Vector2(0, camera.visibleWorldRect.bottomRight.toVector2().y * .9)));
    world.add(BallBody());
    world.addAll(createBoundaries(this));

    return super.onLoad();
  }
}
