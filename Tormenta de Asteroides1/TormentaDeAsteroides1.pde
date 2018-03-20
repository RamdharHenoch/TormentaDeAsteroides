
import processing.video.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;


Box2DProcessing box2d;

Box box;

ArrayList<Particle> particles;

Spring spring;

float xoff = 0;
float yoff = 1000;

PImage asteroide;
PImage nave;
PImage titulo;
PImage pierde;

int lifep1=10;
int pantallas;


Movie movie;
SoundFile file;

void setup() {
  size(600, 340);
  smooth();

  movie = new Movie(this, "fondo.mp4");
  movie.loop();

  file = new SoundFile(this, "music.mp3");
  file.loop();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  box2d.setGravity(0, -10);


  box2d.listenForCollisions();

  box = new Box(width/2, height/2);

  spring = new Spring();
  spring.bind(width/2, height/2, box);

  particles = new ArrayList<Particle>();


  asteroide= loadImage("asteroide.png");
  nave= loadImage("nave.png");
  titulo= loadImage("titulo.png");
  pierde= loadImage("pierde.png");
 
}

void draw() {
  switch(pantallas) {
  case 0:
   inicio();
    break;
  case 1:
  juego();
    break;
  case 2:
  gameover();
    break;
  }

}
void inicio(){
  
  background (0);
  pushMatrix();
  
  titulo = loadImage("titulo.png");
    image(titulo, 0, 0);
  image(titulo, -100, 0);
  popMatrix(); 
 
 pushMatrix();
 
  textSize(15);
  fill(random(0, 255));
  text("Esquiva el mayor número de asteroides antes de quedarte sin vidas", 50, 260);
  text("Presiona A para jugar", 230, 290);
  text("Presiona la nave para moverla",200,320);
  popMatrix();

  keyPressed();
  if (key == 'a') {
    pantallas = 1;
  } 
}


void juego(){
  
 
  
println (lifep1);
  image(movie, 0, 0);

 pushMatrix();
 
  textSize(30);
  fill(random(0, 255));
  text(lifep1, 310, 300);
  text("Vida:", 210, 300);
  
  popMatrix();

  if (random(1) < 0.2) {
    float sz = random(4, 8);
    particles.add(new Particle(width/2, -20, sz));
  }


  box2d.step();

  float x = noise(xoff)*width;
  float y = noise(yoff)*height;
  xoff += 0.01;
  yoff += 0.01;

  if (mousePressed) {
    spring.update(mouseX, mouseY);
    spring.display();
  } else {
    spring.update(x, y);
  }
  box.body.setAngularVelocity(0);

  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    if (p.done()) {
      particles.remove(i);
    }
  }

  box.display();
  
  if(lifep1<=0){
    pantallas=2;
    
  }
  
  
}

void gameover(){
  background (0);
  
    pushMatrix();
  scale(0.7);
  pierde = loadImage("pierde.png");
  image(pierde, 50, 0);
  popMatrix(); 
 pushMatrix();
  textSize(18);
  fill(random(0, 100));
  text("Presiona S para jugar de nuevo", 160, 250);
  popMatrix();

  keyPressed();
  if (key == 's') {
    pantallas = 0;
    lifep1=10;
  } 
  
}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Box.class) {
    Particle p = (Particle) o2;
    p.change();
    lifep1= lifep1-1;
  } 
  else if (o2.getClass() == Box.class) {
    Particle p = (Particle) o1;
    p.change();
    lifep1= lifep1-1;
  }
}


void endContact(Contact cp) {
}

void movieEvent(Movie movie) {
  movie.read();
}