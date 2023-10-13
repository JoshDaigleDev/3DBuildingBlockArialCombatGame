class Enemy extends Entity {

  final int NUM_DATA = 2;
  final int NUM_KEYFRAMES = 4;
  final float PIXELS_PER_SEC = 3;
  
  int startFrame, endFrame, counter, shootTimer;
  int[] numSteps;

  float chunk;
  float angle;
  float bankLeftMin, bankRightMin, bankRightMax, bankLeftMax;
  float bankBottomMin, bankTopMin, bankTopMax, bankBottomMax;
  float bankTime, bankTimeMax;
  float previousAngleX, previousAngleY;
  float[][] keyFrames;

  boolean resetNext;
  PImage gunTexture;  
  color gunColour;
  PVector previousPosition;
  Player player;

  public Enemy(PVector startPosition, Player target) {
    super(1, startPosition);
    keyFrames = new float[NUM_KEYFRAMES][NUM_DATA];
    numSteps = new int[NUM_KEYFRAMES];
    startFrame = 0;
    endFrame = 1;
    counter = 0;
    setupKeyframes(keyFrames);
    resetNext = false;
    shootTimer = 0;
    enemyFireRate = 180;
    chunk = radius/5;
    angle = 0;
    player = target;
    previousPosition = position;
    bankRightMin = -PI/24;
    bankLeftMin = PI/24;
    bankRightMax = PI/24;
    bankLeftMax = -PI/24;
    bankTopMin = -PI/36;
    bankBottomMin = PI/36;
    bankTopMax = PI/36;
    bankBottomMax = -PI/36;
    bankTime = 0;
    bankTimeMax = 30;
    previousAngleX = 0;
    previousAngleY = 0;
  }

  float lerpBankAngleXRight() {
    return previousAngleX = lerp(bankRightMin, bankRightMax, easeInOut(bankTime/bankTimeMax));
  }

  float lerpBankAngleXLeft() {
    return previousAngleX = lerp(bankLeftMin, bankLeftMax, easeInOut(bankTime/bankTimeMax));
  }

  float lerpBankAngleYUp() {
    return previousAngleX = lerp(bankTopMin, bankTopMax, easeInOut(bankTime/bankTimeMax));
  }

  float lerpBankAngleYDown() {
    return previousAngleX = lerp(bankBottomMin, bankBottomMax, easeInOut(bankTime/bankTimeMax));
  }

  boolean movingLeft() {
    return position.x < previousPosition.x;
  }

  boolean movingRight() {
    return position.x > previousPosition.x;
  }

  boolean movingDown() {
    return position.y > previousPosition.y;
  }

  boolean movingUp() {
    return position.y < previousPosition.y;
  }

  float getCurrentBankXAngle() {
    float angle = 0;
    if (movingLeft()) angle = lerpBankAngleXLeft();
    if (movingRight()) angle = lerpBankAngleXRight();

    return angle;
  }

  float getCurrentBankYAngle() {
    float angle = 0;
    if (movingDown()) angle = lerpBankAngleXLeft();
    if (movingUp()) angle = lerpBankAngleXRight();

    return angle;
  }

  boolean isFriendly(Entity other) {
    boolean friendly = false;
    if (other instanceof ExplosionProjectile || other instanceof Enemy || other instanceof EnemyProjectile) {
      friendly = true;
    }
    return friendly;
  }

  float parameterFromCounter(int c) {
    return (float)c/numSteps[startFrame];
  }

  void handleMovement() {
    float t = easeInOut((parameterFromCounter(counter)));
    float lerpX = lerp(keyFrames[startFrame][0], keyFrames[endFrame][0], t);
    float lerpY = lerp(keyFrames[startFrame][1], keyFrames[endFrame][1], t);
    previousPosition = position;
    setPosition(new PVector(lerpX, lerpY));
    angle+=PI/36;
    if (bankTime <= bankTimeMax) bankTime++;
    updateCounter();
  }

  void setupKeyframes(float[][] keyFrames) {
    PVector[] vertices = new PVector[NUM_KEYFRAMES];
    vertices[0] = position;
    vertices[1] = new PVector(random(-worldBoundaryX, worldBoundaryX), random(worldBoundaryY2 + QUADRANT_SIZE, worldBoundaryY1));
    vertices[2] = new PVector(random(-worldBoundaryX, worldBoundaryX), random(worldBoundaryY2 + QUADRANT_SIZE, worldBoundaryY1));
    vertices[3] = new PVector(random(-worldBoundaryX, worldBoundaryX), random(worldBoundaryY2 + QUADRANT_SIZE, worldBoundaryY1));

    for (int i=0; i<NUM_KEYFRAMES-1; i++) {
      if (dist(vertices[i].x, vertices[i].y, vertices[i+1].x, vertices[i+1].y) < 1) {
        vertices[i+1].x += 1;
        vertices[i+1].y += 1;
      }
    }

    for (int i=0; i<NUM_KEYFRAMES; i++) {
      keyFrames[i][X] = vertices[i].x;
      keyFrames[i][Y] = vertices[i].y;
    }

    for (int i=0; i<NUM_KEYFRAMES; i++) {
      numSteps[i] = numStepsForConstantSpeed(vertices[i], vertices[(i+1)%NUM_KEYFRAMES]);
    }
  }

  void resetKeyframes(float[][] keyFrames) {
    PVector[] vertices = new PVector[NUM_KEYFRAMES];
    vertices[0] = new PVector(keyFrames[0][X], keyFrames[0][Y]);
    vertices[1] = new PVector(random(-worldBoundaryX, worldBoundaryX), random(worldBoundaryY2 + QUADRANT_SIZE, worldBoundaryY1));
    vertices[2] = new PVector(random(-worldBoundaryX, worldBoundaryX), random(worldBoundaryY2 + QUADRANT_SIZE, worldBoundaryY1));
    vertices[3] = new PVector(random(-worldBoundaryX, worldBoundaryX), random(worldBoundaryY2 + QUADRANT_SIZE, worldBoundaryY1));

    for (int i=0; i<NUM_KEYFRAMES-1; i++) {
      if (dist(vertices[i].x, vertices[i].y, vertices[i+1].x, vertices[i+1].y) < 1) {
        vertices[i+1].x += 1;
        vertices[i+1].y += 1;
      }
    }

    for (int i=0; i<NUM_KEYFRAMES; i++) {
      keyFrames[i][X] = vertices[i].x;
      keyFrames[i][Y] = vertices[i].y;
    }

    for (int i=0; i<NUM_KEYFRAMES; i++) {
      numSteps[i] = numStepsForConstantSpeed(vertices[i], vertices[(i+1)%NUM_KEYFRAMES]);
    }
  }

  int numStepsForConstantSpeed(PVector start, PVector end) {
    PVector displacement = end.copy();
    displacement.sub(start);
    float distance = displacement.mag();

    return int(distance*frameRate/PIXELS_PER_SEC);
  }

  boolean nextKeyframe(int c) {
    return c >= numSteps[startFrame];
  }

  void updateCounter() {
    counter++;
    if (nextKeyframe(counter)) {
      startFrame = (startFrame+1) % NUM_KEYFRAMES;
      endFrame = (endFrame+1) % NUM_KEYFRAMES;
      bankRightMin = previousAngleX;
      bankLeftMin = previousAngleX;

      bankTopMin = previousAngleY;
      bankBottomMin = previousAngleY;
      counter = 0;
      bankTime = 0;
      if (resetNext) {
        resetKeyframes(keyFrames);
        resetNext = false;
      }
      if (startFrame == NUM_KEYFRAMES - 1) {
        resetNext = true;
      }
    }
  }

  void incrimentShootTimer() {
    shootTimer++;
    int gunTextureIndex = (int)Math.floor(map(Math.min(shootTimer, enemyFireRate), 0, 150, 0, 2));
    gunTexture = gunTextures[gunTextureIndex];
    gunColour = gunColours[gunTextureIndex];
  }

  void resetShootTimer() {
    shootTimer = 0;
  }

  boolean canShoot() {
    return shootTimer >= enemyFireRate;
  }

  String toString() {
    return "ENEMY";
  }

  float getAngleToPlayer() {
    return PI-atan2(player.getPosition().x-position.x, player.getPosition().y-position.y);//atan2(player.getPosition().y-position.y, player.getPosition().x-position.x);
  }

  float getGunTipY() {
    return -5*chunk+chunk*Math.min(map(shootTimer, 0, 180, 0, 1), 1);
  }

  PVector getGunTip() {

    pushMatrix();
    translate(position.x, position.y);
    PVector newPosition = new PVector(0, getGunTipY());
    newPosition.rotate(getAngleToPlayer());
    popMatrix();

    return new PVector(newPosition.x + position.x, newPosition.y + position.y);
  }

  void drawEntity() {

    pushMatrix();
    rotateY(getCurrentBankXAngle());
    rotateX(getCurrentBankYAngle());
    rotate(getAngleToPlayer());
    fill(lightGrey);
    stroke(0);
    strokeWeight(1.5);

    //body
    pushMatrix();
    translate(0, 0, chunk);
    drawBody();
    popMatrix();
    
    //tail
    pushMatrix();
    translate(0, chunk);
    drawTail();
    popMatrix();

    //gun
    pushMatrix();
    translate(0, -5*chunk+chunk*Math.min(map(shootTimer, 0, 180, 0, 1), 1));
    drawGun();
    popMatrix();
    popMatrix();
  }

  void drawBody() {
    //top
    beginShape();
    if (doTextures) texture(lightGrey4x6);
    vertex(2*chunk, 3*chunk, 0, 0, 0);
    vertex(2*chunk, -3*chunk, 0, 0, 1);
    vertex(-2*chunk, -3*chunk, 0, 1, 1);
    vertex(-2*chunk, 3*chunk, 0, 1, 0);
    endShape();

    //right
    beginShape();
    vertex(2*chunk, 3*chunk, 0);
    vertex(2*chunk, 3*chunk, -chunk);
    vertex(2*chunk, -3*chunk, -chunk);
    vertex(2*chunk, -3*chunk, 0);
    endShape();

    //left
    beginShape();
    vertex(-2*chunk, 3*chunk, 0);
    vertex(-2*chunk, 3*chunk, -chunk);
    vertex(-2*chunk, -3*chunk, -chunk);
    vertex(-2*chunk, -3*chunk, 0);
    endShape();

    //front
    beginShape();
    vertex(2*chunk, -3*chunk, 0);
    vertex(2*chunk, -3*chunk, -chunk);
    vertex(-2*chunk, -3*chunk, -chunk);
    vertex(-2*chunk, -3*chunk, 0);
    endShape();

    //back
    beginShape();
    vertex(2*chunk, 3*chunk, 0);
    vertex(2*chunk, 3*chunk, -chunk);
    vertex(-2*chunk, 3*chunk, -chunk);
    vertex(-2*chunk, 3*chunk, 0);
    endShape();

    //propellers
    pushMatrix();
    translate(0, 0, chunk);
    rotate(angle);
    drawPropellers();
    popMatrix();
  }

  void drawGun() {
    fill(gunColour);

    //top
    beginShape(QUADS);
    if (doTextures) texture(gunTexture);
    vertex(chunk/2, 3*chunk, 0, 0, 0);
    vertex(chunk/2, 0, 0, 0, 1);
    vertex(-chunk/2, 0, 0, 1, 1);
    vertex(-chunk/2, 3*chunk, 0, 1, 0);
    endShape();

    //front
    beginShape(QUADS);
    vertex(chunk/2, 0, 0);
    vertex(chunk/2, 0, -chunk/2);
    vertex(-chunk/2, 0, -chunk/2);
    vertex(-chunk/2, 0, 0);
    endShape();

    //back
    beginShape(QUADS);
    vertex(chunk/2, 3*chunk, 0);
    vertex(chunk/2, 3*chunk, -chunk/2);
    vertex(-chunk/2, 3*chunk -chunk/2);
    vertex(-chunk/2, 3*chunk, 0);
    endShape();

    //right
    beginShape(QUADS);
    vertex(chunk/2, 3*chunk, 0);
    vertex(chunk/2, 3*chunk, -chunk/2);
    vertex(chunk/2, 0, -chunk/2);
    vertex(chunk/2, 0, 0);
    endShape();

    //left
    beginShape(QUADS);
    vertex(-chunk/2, 3*chunk, 0);
    vertex(-chunk/2, 3*chunk, -chunk/2);
    vertex(-chunk/2, 0, -chunk/2);
    vertex(-chunk/2, 0, 0);
    endShape();
  }

  void drawPropellers() {
    fill(darkGrey);

    //1 top
    beginShape(QUADS);
    if (doTextures) texture(darkGrey1x11);
    vertex(chunk/2, 5.5*chunk, 0, 0, 0);
    vertex(chunk/2, -5.5*chunk, 0, 0, 1);
    vertex(-chunk/2, -5.5*chunk, 0, 1, 1);
    vertex(-chunk/2, 5.5*chunk, 0, 1, 0);
    endShape();

    //1 front
    beginShape(QUADS);
    vertex(chunk/2, -5.5*chunk, 0);
    vertex(chunk/2, -5.5*chunk, -chunk/2);
    vertex(-chunk/2, -5.5*chunk, -chunk/2);
    vertex(-chunk/2, -5.5*chunk, 0);
    endShape();

    //1 back
    beginShape(QUADS);
    vertex(chunk/2, 5.5*chunk, 0);
    vertex(chunk/2, 5.5*chunk, -chunk/2);
    vertex(-chunk/2, 5.5*chunk, -chunk/2);
    vertex(-chunk/2, 5.5*chunk, 0);
    endShape();

    //1 right
    beginShape(QUADS);
    vertex(chunk/2, 5.5*chunk, 0);
    vertex(chunk/2, 5.5*chunk, -chunk/2);
    vertex(chunk/2, -5.5*chunk, -chunk/2);
    vertex(chunk/2, -5.5*chunk, 0);
    endShape();

    //1 left
    beginShape(QUADS);
    vertex(-chunk/2, 5.5*chunk, 0);
    vertex(-chunk/2, 5.5*chunk, -chunk/2);
    vertex(-chunk/2, -5.5*chunk, -chunk/2);
    vertex(-chunk/2, -5.5*chunk, 0);
    endShape();

    //propeller 2
    //2 top
    beginShape(QUADS);
    if (doTextures) texture(darkGrey1x11);
    vertex(5.5*chunk, chunk/2, 0, 0, 0);
    vertex(-5.5*chunk, chunk/2, 0, 0, 1);
    vertex(-5.5*chunk, -chunk/2, 0, 1, 1);
    vertex(5.5*chunk, -chunk/2, 0, 1, 0);
    endShape();

    //2 front
    beginShape(QUADS);
    vertex(5.5*chunk, -chunk/2, 0);
    vertex(5.5*chunk, -chunk/2, -chunk/2);
    vertex(-5.5*chunk, -chunk/2, -chunk/2);
    vertex(-5.5*chunk, -chunk/2, 0);
    endShape();

    //2 back
    beginShape(QUADS);
    vertex(5.5*chunk, chunk/2, 0);
    vertex(5.5*chunk, chunk/2, -chunk/2);
    vertex(-5.5*chunk, chunk/2, -chunk/2);
    vertex(-5.5*chunk, chunk/2, 0);
    endShape();

    //2 right
    beginShape(QUADS);
    vertex(5.5*chunk, chunk/2, 0);
    vertex(5.5*chunk, chunk/2, -chunk/2);
    vertex(5.5*chunk, -chunk/2, -chunk/2);
    vertex(5.5*chunk, -chunk/2, 0);
    endShape();

    //2 right
    beginShape(QUADS);
    vertex(-5.5*chunk, chunk/2, 0);
    vertex(-5.5*chunk, chunk/2, -chunk/2);
    vertex(-5.5*chunk, -chunk/2, -chunk/2);
    vertex(-5.5*chunk, -chunk/2, 0);
    endShape();
  }


  void drawTail() {
    //tail
    fill(lightGrey);

    //top
    beginShape(QUADS);
    if (doTextures) texture(lightGrey2x6);
    vertex(chunk, 6*chunk, 0, 0, 0);
    vertex(chunk, 0, 0, 0, 1);
    vertex(-chunk, 0, 0, 1, 1);
    vertex(-chunk, 6*chunk, 0, 1, 0);
    endShape();

    //right
    beginShape(QUADS);
    vertex(chunk, 0, 0);
    vertex(chunk, 0, -chunk);
    vertex(chunk, 6*chunk, -chunk);
    vertex(chunk, 6*chunk, 0);
    endShape();

    //left
    beginShape(QUADS);
    vertex(-chunk, 0, 0);
    vertex(-chunk, 0, -chunk);
    vertex(-chunk, 6*chunk, -chunk);
    vertex(-chunk, 6*chunk, 0);
    endShape();

    //front
    beginShape(QUADS);
    vertex(chunk, 0, 0);
    vertex(chunk, 0, -chunk);
    vertex(-chunk, 0, -chunk);
    vertex(-chunk, 0, 0);
    endShape();

    //back
    beginShape(QUADS);
    vertex(chunk, 6*chunk, 0);
    vertex(chunk, 6*chunk, -chunk);
    vertex(-chunk, 6*chunk, -chunk);
    vertex(-chunk, 6*chunk, 0);
    endShape();

    pushMatrix();
    translate(0, 6*chunk, chunk);
    drawTailEnd();
    popMatrix();

    pushMatrix();
    translate(chunk, 6*chunk);
    rotateX(angle);
    drawTailPropellers();
    popMatrix();
  }

  void drawTailEnd() {
    fill(lightGrey);
    //top
    beginShape(QUADS);
    if (doTextures) texture(lightGrey2x2);
    vertex(chunk, chunk, 0, 0, 0);
    vertex(chunk, -chunk, 0, 0, 1);
    vertex(-chunk, -chunk, 0, 1, 1);
    vertex(-chunk, chunk, 0, 1, 0);
    endShape();

    //front
    beginShape(QUADS);
    vertex(chunk, -chunk, 0);
    vertex(chunk, -chunk, -chunk);
    vertex(-chunk, -chunk, -chunk);
    vertex(-chunk, -chunk, 0);
    endShape();

    //front
    beginShape(QUADS);
    vertex(chunk, chunk, 0);
    vertex(chunk, chunk, -chunk);
    vertex(-chunk, chunk, -chunk);
    vertex(-chunk, chunk, 0);
    endShape();

    //right
    beginShape(QUADS);
    vertex(chunk, chunk, 0);
    vertex(chunk, chunk, -chunk);
    vertex(chunk, -chunk, -chunk);
    vertex(chunk, -chunk, 0);
    endShape();

    //left
    beginShape(QUADS);
    vertex(-chunk, chunk, 0);
    vertex(-chunk, chunk, -chunk);
    vertex(-chunk, -chunk, -chunk);
    vertex(-chunk, -chunk, 0);
    endShape();
  }

  void drawTailPropellers() {
    fill(darkGrey);

    //tail propeller 1
    //top
    beginShape(QUADS);
    if (doTextures) texture(darkGrey3x1);
    vertex(chunk/2, chunk/2, 1.5*chunk, 0, 0);
    vertex(chunk/2, -chunk/2, 1.5*chunk, 0, 1);
    vertex(chunk/2, -chunk/2, -1.5*chunk, 1, 1);
    vertex(chunk/2, chunk/2, -1.5*chunk, 1, 0);
    endShape();

    //bottom
    beginShape(QUADS);
    if (doTextures) texture(darkGreyBottom3x1);
    vertex(0, chunk/2, 1.5*chunk, 0, 0);
    vertex(0, -chunk/2, 1.5*chunk, 0, 1);
    vertex(0, -chunk/2, -1.5*chunk, 1, 1);
    vertex(0, chunk/2, -1.5*chunk, 1, 0);
    endShape();

    //tail propeller 2
    //left
    beginShape(QUADS);
    if (doTextures) texture(darkGrey1x3);
    vertex(chunk/2, 1.5*chunk, chunk/2, 0, 0);
    vertex(chunk/2, -1.5*chunk, chunk/2, 0, 1);
    vertex(chunk/2, -1.5*chunk, -chunk/2, 1, 1);
    vertex(chunk/2, 1.5*chunk, -chunk/2, 1, 0);
    endShape();

    //right
    beginShape(QUADS);
    if (doTextures) texture(darkGrey1x3);
    vertex(0, 1.5*chunk, chunk/2, 0, 0);
    vertex(0, -1.5*chunk, chunk/2, 0, 1);
    vertex(0, -1.5*chunk, -chunk/2, 1, 1);
    vertex(0, 1.5*chunk, -chunk/2, 1, 0);
    endShape();

    //back
    beginShape(QUADS);
    vertex(0, chunk/2, 1.5*chunk);
    vertex(0, chunk/2, -1.5*chunk);
    vertex(chunk/2, chunk/2, -1.5*chunk);
    vertex(chunk/2, chunk/2, 1.5*chunk);

    //front
    beginShape(QUADS);
    vertex(0, -chunk/2, 1.5*chunk);
    vertex(0, -chunk/2, -1.5*chunk);
    vertex(chunk/2, -chunk/2, -1.5*chunk);
    vertex(chunk/2, -chunk/2, 1.5*chunk);

    //top
    vertex(0, chunk/2, 1.5*chunk);
    vertex(0, -chunk/2, 1.5*chunk);
    vertex(chunk/2, -chunk/2, 1.5*chunk);
    vertex(chunk/2, chunk/2, 1.5*chunk);

    //bottom
    vertex(0, chunk/2, -1.5*chunk);
    vertex(0, -chunk/2, -1.5*chunk);
    vertex(chunk/2, -chunk/2, -1.5*chunk);
    vertex(chunk/2, chunk/2, -1.5*chunk);


    //bottom
    vertex(chunk/2, 1.5*chunk, -chunk/2);
    vertex(chunk/2, -1.5*chunk, -chunk/2);
    vertex(0, -1.5*chunk, -chunk/2);
    vertex(0, 1.5*chunk, -chunk/2);

    //top
    vertex(chunk/2, 1.5*chunk, chunk/2);
    vertex(chunk/2, -1.5*chunk, chunk/2);
    vertex(0, -1.5*chunk, chunk/2);
    vertex(0, 1.5*chunk, chunk/2);

    //back
    vertex(chunk/2, 1.5*chunk, chunk/2);
    vertex(chunk/2, 1.5*chunk, -chunk/2);
    vertex(0, 1.5*chunk, -chunk/2);
    vertex(0, 1.5*chunk, chunk/2);

    //front
    vertex(chunk/2, -1.5*chunk, chunk/2);
    vertex(chunk/2, -1.5*chunk, -chunk/2);
    vertex(0, -1.5*chunk, -chunk/2);
    vertex(0, -1.5*chunk, chunk/2);
    endShape();
  }
}
