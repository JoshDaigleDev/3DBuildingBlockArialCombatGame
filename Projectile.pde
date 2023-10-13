abstract class Projectile extends Entity {

  int lifeSpan;
  float speed;
  PVector direction;

  public Projectile(PVector startPosition, PVector dir) {
    super(0.1, startPosition);
    lifeSpan = 120;
    speed = 0;
    direction = dir;
  }

  void drawEntity() {
    if (lifeSpan >= 118) {
      fill(yellow, 0.5);
      noStroke();
      sphere(0.5);
    }
    fill(darkGrey);
    strokeWeight(2);
    stroke(red);
    //top
    pushMatrix();
    rotateX(-direction.y*lifeSpan*PI/10);
    rotateY(direction.z*lifeSpan*PI/100);
    rotateZ(direction.x*lifeSpan*PI/100);
    beginShape();
    if (doTextures) texture(red1x1);
    vertex(radius, radius, radius, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, radius, radius, 0, 1);
    endShape();

    //bottom
    beginShape();
    if (doTextures) texture(redBottom1x1);
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, -radius, 0, 1, 0);
    vertex(-radius, -radius, 0, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //front
    beginShape();
    vertex(radius, -radius, 0, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //back
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(-radius, radius, radius, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //left
    beginShape();
    vertex(-radius, radius, 0, 1, 1);
    vertex(-radius, radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //right
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(radius, -radius, radius, 0, 0);
    vertex(radius, -radius, 0, 0, 1);
    endShape();

    popMatrix();
    noStroke();
  }

  void handleMovement() {
    PVector velocity = direction.copy().mult(speed);
    move(velocity);
    lifeSpan--;
  }

  boolean isAlive() {
    if (lifeSpan <= 0 || position.z < -1 || position.y > worldBoundaryY1) alive = false;
    return alive;
  }
}

class PlayerProjectile extends Projectile {

  public PlayerProjectile(PVector startPosition, PVector dir) {
    super(startPosition, dir);
    speed = 0.2;
  }

  boolean isFriendly(Entity other) {
    boolean friendly = false;
    if (other instanceof ExplosionProjectile || other instanceof Player) {
      friendly = true;
    }
    return friendly;
  }



  void drawEntity() {
    if (lifeSpan >= 118) {
      fill(yellow, 0.5);
      noStroke();
      sphere(0.5);
    }
    fill(yellow);
    strokeWeight(2);
    stroke(red);
    //top
    pushMatrix();
    rotateX(direction.y*lifeSpan*PI/6);
    beginShape();
    if (doTextures) texture(yellow1x1);
    vertex(radius, radius, radius, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, radius, radius, 0, 1);
    endShape();

    //bottom
    beginShape();
    if (doTextures) texture(yellow1x1);
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, -radius, 0, 1, 0);
    vertex(-radius, -radius, 0, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //front
    beginShape();
    vertex(radius, -radius, 0, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //back
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(-radius, radius, radius, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //left
    beginShape();
    vertex(-radius, radius, 0, 1, 1);
    vertex(-radius, radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //right
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(radius, -radius, radius, 0, 0);
    vertex(radius, -radius, 0, 0, 1);
    endShape();

    popMatrix();
    noStroke();
  }
  String toString() {
    return "PLAYER_PROJECTILE";
  }
}

class EnemyProjectile extends Projectile {

  float rotateAngle;
  public EnemyProjectile(PVector startPosition, PVector dir, float angleToPlayer) {
    super(startPosition, dir);
    speed = 0.1;
    rotateAngle = angleToPlayer;
  }

  boolean isFriendly(Entity other) {
    boolean friendly = false;
    if (other instanceof ExplosionProjectile || other instanceof Enemy || other instanceof EnemyProjectile) {
      friendly = true;
    }
    return friendly;
  }

  void drawEntity() {
    if (lifeSpan >= 118) {
      fill(darkGrey, 0.5);
      noStroke();
      sphere(0.5);
    }
    fill(yellow);
    strokeWeight(2);
    stroke(red);
    //top
    pushMatrix();
    rotate(rotateAngle);
    rotateX(direction.y*lifeSpan*PI/6);

    beginShape();
    if (doTextures) texture(yellow1x1);
    vertex(radius, radius, radius, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, radius, radius, 0, 1);
    endShape();

    //bottom
    beginShape();
    if (doTextures) texture(yellow1x1);
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, -radius, 0, 1, 0);
    vertex(-radius, -radius, 0, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //front
    beginShape();
    vertex(radius, -radius, 0, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //back
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(-radius, radius, radius, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //left
    beginShape();
    vertex(-radius, radius, 0, 1, 1);
    vertex(-radius, radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //right
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(radius, -radius, radius, 0, 0);
    vertex(radius, -radius, 0, 0, 1);
    endShape();

    popMatrix();
    noStroke();
  }

  String toString() {
    return "ENEMY_PROJECTILE";
  }
}

class ExplosionProjectile extends Projectile {

  PImage explosionTexture;
  PImage explosionTextureBottom;
  int explosionType;
  int explosionColour;
  public ExplosionProjectile(PVector startPosition, PVector dir) {
    super(startPosition, dir);
    speed = 0.1;
    explosionType = (int)random(0, 4);
    explosionColour = explosionColours[explosionType];
    explosionTexture = explosionTextures[explosionType];
    explosionTextureBottom = explosionTextureBottoms[explosionType];
  }

  void drawEntity() {
    if (lifeSpan >= 110 - (int)random(1, 10) && (int)random(1, 20) == 1) {
      int colorPicker = (int)random(0, 4);
      if (colorPicker == 1) {
        fill(red, 0.5);
      } else if (colorPicker == 2) {
        fill(yellow, 0.5);
      } else if (colorPicker == 3) {
        fill(darkGrey, 0.5);
      } else {
        fill(lightGrey, 0.5);
      }
      noStroke();
      sphere(0.5);
    }

    fill(explosionColour);
    strokeWeight(1);
    stroke(0);
    //top
    pushMatrix();
    rotateX(direction.y*lifeSpan*PI/100);
    rotateY(direction.z*lifeSpan*PI/100);
    rotateZ(direction.x*lifeSpan*PI/100);
    beginShape();
    if (doTextures) texture(explosionTexture);
    vertex(radius, radius, radius, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, radius, radius, 0, 1);
    endShape();

    //bottom
    beginShape();
    if (doTextures) texture(explosionTextureBottom);
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, -radius, 0, 1, 0);
    vertex(-radius, -radius, 0, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //front
    beginShape();
    vertex(radius, -radius, 0, 1, 1);
    vertex(radius, -radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //back
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(-radius, radius, radius, 0, 0);
    vertex(-radius, radius, 0, 0, 1);
    endShape();

    //left
    beginShape();
    vertex(-radius, radius, 0, 1, 1);
    vertex(-radius, radius, radius, 1, 0);
    vertex(-radius, -radius, radius, 0, 0);
    vertex(-radius, -radius, 0, 0, 1);
    endShape();

    //right
    beginShape();
    vertex(radius, radius, 0, 1, 1);
    vertex(radius, radius, radius, 1, 0);
    vertex(radius, -radius, radius, 0, 0);
    vertex(radius, -radius, 0, 0, 1);
    endShape();

    popMatrix();
  }

  boolean isFriendly(Entity other) {
    boolean friendly = false;
    if (other instanceof Entity) {
      friendly = true;
    }
    return friendly;
  }

  void handleMovement() {
    PVector velocity = direction.copy();
    velocity.mult(speed);
    move(velocity);
    lifeSpan--;
  }

  String toString() {
    return "EXPLOSION_PROJECTILE";
  }
}
