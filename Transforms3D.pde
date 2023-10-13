PMatrix3D projectOrtho, projectPerspective;

final int ORTHOGRAPHIC_CAMERA_EYE_Y = 0;
final int ORTHOGRAPHIC_CAMERA_EYE_Z = 12;

final int PERSPECTIVE_CAMERA_EYE_Y = -7;
final int PERSPECTIVE_CAMERA_EYE_Z = 12;

final int PERSPECTIVE_NEAR = 1;
final int PERSPECTIVE_FAR = -10;

boolean perspectiveLerp = false;
boolean orthographicLerp = false;
float aspectRatio;
float FOV;

float[] perspectiveValues;
float[] orthographicValues;

int step;

void setupProjections() {

  aspectRatio = (float)width / (float)height;
  FOV = PI/3;
  step = 0;

  ortho(-2*QUADRANT_SIZE, 2*QUADRANT_SIZE, QUADRANT_SIZE, -QUADRANT_SIZE);
  projectOrtho = getProjection();

  perspective(FOV, aspectRatio, PERSPECTIVE_NEAR, PERSPECTIVE_FAR);
  fixFrustumYAxis();
  projectPerspective = getProjection();

  orthographicValues = new float[16];
  perspectiveValues = new float[16];

  orthographicValues = projectOrtho.get(orthographicValues);
  perspectiveValues = projectPerspective.get(perspectiveValues);

  perspectiveLerp = false;
  orthographicLerp = false;
}

void setOrthoMode() {
  worldBoundaryX = 2*QUADRANT_SIZE;
  worldBoundaryY1 = QUADRANT_SIZE;
  worldBoundaryY2 = -QUADRANT_SIZE;
  playerOrigin = new PVector(0, -QUADRANT_SIZE/2, 0);
  if (doBonus) {
    orthographicLerp = true;
  } else {
    PVector eyeCenter = new PVector(0, ORTHOGRAPHIC_CAMERA_EYE_Y, ORTHOGRAPHIC_CAMERA_EYE_Z);
    setCamera(eyeCenter);
    setProjection(projectOrtho);
  }
}

void setPerspectiveMode() {
  worldBoundaryX = 2*QUADRANT_SIZE/1.3;
  worldBoundaryY1 = QUADRANT_SIZE;
  worldBoundaryY2 = -1.5*QUADRANT_SIZE;
  playerOrigin = new PVector(0, -QUADRANT_SIZE, 0);

  if (doBonus) {
    perspectiveLerp = true;
  } else {
    PVector eyeCenter = new PVector(0, PERSPECTIVE_CAMERA_EYE_Y, PERSPECTIVE_CAMERA_EYE_Z);
    setCamera(eyeCenter);
    setProjection(projectPerspective);
  }
}

void setCamera(PVector eyeCenter) {
  PVector cameraCenter = new PVector(0, 0, 0);
  PVector upVector = new PVector(0, 1, 0);

  camera(eyeCenter.x, eyeCenter.y, eyeCenter.z, cameraCenter.x, cameraCenter.y, cameraCenter.z, upVector.x, upVector.y, upVector.z);
}

void perspectiveLerp() {
  int numSteps = 90;
  PVector eyeCenter = null;
  float t = easeInOut((float)step/(float)numSteps);
  float lerpCY;
  float lerpCZ;
  float lerpP0;
  float lerpP5;
  float lerpP10;
  float lerpP11;
  float lerpP14;
  float lerpP15;

  if (perspectiveLerp) {
    lerpCY = lerp(ORTHOGRAPHIC_CAMERA_EYE_Y, PERSPECTIVE_CAMERA_EYE_Y, t);
    lerpCZ = lerp(ORTHOGRAPHIC_CAMERA_EYE_Z, PERSPECTIVE_CAMERA_EYE_Z, t);

    lerpP0 = lerp(orthographicValues[0], perspectiveValues[0], t);
    lerpP5 = lerp(orthographicValues[5], perspectiveValues[5], t);
    lerpP10 = lerp(orthographicValues[10], perspectiveValues[10], t);
    lerpP11 = lerp(orthographicValues[11], perspectiveValues[11], t);
    lerpP14 = lerp(orthographicValues[14], perspectiveValues[14], t);
    lerpP15 = lerp(orthographicValues[15], perspectiveValues[15], t);

    PMatrix3D lerpMatrix = new PMatrix3D(
      lerpP0, 0, 0, 0,
      0, lerpP5, 0, 0,
      0, 0, lerpP10, lerpP11,
      0, 0, lerpP14, lerpP15
      );

    setProjection(lerpMatrix);
    eyeCenter = new PVector(0, lerpCY, lerpCZ);
    setCamera(eyeCenter);
    step++;
    if (step >= numSteps) {
      perspectiveLerp = false;
      step = 0;
    }
  } else if (orthographicLerp) {
    lerpCY = lerp(PERSPECTIVE_CAMERA_EYE_Y, ORTHOGRAPHIC_CAMERA_EYE_Y, t);
    lerpCZ =  lerp(PERSPECTIVE_CAMERA_EYE_Z, ORTHOGRAPHIC_CAMERA_EYE_Z, t);

    lerpP0 = lerp(perspectiveValues[0], orthographicValues[0], t);
    lerpP5 = lerp(perspectiveValues[5], orthographicValues[5], t);
    lerpP10 = lerp(perspectiveValues[10], orthographicValues[10], t);
    lerpP11 = lerp(perspectiveValues[11], orthographicValues[11], t);
    lerpP14 = lerp(perspectiveValues[14], orthographicValues[14], t);
    lerpP15 = lerp(perspectiveValues[15], orthographicValues[15], t);

    PMatrix3D lerpMatrix = new PMatrix3D(
      lerpP0, 0, 0, 0,
      0, lerpP5, 0, 0,
      0, 0, lerpP10, lerpP11,
      0, 0, lerpP14, lerpP15
      );

    setProjection(lerpMatrix);
    eyeCenter = new PVector(0, lerpCY, lerpCZ);
    setCamera(eyeCenter);
    step++;
    if (step >= numSteps) {
      setProjection(projectOrtho);
      orthographicLerp = false;
      step = 0;
    }
  }
}

enum ProjectionMode {
  ORTHOGRAPHIC_PROJECTION,
    PERSPECTIVE_PROJECTION
}

ProjectionMode getNextPojectionMode() {
  int nextProjectionMode = getNextOrdinal(projectionMode, ProjectionMode.values().length);
  projectionMode = ProjectionMode.values()[nextProjectionMode];
  return projectionMode;
}

int getNextOrdinal(Enum e, int enumLength) {
  return (e.ordinal() + 1) % enumLength;
}


float easeInOut(float t) {
  return 0.5*(1-cos(PI*t));
}
