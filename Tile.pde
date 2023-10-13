class Tile {
  final int tileSize = 1;
  final float treeSize = 0.5;
  final int treeHeight = 2;
  final float treeTopSize = 2;
  PImage topTexture;
  PImage bodyColour;
  color col;
  boolean barrier;
  boolean spawnTree;

  float scale;
  Tile(float size) {
    scale = size;
    spawnTree = false;
    barrier = false;
    if (size == tileSize) {
      topTexture = blue2x2;
      col = blue;
    } else if (size > tileSize && size <= 3) {
      topTexture = sand2x2;
      col = sand;
    } else if (size > 3 && size <= 10) {
      topTexture = green2x2;
      if ((int)random(1, 100) == 17 && scale < 5) {
        spawnTree = true;
      }
      col = green;
    } else if (size > 10 && size <= 14) {
      topTexture = darkGrey2x2;
      col = darkGrey;
    } else if (size < 24) {
      topTexture = lightGrey2x2;
      col = lightGrey;
    }
  }

  void drawTile() {
    fill(col);
    stroke(0);
    strokeWeight(1);
    beginShape(QUADS);
    if (!barrier && doTextures) texture(topTexture);

    vertex(0, 0, tileSize, 0, 0);
    vertex(0, tileSize, tileSize, tileSize, 0);
    vertex(tileSize, tileSize, tileSize, tileSize, tileSize);
    vertex(tileSize, 0, tileSize, 0, tileSize);
    endShape();

    beginShape(QUADS);
    vertex(tileSize, 0, tileSize, 0, 0);
    vertex(tileSize, 0, 0, 0, tileSize);
    vertex(tileSize, tileSize, 0, tileSize, tileSize);
    vertex(tileSize, tileSize, tileSize, tileSize, 0);
    
    vertex(0, 0, 0, tileSize, tileSize);
    vertex(0, 0, tileSize, tileSize, 0);
    vertex(0, tileSize, tileSize, 0, 0);
    vertex(0, tileSize, 0, 0, tileSize);
    
    vertex(tileSize, 0, tileSize, 0, 0);
    vertex(0, 0, tileSize, tileSize, 0);
    vertex(0, 0, 0, tileSize, tileSize);
    vertex(tileSize, 0, 0, 0, tileSize);
    
    vertex(0, tileSize, tileSize, 0, 0);
    vertex(tileSize, tileSize, tileSize, tileSize, 0);
    vertex(tileSize, tileSize, 0, tileSize, tileSize);
    vertex(0, tileSize, 0, 0, tileSize);
    
    vertex(tileSize, 0, 0, 0, 0);
    vertex(0, 0, 0, tileSize, 0);
    vertex(0, tileSize, 0, tileSize, tileSize);
    vertex(tileSize, tileSize, 0, 0, tileSize);
    
    endShape();
    if (spawnTree) {
      pushMatrix();
      translate(0.5, 0.5, scale/4);
      drawTree();
      popMatrix();
    }
  }

  void drawTree() {
    fill(brown);
    beginShape(QUADS);
    
    vertex(treeSize, 0, treeHeight*treeSize, 0, 0);
    vertex(treeSize, 0, 0, 0, treeSize);
    vertex(treeSize, treeSize, 0, treeSize, treeSize);
    vertex(treeSize, treeSize, treeHeight*treeSize, treeSize, 0);

    vertex(0, 0, 0, treeSize, treeSize);
    vertex(0, 0, treeHeight*treeSize, treeSize, 0);
    vertex(0, treeSize, treeHeight*treeSize, 0, 0);
    vertex(0, treeSize, 0, 0, treeSize);

    vertex(treeSize, 0, treeHeight*treeSize, 0, 0);
    vertex(0, 0, treeHeight*treeSize, treeSize, 0);
    vertex(0, 0, 0, treeSize, treeSize);
    vertex(treeSize, 0, 0, 0, treeSize);

    vertex(0, treeSize, treeHeight*treeSize, 0, 0);
    vertex(treeSize, treeSize, treeHeight*treeSize, treeSize, 0);
    vertex(treeSize, treeSize, 0, treeSize, treeSize);
    vertex(0, treeSize, 0, 0, treeSize);

    vertex(treeSize, 0, 0, 0, 0);
    vertex(0, 0, 0, treeSize, 0);
    vertex(0, treeSize, 0, treeSize, treeSize);
    vertex(treeSize, treeSize, 0, 0, treeSize);
    endShape();

    pushMatrix();
    translate(-1.5*treeSize, -1.5*treeSize, treeHeight/2);
    scale(1, 1, 1/(1+scale/4));
    stroke(0);
    fill(green);

    beginShape(QUADS);
    if(doTextures) texture(green4x4);
    vertex(0, 0, treeTopSize/2, 0, 0);
    vertex(0, treeTopSize, treeTopSize/2, 1, 0);
    vertex(treeTopSize, treeTopSize, treeTopSize/2, 1, 1);
    vertex(treeTopSize, 0, treeTopSize/2, 0, 1);
    endShape();
    
    beginShape(QUADS);
    vertex(treeTopSize, 0, treeTopSize/2, 0, 0);
    vertex(treeTopSize, 0, 0, 0, 1);
    vertex(treeTopSize, treeTopSize, 0, 1, 1);
    vertex(treeTopSize, treeTopSize, treeTopSize/2, 1, 0);

    vertex(0, 0, 0, 1, 1);
    vertex(0, 0, treeTopSize/2, 1, 0);
    vertex(0, treeTopSize, treeTopSize/2, 0, 0);
    vertex(0, treeTopSize, 0, 0, 1);

    vertex(treeTopSize, 0, treeTopSize/2, 0, 0);
    vertex(0, 0, treeTopSize/2, 1, 0);
    vertex(0, 0, 0, 1, 1);
    vertex(treeTopSize, 0, 0, 0, 1);

    vertex(0, treeTopSize, treeTopSize/2, 0, 0);
    vertex(treeTopSize, treeTopSize, treeTopSize/2, 1, 0);
    vertex(treeTopSize, treeTopSize, 0, 1, 1);
    vertex(0, treeTopSize, 0, 0, 1);

    vertex(treeTopSize, 0, 0, 0, 0);
    vertex(0, 0, 0, treeTopSize, 0);
    vertex(0, treeTopSize, 0, 1, 1);
    vertex(treeTopSize, treeTopSize, 0, 0, 1);
    endShape();
    popMatrix();
  }
}
