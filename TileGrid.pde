class TileGrid {

  final int GRID_HEIGHT = 6 * QUADRANT_SIZE;
  int gridWidth;

  Tile[][] tiles;
  float[] scaleValues;
  float[][] terrain;

  TileGrid() {
    initTiles();
  }

  void initTiles() {
    if (performanceMode) {
      gridWidth = 4 * QUADRANT_SIZE;
    } else {
      gridWidth = 7 * QUADRANT_SIZE;
    }

    tiles = new Tile[gridWidth][GRID_HEIGHT];
    scaleValues = new float[gridWidth*GRID_HEIGHT];
    terrain = new float[gridWidth][GRID_HEIGHT];

    float smoothness = 0.05;
    for (int h = 0; h < GRID_HEIGHT; h++) {
      for (int w = 0; w < gridWidth; w++) {
        float noise = noise(w*smoothness, (noiseMemory + h)*smoothness);
        if (noise <= 0.34) {
          terrain[w][h] = 1; //blue
        } else if (noise > 0.34 && noise <= 0.37 ) {
          terrain[w][h] = 2; //sand
        } else if (noise > 0.37 && noise <= 0.40) {
          terrain[w][h] = 3; //sand
        } else if (noise > 0.40 && noise <= 0.46) {
          terrain[w][h] = 4; //green
        } else if (noise > 0.46 && noise <= 0.52) {
          terrain[w][h] = 5; //green
        } else if (noise > 0.52 && noise <= 0.55) {
          terrain[w][h] = 6; //green
        } else if (noise > 0.55 && noise <= 0.58) {
          terrain[w][h] = 7; //green
        } else if (noise > 0.58 && noise <= 0.61 ) {
          terrain[w][h] = 8; //green
        } else if (noise > 0.61 && noise <= 0.64) {
          terrain[w][h] = 10; //green
        } else if (noise > 0.64 && noise <= 0.70) {
          terrain[w][h] = 12; //grey
        } else if (noise > 0.70 && noise <= 0.76) {
          terrain[w][h] = 14; //grey
        } else {
          terrain[w][h] = 16; //light grey
        }
        if (!performanceMode) {
          int correctionAmt = (int)(noise(w*smoothness, (noiseMemory + h)*smoothness)+0.5);
          if (w == 0 || w == gridWidth-1 && terrain[w][h] < 5) {
            terrain[w][h] += correctionAmt+5;
          } else if (w == 1 || w == gridWidth-2 && terrain[w][h] < 5) {
            terrain[w][h] += correctionAmt+3;
          } else if (w == 2 || w == gridWidth-3 && terrain[w][h] < 5) {
            terrain[w][h] += correctionAmt+2;
          } else if (w == 3 || w == gridWidth-4 && terrain[w][h] < 5) {
            terrain[w][h] += correctionAmt+1;
          } else if (w == 4 || w == gridWidth-5 && terrain[w][h] < 5) {
            terrain[w][h] += correctionAmt;
          } else if (terrain[w][h] > 1) {
            terrain[w][h] -= 1;
          }
        }

        tiles[w][h] = new Tile(terrain[w][h]);
      }
    }
    noiseMemory += GRID_HEIGHT;
  }

  void drawTiles() {
    for (int w = 0; w < gridWidth; w++) {
      for (int h = 0; h < GRID_HEIGHT; h++) {
        pushMatrix();
        translate(w - gridWidth/2, h - GRID_HEIGHT/2);
        scale(1, 1, 1+terrain[w][h]/4);
        tiles[w][h].drawTile();
        popMatrix();
      }
    }
  }
}
