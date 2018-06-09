import moonlander.library.*;

/* 
 * Code for starting a demo project
 *
 * Nothing extra except standard libraries
 * bundled with Processing 
 */

// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

int speed = height / 55;
int star_amount = 0;

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

Moonlander moonlander;

Star[] stars;

Spaceship spaceship;
 
void setup() {
  fullScreen();
  noCursor();
  frameRate(60);
  spaceship = new Spaceship();
  spaceship.img = loadImage("data/spaceship.png");
  
  spaceship.img.resize(130,130);

  // Your setup code
  stars = new Star[width / 8];
  
  for(int i = 0; i < stars.length; i++) {
    if (i % 5 == 0) {
      stars[i] = new Star(3);
    } else {
      stars[i] = new Star(int(random(1, 3)));
    }
  }

  moonlander = Moonlander.initWithSoundtrack(this, "./data/spacetravel.mp3", 141, 8);
  moonlander.start();
  smooth();
}


/*
 * Processing's drawing method
 */
void draw() {
  moonlander.update();
  background(9, 56, 90);
  int red = moonlander.getIntValue("red");
  int green = moonlander.getIntValue("green");
  int blue = moonlander.getIntValue("blue");
  
  for(int i = 0; i < stars.length; i++) {
    stars[i].color_r = red;
    stars[i].color_g = green;
    stars[i].color_b = blue;
    stars[i].display();
  }
  
  image(spaceship.img, spaceship.x, spaceship.y);
  
  if (spaceship.y < ((height / 2) - 65)) {
    spaceship.y += 10;
  } else {
    spaceship.move_horizontally();
  }
}

class Star {
  int layer;
  float size;
  int x;
  int y;
  int color_r;
  int color_g;
  int color_b;
  
  Star(int layer) {
    this.layer = layer;
    this.size = (int(random(1, 4) * layer));
    this.x = int(random(5, width));
    this.y = int(random(0, height));
    this.color_r = 255;
    this.color_g = 247;
    this.color_b = 93;
  }
  
  void display() {
    pushStyle();
    
    //Setup the style
    stroke(this.color_r, this.color_g, this.color_b);
    strokeWeight(this.size);
    
    int y = this.y - (speed * this.layer);
    
    if (y < -10) y = height + 10;
    
    this.y = y;
    
    point(this.x, y);
    popStyle();
  }
}

class CollidingObject {
  PImage img;
  float x;
  float y;
  float size_x;
  float size_y;
  
  CollidingObject(float x, float y, float size_x, float size_y) {
    this.img = new PImage();
    this.x = x;
    this.y = y;
    this.size_x = size_x;
    this.size_y = size_y;
  }
  
  void draw() {
    image(this.img, this.x, this.y);
  }
}

class Spaceship {
  PImage img;
  float x;
  float y;
  float direction;
  float destination;
  
  Spaceship() {
    this.img = new PImage();
    this.x = ((width / 2) - 65);
    this.y = 20;
    this.direction = -1;
    this.destination = ((width / 2) - 400);
  }
  
  void move_horizontally() {
    if (this.x <= (this.destination + 15) && this.direction == -1) {
      this.direction = 1;
      this.destination = ((width / 2) + 400);
    } else if (this.x >= (this.destination - 15) && this.direction == 1) {
      this.direction = -1;
      this.destination = ((width / 2) - 400);
    }
    
    this.x = lerp(this.x, this.destination, 0.05);
  }
  
  boolean is_colliding(CollidingObject co) {
    return true;
  }
}
