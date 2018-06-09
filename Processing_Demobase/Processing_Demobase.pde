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

  moonlander = Moonlander.initWithSoundtrack(this, "./data/tekno_127bpm.mp3", 127, 4);
  moonlander.start();
  smooth();
}


/*
 * Processing's drawing method
 */
void draw() {
  moonlander.update();
  background(0);
  image(spaceship.img, spaceship.x, spaceship.y);
  
  if (spaceship.y < ((height / 2) - 65)) {
    spaceship.y += 10;
  } else {
    spaceship.move_horizontally();
  }
  
  for(int i = 0; i < stars.length; i++) stars[i].display();
}

class Star {
  int layer;
  float size;
  int x;
  int y;
  int bright;
  
  Star(int layer) {
    this.layer = layer;
    this.size = (int(random(1, 4) * layer));
    this.x = int(random(5, width));
    this.y = int(random(0, height));
    this.bright = int(random(204, 255));
  }
  
  void display() {
    pushStyle();
    
    //Setup the style
    stroke(bright);
    strokeWeight(size);
    
    int y = this.y - (speed * this.layer);
    
    if (y < -10) y = height + 10;
    
    this.y = y;
    
    point(this.x, y);
    popStyle();
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
  
  boolean is_colliding(PShape shape) {
    return true;
  }
    
}
