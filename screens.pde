float instruc_x, instruc_y;
float title_x, title_y;
int instruc_change = 1;
int counter;

int introtime = 350;
int maxtime = 800;
int starttime = 75;
int pushtime = 75;

int pantime = 100;
int blenderdowntime = 50;
int tutorialtime = 600;
int[] tutorialtimes = new int[]{200,200,200};
int tutx,tuty;
int goalshowtime = 150;
int goalpantime = 150;

float blendercoef = 0; //for making the blender poof down

float goalheight;
int goalsize = 100;
int playeroffset = 200; //for panning up/down
float offset;
  
int blendx;
int blendy;

int[] bcolor = new int[]{242,255,226};

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
  
  if (carrotdown){
    carrotmeter = min(carrotmeter+1,pushtime);
  }if (daikondown){
    daikonmeter = min(daikonmeter+1,pushtime);
  }
  
  if (carrotmeter >= pushtime && daikonmeter >= pushtime){
    mode = "intro";
    timer = 0;
    offset = 0;
    goalheight = 0;
  }
  
  meterdraw(0);
}

void introscreen(){
  timer = timer + 1;
  float blendery=blendy;
  int d = -1;
  
  //this is the worst way to do an if statement for timing :^)
  
  if (timer < pantime){
    offset = offset + ((float)playeroffset/(float)pantime);
    blendery = -blender.height; //off screen
  }else if (timer < pantime+blenderdowntime){
    blendery = -blender.height+blendercoef*(timer-pantime)*(timer-pantime);
  }else if (timer < pantime+blenderdowntime+tutorialtime){
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
    goalheight=height;
  }else if (timer < pantime+blenderdowntime+tutorialtime+goalshowtime+goalpantime){
    d=3;
    offset = playeroffset;
    goalheight = goalheight - (float)(height-goalsize)/(float)goalpantime;
  }else{
    d=3;
    offset = playeroffset;
    goalheight = goalsize;
    timer = 0;
    mode = "play";
  }
  
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalheight);
  backgrounddraw(offset);
  playerdraw(offset);
  image(blender,blendx,blendery);
  
  if (d>=0){
    image (dump[d],50,height/4);
    image (tut[d],tutx,tuty);
  }

}

void gamescreen(){
  
  timer = timer + 1;
    
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
  
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalsize);
    
  progress();
  
  tint(#f2ffe2);
  image(blender_mask,blendx,blendy-5);
  tint(255);
  image(mountains_mask,width/2-mountains_mask.width/2-3,height/2+27);
  
  image(ground_back,width/2-ground_back.width/2,height/2+offset);
  
  image(blender_empty,blendx,blendy);
  
  carrotdraw();
  daikondraw();
  
  playerdraw(playeroffset);
  
  timerdraw((float)maxtime);
  
  if (timer > maxtime){
    mode = "end";
  }
}

void endscreen(){
  backgrounddraw(playeroffset);
  playerdraw(playeroffset);
  
  result();
  
  if (carrotdown){
    carrotmeter = min(carrotmeter+1,pushtime);
  }if (daikondown){
    daikonmeter = min(daikonmeter+1,pushtime);
  }
  
  if (carrotmeter >= pushtime){// && daikonmeter >= pushtime){
    reset();
    timer = pantime+blenderdowntime+tutorialtime;
    mode = "intro";
  }if (daikonmeter >= pushtime){
    mode = "start";
    timer = 0;
    reset();
  }
  meterdraw(playeroffset);
}