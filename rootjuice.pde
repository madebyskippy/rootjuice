import ddf.minim.*;
import processing.serial.*;

Minim minim;
AudioPlayer carrot_noise, daikon_noise;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

// ------------------------- make this true when the arduino is connected
boolean arduino = false;
// -------------------------

int[] colors = {255,127,80,175,225,175};

boolean carrotdown = false;
boolean daikondown = false;
float carrotstate = -1;
float daikonstate = -1;

int[] juice = {0,0};
int[] score = {0,0};

float[] juicecolor = {0,0,0};
float[] scorecolor = {0,0,0};

int timer;
int introtime = 200;
int maxtime = 800;
int starttime = 75;

PImage background;
PImage ground_back;
PImage ground_front;
PImage title, title_bg;
PImage instruc;
PImage[][] squatframes = new PImage[2][2];
PImage[] squatter = new PImage[2];
PImage bottle;
PImage basket;
PImage carrot;
PImage daikon;
PImage introtext;
PImage yourjuice;
PImage desiredjuice;
PImage blend;
PImage customer;
PImage server;
PImage order;

String mode; //start, intro, play, end

void setup(){
  println(Serial.list());
  if (arduino){
    String portName = Serial.list()[10];
    myPort = new Serial(this, portName, 9600);
  }
  frameRate(60);
  
  minim = new Minim(this);
  carrot_noise = minim.loadFile("pickup_coin.mp3");
  daikon_noise = minim.loadFile("pickup_coin2.mp3");
  
  background = loadImage("background.png");
  ground_back = loadImage("ground_back.png");
  ground_front = loadImage("ground_front.png");
  
  title = loadImage("title.png");
  title_bg = loadImage("title_bg.png");
  instruc = loadImage("instruc.png");
  
  basket = loadImage("blender.png");
  carrot = loadImage("carrot.png");
  daikon = loadImage("daikon.png");
  
  introtext = loadImage("introtext.png");
  
  customer = loadImage("customer.png");
  server = loadImage("server.png");
  order = loadImage("order.png");
  
  squatframes[0][0] = loadImage("csquat0.png");
  squatframes[0][1] = loadImage("csquat1.png");
  squatframes[1][0] = loadImage("dsquat0.png");
  squatframes[1][1] = loadImage("dsquat1.png");
  squatter[0] = squatframes[0][0];
  squatter[1] = squatframes[1][0];
  

  startscreen_setup();
  
  //size(1920,1080);
  fullScreen();
  reset();
}

void draw(){
  if (arduino){
    if ( myPort.available() > 0) {  // If data is available,
      val = myPort.read();         // read it and store it in val
      //val = 1, carrot up
      //val = 2, carrot down
      //val = 3, daikon up
      //val = 4, daikon down
      switch(val){
        case 1:
          carrotOut();
          break;
        case 2:
          carrotIn();
          break;
        case 3:
          daikonOut();
          break;
        case 4:
          daikonIn();
      }
      println(val);
    }
  }
  
  background(#f2ffe2);
  
  if (mode=="start"){
    //intro game and show instructions
    startscreen();
  }else if (mode == "intro"){
    introscreen();
  }else if (mode == "play"){
    //gameplay!
    gamescreen();
  }else if (mode == "end"){
    //results
    endscreen();
  }
}

void keyPressed() {
 if (key == 'a' || key == 'A') {
   //carrot
   carrotIn();
 } else if (key == 'l' || key == 'L') {
   //daikon
   daikonIn();
 } else if (key == 'r'){
   //reset
   reset();
 } else if (key == ' '){
 }
}

void keyReleased(){
  if (key == 'a' || key == 'A') {
   //carrot
   carrotOut();
 } else if (key == 'l' || key == 'L') {
   //daikon
   daikonOut();
 }if (key == ' '){
   if (mode == "start"){
     mode = "intro";
   }else if (mode == "play"){
     if (score[0]+score[1] > 0){
       mode = "end";
     }
   }else if (mode == "end"){
     reset();
   }
  }
}

void carrotIn(){
   if (!carrotdown){
     carrot_noise.rewind();
     carrot_noise.play();
   }
   if (mode == "play"){
     if (!carrotdown){
       score[0] ++;
       carrotstate = 0;
     }
   }
   carrotdown = true;
   squatter[0] = squatframes[0][1];
}
void carrotOut(){
   carrotdown = false;
   squatter[0] = squatframes[0][0];
}
void daikonIn(){
  if (!daikondown){
   daikon_noise.rewind();
   daikon_noise.play();
  }
  if (mode == "play"){
    if (!daikondown){
      score[1] ++;
      daikonstate = 0;
    }
  }
  daikondown = true;
  squatter[1] = squatframes[1][1];
}
void daikonOut(){
   daikondown = false;
   squatter[1] = squatframes[1][0];
}

void reset(){
  background(255);
  timer = 0;
  
  score[0] = 0;
  score[1] = 0;
  carrotstate = -1;
  daikonstate = -1;
  
  juice[0] = round(random(0,10));
  juice[1] = 10-juice[0];

  float percentagecarrot = (float)juice[0] / (float)(juice[0]+juice[1]);
  juicecolor[0] = colors[3]+(colors[0]-colors[3])*percentagecarrot; 
  juicecolor[1] = colors[4]+(colors[1]-colors[4])*percentagecarrot;
  juicecolor[2] = colors[5]+(colors[2]-colors[5])*percentagecarrot;
  
  noStroke();
  
  mode = "start";
}