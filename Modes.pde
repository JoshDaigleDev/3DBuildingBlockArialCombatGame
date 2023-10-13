final char KEY_VIEW = 'r'; // switch between orthographic and perspective views

final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';

final char KEY_TEXTURE = 't';
final char KEY_COLLISION = 'c';
final char KEY_PERFORMANCE = 'p';
final char KEY_BONUS = 'b';
final char NEW_GAME = ENTER;

boolean doBonus = true;
boolean doTextures = true;
boolean doCollision = true;
boolean performanceMode = false;

boolean playerShoot;
boolean playerMoveLeft;
boolean playerMoveRight;
boolean playerMoveDown;
boolean playerMoveUp;

void initPlayerInputs() {
  playerShoot = false;
  playerMoveLeft = false;
  playerMoveRight = false;
  playerMoveDown = false;
  playerMoveUp = false;
}

void keyPressed() {
  if (key == KEY_VIEW) {
    if (!perspectiveLerp && !orthographicLerp) {
      switch(getNextPojectionMode()) {
      case ORTHOGRAPHIC_PROJECTION:
        setOrthoMode();
        break;
      case PERSPECTIVE_PROJECTION:
        setPerspectiveMode();
        break;
      }
    }
  }
  if (key == KEY_SHOOT) playerShoot = true;
  if (key == KEY_LEFT) playerMoveLeft = true;
  if (key == KEY_RIGHT) playerMoveRight = true;
  if (key == KEY_DOWN) playerMoveDown = true;
  if (key == KEY_UP) playerMoveUp = true;
  if (key == KEY_COLLISION) doCollision = !doCollision;
  if (key == KEY_TEXTURE) doTextures = !doTextures;
  if (key == KEY_BONUS) doBonus = !doBonus;
  if (key == KEY_PERFORMANCE) performanceMode = !performanceMode;
  if (key == NEW_GAME) events.resetWorld();
}

void keyReleased() {
  if (key == KEY_SHOOT) playerShoot = false;
  if (key == KEY_LEFT) playerMoveLeft = false;
  if (key == KEY_RIGHT) playerMoveRight = false;
  if (key == KEY_DOWN) playerMoveDown = false;
  if (key == KEY_UP) playerMoveUp = false;
}
