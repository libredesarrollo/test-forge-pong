import 'package:flame_forge2d/flame_forge2d.dart';

class BallBody extends BodyComponent with ContactCallbacks {
  BallBody() : super() {
    renderBody = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void beginContact(Object other, Contact contact) {
    body.linearVelocity *= 5;

    super.beginContact(other, contact);
  }

  @override
  Body createBody() {
    final velocity = (Vector2.random() - Vector2.random()) * 500;
    print(velocity.toString());
    final shape = CircleShape()..radius = 2;
    final bodyDef = BodyDef(
        linearVelocity: velocity,
        position: Vector2(0, 0),
        type: BodyType.dynamic,
        userData: this);
    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 1);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
