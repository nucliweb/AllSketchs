int seed = int(random(999999999));

PShader noi;
float time = 0;
float timeView = random(2, 3);

void setup() {
  size(1080, 1920, P2D);
  smooth(4);
  //pixelDensity(2);  
  frameRate(2);
  noCursor();
  noi = loadShader("noiseShadowFrag.glsl", "noiseShadowVert.glsl");

  generate();
}

void draw() {
  time += 1;
  if (time > timeView) {
    time = 0;
    timeView = int(random(10, 30));
    seed = int(random(999999999));
  }


  generate();
}

void keyPressed() {
  if (key == 's') saveImage();
  else {
    seed = int(random(999999999));
    //generate();
  }
}

void generate() {

  noiseSeed(seed);
  randomSeed(seed);

  background(rcol());
  strokeWeight(1);
  
  /*
  translate(width*0.5, height*0.5);
  scale(2.2+cos(random(TAU)+millis()*random(0.0001)));
  translate(-width*0.5, -height*0.5);
  */

  int grid = int(height*1./pow(2, int(random(4, 12))));
  float gs = height*1./grid;
  stroke(rcol(), 120);
  for (int j = 0; j < grid; j++) {
    for (int i = 0; i < grid; i++) {
      rect(i*gs, j*gs, gs, gs);
    }
  }

  strokeWeight(1.2);



  int cccc = int(random(80, random(120, 200))*0.6);
  for (int c = 0; c < cccc; c++) {
    float x = random(width);
    float y = random(height);
    float s = width*random(1.6)*random(1)*random(1)*random(0.8, 1);

    if (random(1) < 0.4) {
      x -= x%gs;
      y -= y%gs;
    }

    float s1 = random(s*0.5, s);
    fill(rcol());
    ellipse(x, y, s1, s1);

    noStroke();
    arc2(x, y, s1, s1*1.2, 0, TAU, rcol(), 30, 0);

    float a = random(TAU);
    int ca = int(random(80));
    for (int i = 0; i < ca; i++) {
      float da = i*0.026;
      arc2(x, y, s1+1, s1*1.08, a+da, a+0.02+da, rcol(), 180, 240);
    }

    int cc = 100;
    fill(0);
    noStroke();
    for (int i = 0; i < cc; i++) {
      float ang = random(TAU);
      float dis = s1*atan(random(1))*0.5;
      float xx = x+cos(ang)*dis;
      float yy = y+sin(ang)*dis;
      float ss = random(1.6, 2.2);
      circle(xx, yy, ss, ss);
    }


    float s2 = random(s1);
    fill(rcol());
    ellipse(x, y, s2, s2);

    noStroke();
    arc2(x, y, s2, s2*1.2, 0, TAU, rcol(), 12, 0);

    /*
    int cc = int(random(1, 6));
     for (int j = 0; j < cc; j++) {
     float a1 = random(TWO_PI);
     float a2 = a1+random(TWO_PI)*random(1);
     noStroke();
     if (random(1) < 0.5) arc(x, y, s, a1, a2, rcol(), 255, 0);
     if (random(1) < 0.5) arc2(x, y, random(s), random(2), a1, a2, rcol(), 255, 0);
     }
     */

    noFill();
    int ccc = int(random(2, random(2, 60)));
    float a1 = random(TWO_PI);
    float amp = random(TWO_PI);
    float da = amp/ccc;
    stroke(rcol());
    for (int i = 0; i < ccc; i++) {
      float ang = a1+da*i;
      arc(x, y, s, s, ang, ang+da*random(1));
    }
  }
}
void arc(float x, float y, float s, float a1, float a2, int col, float alp1, float alp2) {
  float r = s*0.5;
  float amp = (a2-a1)%TWO_PI;
  float ma = map(amp, 0, TWO_PI, 0, 1);
  int cc = max(1, int(r*PI*ma));
  float da = amp/cc;
  for (int i = 0; i < cc; i++) {
    float ang = a1+da*i;
    beginShape();
    fill(col, alp1);
    vertex(x, y);
    fill(col, alp2);
    vertex(x+cos(ang)*r, y+sin(ang)*r);
    vertex(x+cos(ang+da)*r, y+sin(ang+da)*r);
    endShape(CLOSE);
  }
}

void arc2(float x, float y, float s1, float s2, float a1, float a2, int col, float alp1, float alp2) {
  float r1 = s1*0.5;
  float r2 = s2*0.5;
  float amp = (a2-a1);
  float ma = map(amp, 0, TWO_PI, 0, 1);
  int cc = max(1, int(max(r1, r2)*PI*ma));
  float da = amp/cc;
  for (int i = 0; i < cc; i++) {
    float ang = a1+da*i;
    beginShape();
    fill(col, alp1);
    vertex(x+cos(ang)*r1, y+sin(ang)*r1);
    vertex(x+cos(ang+da)*r1, y+sin(ang+da)*r1);
    fill(col, alp2);
    vertex(x+cos(ang+da)*r2, y+sin(ang+da)*r2);
    vertex(x+cos(ang)*r2, y+sin(ang)*r2);
    endShape(CLOSE);
  }
}

void circle(float x, float y, float s1, float s2) {
  float r1 = s1*0.5;
  float r2 = s2*0.5;
  int cc = max(1, int(max(r1, r2)*PI));
  float da = TAU/cc;
  beginShape(QUADS);
  for (int i = 0; i < cc; i++) {
    float ang = da*i;
    vertex(x+cos(ang)*r1, y+sin(ang)*r1);
    vertex(x+cos(ang+da)*r1, y+sin(ang+da)*r1);
    vertex(x+cos(ang+da)*r2, y+sin(ang+da)*r2);
    vertex(x+cos(ang)*r2, y+sin(ang)*r2);
  }
  endShape(CLOSE);
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  saveFrame(timestamp+".png");
}

//int colors[] = {#100D93, #DF390C};
int colors[] = {#80CCE9, #2C62B3, #2EBF40, #FDEB02, #F84D1E, #FFFFFF};
int rcol() {
  return colors[int(random(colors.length))];
}
int getColor(float v) {
  v = abs(v);
  v = v%(colors.length); 
  int c1 = colors[int(v%colors.length)]; 
  int c2 = colors[int((v+1)%colors.length)]; 
  return lerpColor(c1, c2, v%1);
}
