color red;
color yellow;
color blue;
color green;
color lightGrey;
color darkGrey;
color playerGunColour;
color sand;
color brown;

color[] explosionColours;
color[] gunColours;

PImage[] gunTextures;
PImage[] explosionTextures;
PImage[] explosionTextureBottoms;

PImage playerGunTexture;
PImage redBottom1x1;
PImage red1x1;
PImage yellow1x1;
PImage yellowBottom1x1;
PImage lightGrey1x1;
PImage lightGreyBottom1x1;
PImage darkGrey1x1;
PImage darkGreyBottom1x1;
PImage green2x2;
PImage green4x4;
PImage blue2x2;
PImage sand2x2;
PImage lightGrey2x2;
PImage lightGrey2x6;
PImage lightGrey4x6;
PImage lightGrey2x10;
PImage lightGrey10x2;
PImage lightGrey6x2;
PImage darkGrey1x3;
PImage red1x3;
PImage yellow1x3;
PImage darkGrey3x1;
PImage darkGreyBottom3x1;
PImage darkGreyBottom1x3;
PImage darkGrey1x11;
PImage darkGrey11x1;
PImage darkGrey2x2;
PImage darkGrey20x20;
PImage darkGrey40x40;
PImage tinyTexture;

void loadColours() {
  red = color(cmMap(232.0), cmMap(2.0), cmMap(30.0));
  yellow = color(cmMap(240.0), cmMap(205.0), cmMap(63.0));
  blue = color(cmMap(37.0), cmMap(105.0), cmMap(228.0));
  green = color(cmMap(42.0), cmMap(163.0), cmMap(50.0));
  lightGrey = color(cmMap(196.0), cmMap(196.0), cmMap(196.0));
  darkGrey = color(cmMap(122.0), cmMap(122.0), cmMap(122.0));
  sand = color(cmMap(233), cmMap(209), cmMap(167));
  brown = color(cmMap(121), cmMap(81), cmMap(70));

  gunColours = new color[]{darkGrey, yellow, red};
  explosionColours = new color[] {lightGrey, darkGrey, red, yellow};
}

void loadTextures() {
  blue2x2 = loadImage("Blue2x2.png");
  green2x2 = loadImage("Green2x2.png");
  sand2x2 = loadImage("Sand2x2.png");
  green4x4 = loadImage("Green4x4.png");;
  lightGrey2x10 = loadImage("LightGrey2x10.png");
  lightGrey10x2 = loadImage("LightGrey10x2.png");
  lightGrey6x2 = loadImage("LightGrey6x2.png");
  darkGrey3x1 = loadImage("DarkGrey3x1.png");
  lightGrey4x6 = loadImage("LightGrey4x6.png");
  darkGrey1x11 = loadImage("DarkGrey1x11.png");
  darkGrey11x1 = loadImage("DarkGrey11x1.png");
  lightGrey2x6 = loadImage("LightGrey2x6.png");
  lightGrey2x2 = loadImage("LightGrey2x2.png");
  darkGrey2x2 = loadImage("DarkGrey2x2.png");
  darkGrey40x40 = loadImage("DarkGrey40x40.png");
  darkGrey1x3 = loadImage("DarkGrey1x3.png");
  red1x3 = loadImage("Red1x3.png");
  yellow1x3 = loadImage("Yellow1x3.png");
  lightGrey1x1 = loadImage("LightGrey1x1.png");
  darkGrey1x1 = loadImage("DarkGrey1x1.png");
  red1x1 = loadImage("Red1x1.png");
  redBottom1x1 = loadImage("RedBottom1x1.png");
  yellowBottom1x1 = loadImage("YellowBottom1x1.png");
  lightGreyBottom1x1 = loadImage("LightGreyBottom1x1.png");
  darkGreyBottom1x1 = loadImage("DarkGreyBottom1x1.png");
  darkGreyBottom1x3 = loadImage("DarkGreyBottom1x3.png");
  darkGreyBottom3x1 = loadImage("DarkGreyBottom3x1.png");
  yellow1x1 = loadImage("Yellow1x1.png");
  tinyTexture = loadImage("TinyTexture.png");
  gunTextures = new PImage[]{darkGrey1x3, yellow1x3, red1x3};
  explosionTextures = new PImage[]{lightGrey1x1, darkGrey1x1, red1x1, yellow1x1};
  explosionTextureBottoms = new PImage[]{lightGreyBottom1x1, darkGreyBottom1x1, redBottom1x1, yellowBottom1x1};
}


float cmMap(float val) {
  return map(val, 0.0, 255.0, 0.0, 1.0);
}
