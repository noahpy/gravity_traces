int dynamic_count = 5;
int fixed_count = 0;

float cr = 2;

float fixed[][] = new float[100][2];
float dynamic[][] = new float[dynamic_count][2];
float v[][] = new float[dynamic_count][2];

float G = 30;
float R = 1;

boolean touch_enabled = false;
boolean tracing = true;
boolean random_init = false;
boolean circle_mode = true;

float dp = TWO_PI / dynamic_count;
float phi = 0;
float r, startx, starty;
float iva = 5;
float offset = 0;

void setup() {
  background (0);
  r = width/3;
  startx = width/2;
  starty = height/2;

  if (!circle_mode) {
    if (random_init) {
      for (int i=0; i<dynamic_count; i++) {
        v[i][0] = random(-G/6, G/6);
        v[i][1] = random(-G/6, G/6);
      }
    } else {
      v[0][0] = 1;
      v[0][1] = 1;
      v[1][0] = -1;
      v[1][1] = -1;
    }

    dynamic[0][0] = width/3;
    dynamic[0][1] = height/3;
    dynamic[1][0] = width/3*2;
    dynamic[1][1] = height/3;
    dynamic[2][0] = width/3;
    dynamic[2][1] = height/3*2;
    dynamic[3][0] = width/3;
    dynamic[3][1] = height/3*2;
  } else {
    for (int i = 0; i < dynamic_count; i++) {  
      float dx = sin(phi) * r;
      float dy = cos(phi) * r;
      dynamic[i][0] = startx + dx;
      dynamic[i][1] = starty + dy;
      v[i][0] = sin(TWO_PI-(PI/2-phi)+offset) * iva;
      v[i][1] = cos(TWO_PI-(PI/2-phi)+offset) * iva;
      phi += dp;
    }
  }

  fixed[0][0] = width/2;
  fixed[0][1] = height/2;
  fixed[1][0] = width/2;
  fixed[1][1] = height/3*2;
  fixed[2][0] = width/3*2;
  fixed[2][1] = height/3*2;
}




void draw() {
  if (!tracing) {
    background(0);
  }
  stroke(255);
  strokeWeight(10);

  for (int i = 0; i < fixed_count; i++) {  
    for (int j=0; j<dynamic_count; j++) {
      float d = pow((dynamic[j][0] - fixed[i][0]), 2)
        + pow((dynamic[j][1] - fixed[i][1]), 2);
      if (abs(d)<1) {
        d = 1;
      }
      v[j][0] = v[j][0] + (fixed[i][0] - dynamic[j][0]) * G / d;
      v[j][1] = v[j][1] + (fixed[i][1] - dynamic[j][1]) * G / d;
    }
    fill(255, 0, 0);
    ellipse(fixed[i][0], fixed[i][1], cr, cr);
  }
  for (int i=0; i<dynamic_count; i++) {
    fill(255);
    ellipse(dynamic[i][0], dynamic[i][1], cr, cr);
    for (int j=0; j<dynamic_count; j++) {
      if (i != j) {
        float d = pow((dynamic[j][0] - dynamic[i][0]), 2)
          + pow((dynamic[j][1] - dynamic[i][1]), 2);
        if (abs(d)<1) {
          d = 1;
        }
        v[j][0] = v[j][0] + (dynamic[i][0] - dynamic[j][0]) * G / d;
        v[j][1] = v[j][1] + (dynamic[i][1] - dynamic[j][1]) * G / d;
      }
    }
  } 

  if (touch_enabled) {
    for (int i = 0; i < touches.length; i++) {  
      for (int j=0; j<dynamic_count; j++) {
        float d = pow((dynamic[j][0] - touches[i].x), 2)
          + pow((dynamic[j][1] - touches[i].y), 2);
        if (abs(d)<1) {
          d = 1;
        }
        v[j][0] = v[j][0] + (touches[i].x - dynamic[j][0]) * G / d;
        v[j][1] = v[j][1] + (touches[i].y - dynamic[j][1]) * G / d;
      }
    }
  }

  for (int j=0; j<dynamic_count; j++) {
    dynamic[j][0] += v[j][0];
    dynamic[j][1] += v[j][1];
  }
}
