int noiseMemory;

class Landscape {

  TileGrid t1, t2;
  float g1Pos, g2Pos, tileSpeed;


  public Landscape() {
    noiseMemory = 0;
    t1 = new TileGrid();
    t2 = new TileGrid();
    g1Pos = 0;
    g2Pos = 6*QUADRANT_SIZE;
    tileSpeed = 0.1;
  }

  void drawLandscape() {
    pushMatrix();
    translate(0, g1Pos);
    t1.drawTiles();
    popMatrix();

    pushMatrix();
    translate(0, g2Pos);
    t2.drawTiles();
    popMatrix();
    moveGrids();
    
    if(performanceMode) drawBackground();
  }

  void moveGrids() {
    g1Pos -= tileSpeed;
    g2Pos -= tileSpeed;
    if (g1Pos < -6*QUADRANT_SIZE) {
      g1Pos = 6*QUADRANT_SIZE;
      t1.initTiles();
    }
    if (g2Pos < -6*QUADRANT_SIZE) {
      g2Pos = 6*QUADRANT_SIZE;
      t2.initTiles();
    }
  }

  void drawBackground() {
    int z = -3;
    fill(darkGrey);
    beginShape();
    if (doTextures) texture(darkGrey40x40);
    vertex(7*QUADRANT_SIZE, 7*QUADRANT_SIZE, z, 0, 0);
    vertex(7*QUADRANT_SIZE, -7*QUADRANT_SIZE, z, 0, 1);
    vertex(-7*QUADRANT_SIZE, -7*QUADRANT_SIZE, z, 1, 1);
    vertex(-7*QUADRANT_SIZE, 7*QUADRANT_SIZE, z, 1, 0);
    endShape();
  }
}
