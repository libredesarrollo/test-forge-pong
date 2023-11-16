import 'package:flame_forge2d/flame_forge2d.dart';

class BallBody extends BodyComponent {

  BallBody() : super() {
    renderBody = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2;
    final bodyDef = BodyDef(
        position: Vector2(0, 0), type: BodyType.dynamic, userData: this);
    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 5, restitution: 0);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
