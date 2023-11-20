import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:testpong/components/ball_body.dart';

List<Wall> createBoundaries(Forge2DGame game, {double? strokeWidth}) {
  final visibleRect = game.camera.visibleWorldRect;
  final topLeft = visibleRect.topLeft.toVector2();
  final topRight = visibleRect.topRight.toVector2();
  final bottomRight = visibleRect.bottomRight.toVector2();
  final bottomLeft = visibleRect.bottomLeft.toVector2();

  return [
    Wall(topLeft, topRight, strokeWidth: strokeWidth, tiltinvert: true),
    Wall(topRight, bottomRight,
        strokeWidth: strokeWidth, tiltinvert: true, tiltX: false),
    Wall(bottomLeft, bottomRight, strokeWidth: strokeWidth),
    Wall(topLeft, bottomLeft, strokeWidth: strokeWidth, tiltX: false),
  ];
}

class Wall extends BodyComponent with ContactCallbacks {
  final Vector2 start;
  final Vector2 end;
  final double strokeWidth;
  bool tiltinvert;
  bool tiltX;

  int _tiltRightControl = 0;
  int _tiltRightBar = 0;

  Wall(this.start, this.end,
      {double? strokeWidth, bool? tiltinvert, bool? tiltX})
      : strokeWidth = strokeWidth ?? 1,
        tiltinvert = tiltinvert ?? false,
        tiltX = tiltX ?? true;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
        userData: this, // To be able to determine object in collision
        position: Vector2.zero(),
        angle: 0);
    paint.strokeWidth = strokeWidth;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is BallBody) {
      final tild = tiltX ? other.body.position.x : other.body.position.y;
      if (tild < 0) {
        _tiltRightControl = -1;
      } else {
        _tiltRightControl = 1;
      }
      // print('${other.body.position}  ${_tiltRightControl}  ${_tiltRightBar}');
    }

    super.beginContact(other, contact);
  }

  @override
  void update(double dt) {
    if (_tiltRightControl != _tiltRightBar) {
      _tiltRightBar = _tiltRightControl;
      // if (_tiltRightBar == -1) {
      // } else {
      // print(' ${_tiltRightControl}  ${_tiltRightBar}');
      if (tiltinvert) {
        body.setTransform(body.position, _tiltRightBar.toDouble() * .04 * -1);
      } else {
        body.setTransform(body.position, _tiltRightBar.toDouble() * .04);
      }
      // }
    }

    super.update(dt);
  }

  // @override
  // Future<void> onLoad() {
  //   body.setTransform(body.position, 4);
  //   return super.onLoad();
  // }
}
