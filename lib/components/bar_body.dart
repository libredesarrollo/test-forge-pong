import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testpong/components/ball_body.dart';

class BarBody extends BodyComponent with ContactCallbacks, KeyboardHandler {
  Vector2 position;
  final Vector2 size;
  double limit = 0;
  final double speedBar = 50;
  double move = 0;
  final bool playerOne;

  int _tiltRightControl = 0;
  int _tiltRightBar = 0;

  BarBody(this.position, {Vector2? size, bool? playerOne})
      : size = size ?? Vector2(8, 1),
        playerOne = playerOne ?? true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    limit = game.camera.visibleWorldRect.bottomRight.toVector2().x;
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(size.x, size.y);
    final bodyDef =
        BodyDef(position: position, type: BodyType.kinematic, userData: this);
    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 0);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    body.setTransform(
        Vector2((body.position.x + move * dt * speedBar).clamp(-limit, limit),
            body.position.y),
        _tiltRightBar.toDouble() * .1);

    if (_tiltRightControl != _tiltRightBar) {
      _tiltRightBar = _tiltRightControl;
      body.setTransform(body.position, _tiltRightBar.toDouble() * .1);
    }

    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    // if (other is BallBody) {
    //   other.body.linearVelocity *= 5;
    // }
    if (other is BallBody) {
      print((other.body.position.x - body.position.x).toString());
    }
    if (other is BallBody) {
      if (other.body.position.x - body.position.x < 0) {
        _tiltRightControl = -1;
      } else {
        _tiltRightControl = 1;
      }
    }

    super.beginContact(other, contact);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      move = 0;
    }

    if (playerOne) {
      // RIGHT
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        move = 1;
      } else
      // LEFT
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        move = -1;
      }
    } else {
      // RIGHT
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        move = 1;
      } else
      // LEFT
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
          keysPressed.contains(LogicalKeyboardKey.keyS)) {
        move = -1;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
