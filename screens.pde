float instruc_x, instruc_y;
float title_x, title_y;
int instruc_change = 1;
int counter;

int introtime = 6*1000;
int maxtime = 20*1000;
int starttime = 1500;
int pushtime = 1500;

int pantime = 1000;
int blenderdowntime = 1000;
int tutorialtime = 12*1000;
int[] tutorialtimes = new int[]{3000,4000,5000};
int tutx,tuty;
int goalshowtime = 3*1000;
int goalpantime = 3*1000;

float blendercoef = 0; //for making the blender poof down

float goalheight;
float goalwidth;
int goalsize = 100;
int playeroffset = 200; //for panning up/down
float offset;
  
int blendx;
int blendy;

int[] bcolor = new int[]{242,255,226};

int lastframetime;

void startscreen_setup(){
  title_x = width/2-title.width/2;
  title_y = 100;
  
  instruc_x = width/2-instruc.width/2;
  instruc_y = height*3/4;
}

void gamescreen_setup(){
  blendx = width/2-blender.width/2-10;
  blendy = height-blender.height-300;
  blendercoef = (float)(blendy+blender.height)/(float)(blenderdowntime*blenderdowntime);
  tutx = width/2+50;
  tuty = 100;
}

void startscreen(){
  backgrounddraw(0);
  if(instruc_y < height*3/4-5 || instruc_y > height*3/4+5) instruc_change *= -1;
  instruc_y += instruc_change;
  
  pushMatrix();
  translate(title_x+title.width/2, title_y+title.height/2);
  rotate(counter*TWO_PI/360);
  image(title_bg, -title_bg.width/2, -title_bg.height/2);
  popMatrix();
  counter++;
 
  //imageCenter(title_bg, title_x+title.width/2, title_y+title.height/2);
  image(title, title_x, title_y,title.width,title.height);
  image(instruc, instruc_x, instruc_y,instruc.width,instruc.height);

  playerdraw(0);
  
  if (carrotdown && carrotmeterstart != 0){
    carrotmeter = min(millis()-carrotmeterstart,pushtime);
  }if (daikondown && daikonmeterstart != 0){
    daikonmeter = min(millis()-daikonmeterstart,pushtime);
  }
  
  if (carrotmeter >= pushtime && daikonmeter >= pushtime){
    mode = "intro";
    timer = 0;
    timestart = millis();
    offset = 0;
    goalheight = 0;
    goalwidth = 0;
    lastframetime = millis();
    counter = 0;
  }
  meterdraw(0);
}

void introscreen(){
  //timer = timer + 1;
  timer = millis()-timestart;
  float blendery=blendy;
  int d = -1;
  
  //this is the worst way to do an if statement for timing :^)
  
  if (timer < pantime){
    offset = offset + ((float)playeroffset/(float)pantime) * (millis()-lastframetime);
    blendery = -blender.height; //off screen
  }else if (timer < pantime+blenderdowntime){
    offset = playeroffset;
    blendery = -blender.height+blendercoef*(timer-pantime)*(timer-pantime);
  }else if (timer < pantime+blenderdowntime+tutorialtime){
    offset = playeroffset;
    int timetillnow = pantime+blenderdowntime;
    int t = timer-timetillnow;
    if (t < tutorialtimes[0]){
      d = 0;
    }else if (t < tutorialtimes[0]+tutorialtimes[1]){
      d = 1;
    }else{
      d = 2;
    }
  }else if (timer < pantime+blenderdowntime+tutorialtime+goalshowtime){
    d=3;
    offset = playeroffset;
    goalheight=0;
    goalwidth = 150;
  }else if (timer < pantime+blenderdowntime+tutorialtime+goalshowtime+goalpantime){
    d=4;
    offset = playeroffset;
    goalheight = goalheight + ((float)(goalsize)/(float)goalpantime) * (millis()-lastframetime);
    goalheight = min(goalsize, goalheight);
    goalwidth = goalwidth + ((float)(width)/(float)goalpantime) * (millis()-lastframetime);
    goalwidth = min(width, goalwidth);
  }else{
    d=4;
    offset = playeroffset;
    goalheight = goalsize;
    goalwidth = width;
    timer = 0;
    timestart = millis();
    mode = "play";
  }
  
  backgrounddraw(offset);
  playerdraw(offset);
  image(blender,blendx,blendery);
  
  lastframetime = millis();
  if (d>2){
    if (goalwidth != width){
      tint((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2]);
      float x = width/2-star.width/2-25;
      float y = height/3-goalheight*8;
      
      pushMatrix();
      translate(x+star.width/2, y+star.height/2);
      rotate(counter*TWO_PI/720);
      image(star, -star.width/2, -star.height/2);
      popMatrix();
      counter++;
      
      tint(255);
    }
    if (d>3){
      goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalheight, width);
    }
      
  }  
  
  if (d>=0){
    image (dump[d],50,height/4);
    image (tut[d],tutx,tuty);
  }

}

void gamescreen(){
  
  //timer = timer + 1;
  timer = millis()-timestart;
    
  if (carrotstate > -1){
    carrotstate += .025;
    if (carrotstate > 1){
      carrotstate = -1;
    }
  }
  if (daikonstate > -1){
    daikonstate += .025;
    if (daikonstate > 1){
      daikonstate = -1;
    }
  }
  
  backgrounddraw(playeroffset);
  
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalsize,width);
    
  progress();
  
  tint(#f2ffe2);
  image(blender_mask,blendx,blendy-5);
  tint(255);
  
  image(ground_back,width/2-ground_back.width/2,height/2+offset);
  
  image(blender_empty,blendx,blendy);
  
  carrotdraw();
  daikondraw();
  
  playerdraw(playeroffset);
  
  timerdraw((float)maxtime);
  
  fill(255);
  textFont(fonts, 50);
  textAlign(LEFT,TOP);
  text("Mix this color!", 50, 25);
  textAlign(RIGHT,TOP);
  text("Mix this color!", width-50, 25);
  
  if (timer > maxtime){
    mode = "end";
    carrotmeterstart = 0;
    daikonmeterstart = 0;
  }
}

void endscreen(){
  backgrounddraw(playeroffset);
  playerdraw(playeroffset);
  
  result();
  
  if (carrotdown && carrotmeterstart != 0){
    carrotmeter = min(millis()-carrotmeterstart,pushtime);
  }if (daikondown && daikonmeterstart != 0){
    daikonmeter = min(millis()-daikonmeterstart,pushtime);
  }
  
  if (carrotmeter >= pushtime){
    reset();
    timer = 0;
    timestart = millis() - (pantime+blenderdowntime+tutorialtime);
    mode = "intro";
    carrotmeterstart = 0;
    daikonmeterstart = 0;
  }if (daikonmeter >= pushtime){
    mode = "start";
    timer = 0;
    reset();
  }
  meterdraw(playeroffset);
}
