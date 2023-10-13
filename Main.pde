final int QUADRANT_SIZE = 5;

World world;
WorldEvents events;
EntityList entities;

PVector playerOrigin;
float worldBoundaryX;
float worldBoundaryY1;
float worldBoundaryY2;

enum PlayerDirection {
  MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_DOWN,
    MOVE_UP
}

ProjectionMode projectionMode;

void setup() {
  size(1920, 1080, P3D);
  colorMode(RGB, 1.0f);
  textureMode(NORMAL);
  textMode(SHAPE);  
  loadTextures();
  loadColours();
  projectionMode = ProjectionMode.ORTHOGRAPHIC_PROJECTION;
  setupPOGL();
  setupProjections();
  resetMatrix();
  pushMatrix();
  setProjection(projectOrtho);
  setCamera(new PVector(0, ORTHOGRAPHIC_CAMERA_EYE_Y, ORTHOGRAPHIC_CAMERA_EYE_Z));
  initPlayerInputs();
  entities = new EntityList();
  events = new WorldEvents();
  world = new World();
  worldBoundaryX = 2*QUADRANT_SIZE;
  worldBoundaryY1 = QUADRANT_SIZE;
  worldBoundaryY2 = -QUADRANT_SIZE;
}

void draw() {
  background(darkGrey);
  world.runWorld();
  world.drawWorld();
}
