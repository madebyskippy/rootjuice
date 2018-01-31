float instruc_x, instruc_y;
float title_x, title_y;
int instruc_change = 1;
int counter;

int introtime = 250;
int maxtime = 800;
int starttime = 75;

int pantime = 100;
int goalshowtime = 50;
int goalpantime = 100;

float goalheight;
int goalsize = 100;
int playeroffset = 200; //for panning up/down
float offset;

int[] bcolor = new int[]{242,255,226};

void startscreen_setup(){
  title_x = width/2-title.width/2;
  title_y = height/3;
  
  instruc_x = width/2-instruc.width/2;
  instruc_y = title_y+200;
}

void startscreen(){
  backgrounddraw(0);
  if(instruc_y < title_y+200 || instruc_y > title_y+205) instruc_change *= -1;
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
  
  if (carrotdown && daikondown){
    timer += 1;
  }if (!carrotdown || !daikondown){
    timer = 0;
  }
  if (timer > starttime){
    mode = "intro";
    timer = 0;
    offset = 0;
    goalheight = 0;
  }
  
  timerdraw((float)starttime);
}

void introscreen(){
  timer = timer + 1;
  if (timer < pantime){
    offset = offset + ((float)playeroffset/(float)pantime);
  }else if (timer < pantime+goalshowtime){
    offset = playeroffset;
    goalheight=height;
  }else if (timer < pantime+goalshowtime+goalpantime){
    offset = playeroffset;
    goalheight = goalheight - (float)(height-goalsize)/(float)goalpantime;
  }
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalheight);
  backgrounddraw(offset);
  playerdraw(offset);
  
  image(introtext,width/2-introtext.width/2, 200);
  
  timerdraw((float)(introtime+pantime));
  
  if (timer > introtime+pantime){
    timer = 0;
    mode = "play";
  }
}

void gamescreen(){
  backgrounddraw(playeroffset);
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalsize);
  
  timer = timer + 1;
  timerdraw((float)maxtime);
    
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
    
  progress();
  carrotdraw();
  daikondraw();
  
  playerdraw(playeroffset);
  
  if (timer > maxtime){
    mode = "end";
  }
}

void endscreen(){
  backgrounddraw(playeroffset);
  playerdraw(playeroffset);
  
  gradientbar();
  
  if (carrotdown && daikondown){
    timer += 1;
  }if (!carrotdown || !daikondown){
    timer = 0;
  }
  if (timer > starttime){
    mode = "start";
    timer = 0;
    reset();
  }
  
  timerdraw((float)starttime);
}