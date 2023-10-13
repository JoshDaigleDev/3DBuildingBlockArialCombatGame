class World {

  Landscape landscape;

  World() {
    landscape = new Landscape();
    events.initWorld();
  }

  void drawWorld() {
    landscape.drawLandscape();
    entities.drawEntities();
  }

  void runWorld() {
    entities.handleEntityMovement();
    entities.checkEntityCollisions();
    events.runWorldTime();
    events.checkEntityShooting();
    events.checkForEnemyDeaths();
    events.handleDestruction();
    events.naturalEnemySpawn();
    perspectiveLerp();
  }
}
