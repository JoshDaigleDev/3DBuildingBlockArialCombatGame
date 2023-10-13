int enemyFireRate;
int difficultyLevel;
final int MAX_ENEMIES = 5;
final int GAME_START_BUFFER = 20;

class WorldEvents {

  Player player;

  boolean gameOver;
  int gameTime;
  int playerScore;
  int highScore;

  public WorldEvents() {
    gameTime = 0;
    playerScore = 0;
    highScore = 0;
    difficultyLevel = 0;
    playerOrigin = new PVector(0, -QUADRANT_SIZE/2, 0);
  }

  void initWorld() {
    spawnPlayer();
    spawnEnemy();
    gameOver = false;
  }

  void spawnPlayer() {
    Player p = new Player(playerOrigin.copy());
    entities.addEntity(p);
    player = p;
  }

  void spawnEnemy() {
    if (entities.getEnemies().size() < MAX_ENEMIES) {
      PVector EnemyOrigin = new PVector(random(-worldBoundaryX, worldBoundaryX), worldBoundaryY1*1.5);
      Enemy newEnemy = new Enemy(EnemyOrigin, player);
      entities.addEntity(newEnemy);
    }
  }

  void enemyShoot(Enemy enemy) {
    PVector projectileOrigin = new PVector(enemy.getGunTip().x, enemy.getGunTip().y, enemy.getPosition().z);
    PVector direction = player.getPosition().copy();
    direction.sub(projectileOrigin.copy());
    direction.normalize();
    Projectile p = new EnemyProjectile(projectileOrigin, direction, enemy.getAngleToPlayer());
    entities.addEntity(p);
  }

  void playerShoot() {
    if (player.getShootTimer() >= player.getFireRate()) {
      PVector projectileOriginLeft = new PVector(player.getPosition().x - player.getGunSpacing() - player.getRadius()/10, player.getPosition().y + player.getRadius() - player.getGunSpacing()/3, player.getPosition().z);
      PVector projectileOriginRight = new PVector(player.getPosition().x + player.getGunSpacing() + player.getRadius()/10, player.getPosition().y + player.getRadius()- player.getGunSpacing()/3, player.getPosition().z);
      PVector direction = new PVector(0, 1);
      
      Projectile pL = new PlayerProjectile(projectileOriginLeft, direction);
      Projectile pR = new PlayerProjectile(projectileOriginRight, direction);

      entities.addEntity(pL);
      entities.addEntity(pR);

      player.resetShootTimer();
    }
  }

  void checkForEnemyDeaths() {
    if (gameTime >= 20 && entities.checkForEnemyDeath()) {
      spawnEnemy();
      difficultyLevel++;
    }
  }

  void checkEntityShooting() {
    if (!gameOver) {
      if (playerShoot) {
        playerShoot();
      }
      ArrayList<Enemy> nextEnemyShooters = entities.nextEnemyShooters();
      if (nextEnemyShooters.size() > 0) {
        for (Enemy e : nextEnemyShooters) {
          enemyShoot(e);
        }
      }
    }
  }

  void handleDestruction() {
    ArrayList<Entity> destroyedEntities = entities.checkForDestruction();
    for (Entity e : destroyedEntities) {
      if (e instanceof Enemy) increaseScore();
      if (e instanceof Player) gameOver = true;
      explode(e);
    }
  }

  void explode(Entity entity) {
    int numProjectiles = 100;
    if (performanceMode) numProjectiles = 50;
    if (entities.numExplosionProjectiles() > 300) numProjectiles = 25;
    if (entity instanceof Player || entity instanceof Enemy) {
      for (int i = 0; i < numProjectiles; i++) {
        PVector randomDirection = PVector.random3D();
        PVector entityPosition = entity.getPosition().copy();
        Projectile explosionProjectile = new ExplosionProjectile(entityPosition, randomDirection);
        entities.addEntity(explosionProjectile);
      }
    }
    if (entity instanceof PlayerProjectile || entity instanceof EnemyProjectile) {
      PVector randomDirection = PVector.random3D();
      PVector entityPosition = entity.getPosition().copy();
      Projectile explosionProjectile = new ExplosionProjectile(entityPosition, randomDirection);
      entities.addEntity(explosionProjectile);
    }
  }

  void naturalEnemySpawn() {
    int intialSpawnRate = 300;
    int spawnRateSpeedUp = difficultyLevel*5;
    int maximumSpawnRate = 60;
    int spawnRate = Math.max(maximumSpawnRate, intialSpawnRate - spawnRateSpeedUp);

    if (frameCount % spawnRate == 0) spawnEnemy();
  }

  void runWorldTime() {
    gameTime++;
    player.incrementShootTimer();
    entities.incrementEnemyShootTimers();
  }

  void resetWorld() {
    if (gameOver) {
      gameTime = 0;
      for (Entity e : entities.getEntities()) {
        if (!(e instanceof ExplosionProjectile)) e.destroy();
      }
      difficultyLevel = -1;
      handleDestruction();
      initWorld();
    }
  }


  void increaseScore() {
    playerScore++;
    if (playerScore > highScore) highScore = playerScore;
  }

  void displayScore() {
    if (!gameOver && !perspectiveLerp && !orthographicLerp) {
      String text = "Score: " + playerScore;
      pushMatrix();
      fill(0);
      scale(1, -1);
      textSize(3);
      if (projectionMode == ProjectionMode.ORTHOGRAPHIC_PROJECTION) {
        text(text, 0, 0, 10);
      } else {
        translate(1000, -400, 5);
        text(text, 0, 0, 0);
      }
      popMatrix();
    }
  }

  void promptPlayAgain() {
    if (gameOver) {
      pushMatrix();
      fill(red);
      scale(0.02, -0.02);
      textSize(72);
      text("Press 'Enter' to Respawn", -355, 0, 10);
      popMatrix();
    }
  }
}
