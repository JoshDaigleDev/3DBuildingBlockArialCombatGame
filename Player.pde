class Player extends Entity {

  float bankAmountX;
  float bankAmountY;
  float chunk;
  float angle;
  float movementSpeed;

  int fireRate;
  int shootTimer;

  public Player(PVector startPosition) {
    super(1, startPosition);
    bankAmountX = 0;
    bankAmountY = 0;
    chunk = radius/5;
    fireRate = 30;
    shootTimer = 0;
    movementSpeed = 0.1;
  }

  int getFireRate() {
    return fireRate;
  }

  int getShootTimer() {
    return shootTimer;
  }

  void resetShootTimer() {
    shootTimer = 0;
  }

  float getGunSpacing() {
    return 3*chunk;
  }

  void handleMovement() {
    playerInputCheck();
    movePlayerToOrigin();
    angle+=PI/36;
  }

  void playerInputCheck() {
    if (playerMoveLeft) {
      controlPlayer(PlayerDirection.MOVE_LEFT);
      bankAmountY = -PI/12;
    }
    if (playerMoveRight) {
      controlPlayer(PlayerDirection.MOVE_RIGHT);
      bankAmountY = PI/12;
    }
    if (playerMoveDown) {
      controlPlayer(PlayerDirection.MOVE_DOWN);
      bankAmountX = -PI/12;
    }
    if (playerMoveUp) {
      controlPlayer(PlayerDirection.MOVE_UP);
      bankAmountX = PI/12;
    }
    if (!playerMoveLeft && !playerMoveRight || playerMoveLeft && playerMoveRight) bankAmountY = 0;
    if (!playerMoveDown && !playerMoveUp || playerMoveDown && playerMoveUp) bankAmountX = 0;
  }

  void movePlayerToOrigin() {
    boolean playerNotMoving = !playerMoveLeft && !playerMoveRight && !playerMoveDown && !playerMoveUp;
    if (playerNotMoving) {
      if (position.x > playerOrigin.x) move(new PVector(-movementSpeed/4, 0));
      if (position.x < playerOrigin.x) move(new PVector(movementSpeed/4, 0));
      if (position.y > playerOrigin.y) move(new PVector(0, -movementSpeed/4));
      if (position.y < playerOrigin.y) move(new PVector(0, movementSpeed/4));
    }
  }

  void controlPlayer(PlayerDirection dir) {
    switch(dir) {
    case MOVE_LEFT:
      if (position.x - radius > -worldBoundaryX) move(new PVector(-movementSpeed, 0));
      break;
    case MOVE_RIGHT:
      if (position.x + radius < worldBoundaryX) move(new PVector(movementSpeed, 0));
      break;
    case MOVE_DOWN:
      if (position.y - radius > worldBoundaryY2) move(new PVector(0, -movementSpeed));
      break;
    case MOVE_UP:
      if (position.y + radius < worldBoundaryY1) move(new PVector(0, movementSpeed));
      break;
    }
  }

  boolean isFriendly(Entity other) {
    boolean friendly = false;
    if (other instanceof ExplosionProjectile || other instanceof PlayerProjectile) {
      friendly = true;
    }
    return friendly;
  }
  
  float getBankX() {
    return bankAmountY; 
  }

  void drawEntity() {

    pushMatrix();
    rotateX(bankAmountX);
    rotateY(bankAmountY);

    //body
    stroke(0);
    strokeWeight(1.5);
    fill(lightGrey);
    drawBody();

    pushMatrix();
    translate(0, 5*chunk, -chunk/2);
    rotateY(angle);
    drawPropellers();
    popMatrix();

    pushMatrix();
    translate(0, 0, chunk);
    drawWings();
    drawTail();
    popMatrix();

    pushMatrix();
    translate(0, -chunk*map(Math.min(shootTimer, fireRate), 0, 30, 0, 1), 0);
    drawGuns();
    popMatrix();
    popMatrix();
  }

  void incrementShootTimer() {
    shootTimer++;
    int playerGunTextureIndex = (int)Math.floor(map(Math.min(shootTimer, fireRate), 0, 30, 0, 2));
    playerGunTexture = gunTextures[playerGunTextureIndex];
    playerGunColour = gunColours[playerGunTextureIndex];
  }


  void drawPropellers() {
    fill(darkGrey);
    beginShape(QUADS);
    if (doTextures) texture(darkGrey3x1);
    vertex(chunk/2, chunk/2, 1.5*chunk, 0, 0);
    vertex(-chunk/2, chunk/2, 1.5*chunk, 0, 1);
    vertex(-chunk/2, chunk/2, -1.5*chunk, 1, 1);
    vertex(chunk/2, chunk/2, -1.5*chunk, 1, 0);
    endShape();

    //bottom
    beginShape(QUADS);
    if (doTextures) texture(darkGreyBottom3x1);
    vertex(chunk/2, 0, 1.5*chunk, 0, 0);
    vertex(-chunk/2, 0, 1.5*chunk, 0, 1);
    vertex(-chunk/2, 0, -1.5*chunk, 1, 1);
    vertex(chunk/2, 0, -1.5*chunk, 1, 0);
    endShape();

    beginShape(QUADS);
    if (doTextures) texture(darkGrey1x3);
    vertex(1.5*chunk, chunk/2, chunk/2, 0, 0);
    vertex(-1.5*chunk, chunk/2, chunk/2, 0, 1);
    vertex(-1.5*chunk, chunk/2, -chunk/2, 1, 1);
    vertex(1.5*chunk, chunk/2, -chunk/2, 1, 0);
    endShape();

    beginShape(QUADS);
    //bottom
    if (doTextures) texture(darkGreyBottom1x3);
    vertex(1.5*chunk, 0, chunk/2, 0, 0);
    vertex(-1.5*chunk, 0, chunk/2, 0, 1);
    vertex(-1.5*chunk, 0, -chunk/2, 1, 1);
    vertex(1.5*chunk, 0, -chunk/2, 1, 0);
    endShape();

    beginShape(QUADS);
    //back
    vertex(chunk/2, 0, 1.5*chunk);
    vertex(chunk/2, 0, -1.5*chunk);
    vertex(chunk/2, chunk/2, -1.5*chunk);
    vertex(chunk/2, chunk/2, 1.5*chunk);

    //front
    vertex(-chunk/2, 0, 1.5*chunk);
    vertex(-chunk/2, 0, -1.5*chunk);
    vertex(-chunk/2, chunk/2, -1.5*chunk);
    vertex(-chunk/2, chunk/2, 1.5*chunk);

    //top
    vertex(chunk/2, 0, 1.5*chunk);
    vertex(-chunk/2, 0, 1.5*chunk);
    vertex(-chunk/2, chunk/2, 1.5*chunk);
    vertex(chunk/2, chunk/2, 1.5*chunk);

    //bottom
    vertex(chunk/2, 0, -1.5*chunk);
    vertex(-chunk/2, 0, -1.5*chunk);
    vertex(-chunk/2, chunk/2, -1.5*chunk);
    vertex(chunk/2, chunk/2, -1.5*chunk);

    //right
    vertex(1.5*chunk, chunk/2, -chunk/2);
    vertex(-1.5*chunk, chunk/2, -chunk/2);
    vertex(-1.5*chunk, 0, -chunk/2);
    vertex(1.5*chunk, 0, -chunk/2);

    //top
    vertex(1.5*chunk, chunk/2, chunk/2);
    vertex(-1.5*chunk, chunk/2, chunk/2);
    vertex(-1.5*chunk, 0, chunk/2);
    vertex(1.5*chunk, 0, chunk/2);

    //back
    vertex(1.5*chunk, chunk/2, chunk/2);
    vertex(1.5*chunk, chunk/2, -chunk/2);
    vertex(1.5*chunk, 0, -chunk/2);
    vertex(1.5*chunk, 0, chunk/2);

    //front
    vertex(-1.5*chunk, chunk/2, chunk/2);
    vertex(-1.5*chunk, chunk/2, -chunk/2);
    vertex(-1.5*chunk, 0, -chunk/2);
    vertex(-1.5*chunk, 0, chunk/2);
    endShape();
  }

  void drawGuns() {
    fill(playerGunColour);

    //left gun top
    beginShape();
    if (doTextures) texture(playerGunTexture);
    vertex(-3*chunk, 4*chunk, 0, 0, 0);
    vertex(-3*chunk, 1*chunk, 0, 0, 1);
    vertex(-4*chunk, 1*chunk, 0, 1, 1);
    vertex(-4*chunk, 4*chunk, 0, 1, 0);
    endShape();

    //left gun left body
    beginShape();
    vertex(-4*chunk, 4*chunk, 0);
    vertex(-4*chunk, 4*chunk, -chunk);
    vertex(-4*chunk, 1*chunk, -chunk);
    vertex(-4*chunk, 1*chunk, 0);
    endShape();

    //left gun right body
    beginShape();
    vertex(-3*chunk, 4*chunk, 0);
    vertex(-3*chunk, 4*chunk, -chunk);
    vertex(-3*chunk, 1*chunk, -chunk);
    vertex(-3*chunk, 1*chunk, 0);
    endShape();

    //left gun body back
    beginShape();
    vertex(-3*chunk, 1*chunk, 0);
    vertex(-3*chunk, 1*chunk, -chunk);
    vertex(-4*chunk, 1*chunk, -chunk);
    vertex(-4*chunk, 1*chunk, 0);
    endShape();

    //left gun body front
    beginShape();
    vertex(-3*chunk, 4*chunk, 0);
    vertex(-3*chunk, 4*chunk, -chunk);
    vertex(-4*chunk, 4*chunk, -chunk);
    vertex(-4*chunk, 4*chunk, 0);
    endShape();

    //right gun top
    beginShape();
    if (doTextures) texture(playerGunTexture);
    vertex(3*chunk, 4*chunk, 0, 0, 0);
    vertex(3*chunk, 1*chunk, 0, 0, 1);
    vertex(4*chunk, 1*chunk, 0, 1, 1);
    vertex(4*chunk, 4*chunk, 0, 1, 0);
    endShape();

    //right gun left body
    beginShape();
    vertex(4*chunk, 4*chunk, 0);
    vertex(4*chunk, 4*chunk, -chunk);
    vertex(4*chunk, 1*chunk, -chunk);
    vertex(4*chunk, 1*chunk, 0);
    endShape();

    //right gun right body
    beginShape();
    vertex(3*chunk, 4*chunk, 0);
    vertex(3*chunk, 4*chunk, -chunk);
    vertex(3*chunk, 1*chunk, -chunk);
    vertex(3*chunk, 1*chunk, 0);
    endShape();

    //right gun body back
    beginShape();
    vertex(3*chunk, 1*chunk, 0);
    vertex(3*chunk, 1*chunk, -chunk);
    vertex(4*chunk, 1*chunk, -chunk);
    vertex(4*chunk, 1*chunk, 0);
    endShape();

    //right gun body front
    beginShape();
    vertex(3*chunk, 4*chunk, 0);
    vertex(3*chunk, 4*chunk, -chunk);
    vertex(4*chunk, 4*chunk, -chunk);
    vertex(4*chunk, 4*chunk, 0);
    endShape();
  }

  void drawTail() {
    //tail top

    fill(lightGrey);
    beginShape();
    if (doTextures) texture(lightGrey6x2);
    vertex(3*chunk, -3*chunk, 0, 0, 0);
    vertex(3*chunk, -5*chunk, 0, 0, 1);
    vertex(-3*chunk, -5*chunk, 0, 1, 1);
    vertex(-3*chunk, -3*chunk, 0, 1, 0);
    endShape();

    //tail left body
    beginShape();
    vertex(-3*chunk, -3*chunk, 0);
    vertex(-3*chunk, -5*chunk, 0);
    vertex(-3*chunk, -5*chunk, -chunk);
    vertex(-3*chunk, -3*chunk, -chunk);
    endShape();

    //tail right body
    beginShape();
    vertex(3*chunk, -3*chunk, 0);
    vertex(3*chunk, -5*chunk, 0);
    vertex(3*chunk, -5*chunk, -chunk);
    vertex(3*chunk, -3*chunk, -chunk);
    endShape();

    //tail back body
    beginShape();
    vertex(3*chunk, -5*chunk, 0);
    vertex(3*chunk, -5*chunk, -chunk);
    vertex(-3*chunk, -5*chunk, -chunk);
    vertex(-3*chunk, -5*chunk, 0);
    endShape();

    //tail front body
    beginShape();
    vertex(3*chunk, -3*chunk, 0);
    vertex(3*chunk, -3*chunk, -chunk);
    vertex(-3*chunk, -3*chunk, -chunk);
    vertex(-3*chunk, -3*chunk, 0);
    endShape();
  }

  void drawWings() {
    //wing top
    fill(lightGrey);

    beginShape();
    if (doTextures) texture(lightGrey10x2);
    vertex(radius, 2*chunk, 0, 0, 0);
    vertex(radius, 0, 0, 0, 1);
    vertex(-radius, 0, 0, 1, 1);
    vertex(-radius, 2*chunk, 0, 1, 0);
    endShape();

    //wing left body
    beginShape();
    vertex(-radius, 2*chunk, 0);
    vertex(-radius, 0, 0);
    vertex(-radius, 0, -chunk);
    vertex(-radius, 2*chunk, -chunk);
    endShape();

    //wing right body
    beginShape();
    vertex(radius, 2*chunk, 0);
    vertex(radius, 0, 0);
    vertex(radius, 0, -chunk);
    vertex(radius, 2*chunk, -chunk);
    endShape();

    //wing back body
    beginShape();
    vertex(radius, 0, 0);
    vertex(radius, 0, -chunk);
    vertex(-radius, 0, -chunk);
    vertex(-radius, 0, 0);
    endShape();

    //wing front body
    beginShape();
    vertex(radius, 2*chunk, 0);
    vertex(radius, 2*chunk, -chunk);
    vertex(-radius, 2*chunk, -chunk);
    vertex(-radius, 2*chunk, 0);
    endShape();
  }

  void drawBody() {
    //body top
    beginShape();
    if (doTextures) texture(lightGrey2x10);
    vertex(chunk, radius, 0, 0, 0);
    vertex(chunk, -radius, 0, 0, 1);
    vertex(-chunk, -radius, 0, 1, 1);
    vertex(-chunk, radius, 0, 1, 0);
    endShape();

    //body left
    beginShape();
    vertex(-chunk, radius, -chunk);
    vertex(-chunk, radius, 0);
    vertex(-chunk, -radius, 0);
    vertex(-chunk, -radius, -chunk);
    endShape();

    //body right
    beginShape();
    vertex(chunk, radius, -chunk);
    vertex(chunk, radius, 0);
    vertex(chunk, -radius, 0);
    vertex(chunk, -radius, -chunk);
    endShape();

    //body back
    beginShape();
    vertex(chunk, -radius, 0);
    vertex(chunk, -radius, -chunk);
    vertex(-chunk, -radius, -chunk);
    vertex(-chunk, -radius, 0);
    endShape();

    //body front
    beginShape();
    vertex(chunk, radius, 0);
    vertex(chunk, radius, -chunk);
    vertex(-chunk, radius, -chunk);
    vertex(-chunk, radius, 0);
    endShape();
  }

  String toString() {
    return "PLAYER";
  }
}
