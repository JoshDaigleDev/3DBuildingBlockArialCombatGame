abstract class Entity {

  int entityId;
  float radius;
  PVector position;
  boolean alive;

  public Entity(float size, PVector startPosition) {
    radius = size;
    position = startPosition;
    alive = true;
  }

  public Entity(float size, float startX, float startY) {
    radius = size;
    position = new PVector(startX, startY);
    alive = true;
  }

  boolean collisionCheck(Entity other) {
    return doCollision && radius + other.getRadius() > dist(position.x, position.y, other.getPosition().x, other.getPosition().y);
  }

  void setPosition(float newX, float newY) {
    position = new PVector(newX, newY);
  }

  void setPosition(PVector newPosition) {
    position = newPosition;
  }

  PVector getPosition() {
    return position;
  }

  float getRadius() {
    return radius;
  }

  boolean isFriendly(Entity other) {
    return false;
  }

  boolean isAlive() {
    return alive;
  }

  void destroy() {
    alive = false;
  }

  void move(PVector velocity) {
    position.add(velocity);
  }

  void handleMovement() {
  }

  void drawEntity() {
  }
  
}
