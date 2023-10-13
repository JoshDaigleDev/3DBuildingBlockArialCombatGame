public class EntityList {
  
  final int ENTITY_Z_LEVEL = 6;

  ArrayList<Entity> entities;
  boolean newEnemyDeath;

  public EntityList() {
    entities = new ArrayList<Entity>();
    newEnemyDeath = false;
  }

  ArrayList<Enemy> getEnemies() {
    ArrayList<Enemy> enemies = new ArrayList<Enemy>();
    for (Entity entity : entities) {
      if (entity instanceof Enemy) {
        enemies.add((Enemy)entity);
      }
    }
    return enemies;
  }

  void addEntity(Entity newEntity) {
    entities.add(newEntity);
  }

  Entity getEntity(int index) {
    return entities.get(index);
  }

  ArrayList<Enemy> nextEnemyShooters() {
    ArrayList<Enemy> nextEnemyShooters = new ArrayList<Enemy>();
    ArrayList<Enemy> enemies = getEnemies();
    for (int i = 0; i < enemies.size(); i++) {
      if (enemies.get(i).canShoot()) {
        nextEnemyShooters.add(enemies.get(i));
        enemies.get(i).resetShootTimer();
      }
    }
    return nextEnemyShooters;
  }

  void incrementEnemyShootTimers() {
    ArrayList<Enemy> enemies = getEnemies();
    for (Enemy e : enemies) {
      e.incrimentShootTimer();
    }
  }

  ArrayList<Entity> getEntities() {
    return entities;
  }

  void checkEntityCollisions() {
    for (int i = 0; i < entities.size(); i++) {
      for (int j = 0; j < entities.size(); j++) {
        if (i != j) {
          if (entities.get(i).collisionCheck(entities.get(j))) {
            if (!entities.get(i).isFriendly(entities.get(j))) {
              entities.get(i).destroy();
              entities.get(j).destroy();
            }
          }
        }
      }
    }
  }

  ArrayList<Entity> checkForDestruction() {
    ArrayList<Entity> destroyedEntities = new ArrayList<Entity>();
    for (int i = 0; i < entities.size(); i++) {
      if (!entities.get(i).isAlive()) {
        destroyedEntities.add(entities.get(i));
        if (entities.get(i) instanceof Enemy) {
          newEnemyDeath = true;
        }
        entities.remove(i);
      }
    }
    return destroyedEntities;
  }

  boolean checkForEnemyDeath() {
    boolean result = false;
    if (newEnemyDeath) {
      result = true;
      newEnemyDeath = false;
    }
    return result;
  }

  void drawEntities() {
    for (Entity entity : entities) {
      pushMatrix();
      if (entity instanceof ExplosionProjectile) {
        translate(entity.getPosition().x, entity.getPosition().y, ENTITY_Z_LEVEL + entity.getPosition().z);
      } else {
        translate(entity.getPosition().x, entity.getPosition().y, ENTITY_Z_LEVEL);
      }
      entity.drawEntity();
      popMatrix();
    }
  }

  void handleEntityMovement() {
    for (Entity entity : entities) {
      entity.handleMovement();
    }
  }

  void reset() {
    entities.clear();
  }

  int numExplosionProjectiles() {
    int numExplosionProjectiles = 0;
    for (Entity e : entities) {
      if (e instanceof ExplosionProjectile) {
        numExplosionProjectiles++;
      }
    }
    return numExplosionProjectiles;
  }

  String toString() {
    String result = "";
    for (Entity e : entities) {
      result += "Name: " + e.toString() + " Position: " + e.getPosition() + "\n";
    }
    return result;
  }
}
