import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BarBody extends BodyComponent with ContactCallbacks, KeyboardHandler {
  Vector2 position;
  final Vector2 size;

  BarBody(this.position, {Vector2? size}) : size = size ?? Vector2(8, 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
}
