float instruc_x, instruc_y;
float title_x, title_y;
int instruc_change = 1;
int counter;

void startscreen_setup(){
  title_x = width/2-title.width/2;
  title_y = height/3;
  
  instruc_x = width/2-instruc.width/2;
  instruc_y = title_y+200;
}

void startscreen(){
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
  
  playerdraw();
  
  if (carrotdown && daikondown){
    timer += 1;
  }if (!carrotdown || !daikondown){
    timer = 0;
  }
  if (timer > starttime){
    mode = "intro";
    timer = 0;
  }
  
  timerdraw((float)starttime);
}

void introscreen(){
  timer = timer + 1;
    
  bottledraw();
  playerdraw();
  
  image(introtext,width/2-introtext.width/2, 200,introtext.width,introtext.height);
  
  timerdraw((float)introtime);
  
  if (timer > introtime){
    timer = 0;
    mode = "play";
  }
}

void gamescreen(){
  timer = timer + 1;
  bottledraw();
  
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
    
  playerdraw();
  
  if (timer > maxtime){
    mode = "end";
  }
}

void endscreen(){
  playerdraw();
  //bottledraw();
  //result();
  
  feedback();
  
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



// -------------------------------- helper functions

void imageCenter(PImage img, float x, float y){
  imageMode(CENTER);
  image(img, x, y);
  imageMode(CORNER);
}

void progress(){
  noStroke();
  float total = score[0]+score[1];
  float h = 400/total;
  fill(colors[0],colors[1],colors[2]);
  for(int i=0; i<total; i++){
    if (i>=score[0]){
      fill(colors[3],colors[4],colors[5]);
    }
    rect(width/2-basket.width/2+20,height-basket.height-75+i*h,basket.width-60,h);
  }
  image(basket,width/2-basket.width/2-10,height-basket.height-100,basket.width,basket.height);
}

void result(){
  float percentagecarrot = (float)score[0] / (float)(score[0]+score[1]);
  scorecolor [0] = colors[3]+(colors[0]-colors[3])*percentagecarrot; 
  scorecolor [1] = colors[4]+(colors[1]-colors[4])*percentagecarrot;
  scorecolor [2] = colors[5]+(colors[2]-colors[5])*percentagecarrot;
  if (score[0] == 0 && score[1] == 0){
    scorecolor[0] = 255;
    scorecolor[1] = 255;
    scorecolor[2] = 255;
  }
  fill(scorecolor[0],scorecolor[1],scorecolor[2]);
  rect(width/2-basket.width/2+20,height-bottle.height-50-basket.height-50,basket.width-60,220);
  image(basket,width/2-basket.width/2-10,height-bottle.height-50-basket.height-100,basket.width,basket.height);
}

void feedback(){
  //float topcirclex = width/2 + basket.width/2-circle.width;
  //float topcircley = 100+basket.height-circle.height;
  //image(circle,topcirclex,topcircley,circle.width,circle.height);
  //float bottomcirclex = width/2 - bottle.width/2;
  //float bottomcircley = height-50-circle.height;
  //image(circle,bottomcirclex,bottomcircley,circle.width,circle.height);
  
  //int scarrot = round(((float)score[0]/(float)(score[0]+score[1]))*10);
  //int sdaikon = round(((float)score[1]/(float)(score[0]+score[1]))*10);
  
  //int carrotf = 0;
  //if (scarrot != juice[0]){
  //  if (scarrot > juice[0]){
  //    carrotf = 1;
  //  }
  //}else{
  //  carrotf = 2;
  //}
  //PImage f1 = feedback[0][carrotf];
  //image(f1,width/2-f1.width-200,height-squatter[0].height-150,f1.width,f1.height);
  //int daikonf = 0;
  //if (sdaikon != juice[1]){
  //  if (sdaikon > juice[1]){
  //    daikonf = 1;
  //  }
  //}else{
  //  daikonf = 2;
  //}
  //PImage f2 = feedback[1][daikonf];
  //image(f2,width/2+200,height-squatter[0].height-150,f2.width,f2.height);
  
  
  //tint(colors[0],colors[1],colors[2]);
  //image(numbs[scarrot],topcirclex+25,topcircley+37);
  //image(numbs[11],topcirclex+45,topcircley+37);
  //tint(colors[3],colors[4],colors[5]);
  //image(numbs[sdaikon],topcirclex+55,topcircley+37);
  
  //tint(colors[0],colors[1],colors[2]);
  //image(numbs[juice[0]],bottomcirclex+25,bottomcircley+37);
  //image(numbs[11],bottomcirclex+45,bottomcircley+37);
  //tint(colors[3],colors[4],colors[5]);
  //image(numbs[juice[1]],bottomcirclex+55,bottomcircley+37);
  //noTint();
  
  gradientbar();
}

void gradientbar(){
  float centerx = width/2;
  float centery = height/2;
  float cwidth = 200;
  float cheight = 50;
  float c[] = new float[3];
  c[0] = 0; c[1] = 0; c[2] = 0;
  noStroke();
  for (int i=0; i<12; i++){
    c [0] = colors[3]+(colors[0]-colors[3])*i/12; 
    c [1] = colors[4]+(colors[1]-colors[4])*i/12;
    c [2] = colors[5]+(colors[2]-colors[5])*i/12;
    fill(c[0],c[1],c[2]);
    rect(centerx-cwidth/2,centery-6*cheight+cheight*i,cwidth,cheight);
  }
  
  //your juice
  int scarrot = round(((float)score[0]/(float)(score[0]+score[1]))*10);
  image(yourjuice,width/2-cwidth/2-yourjuice.width,centery-7*cheight+scarrot*cheight);
  //desired juice
  image(desiredjuice,width/2+cwidth/2,centery-7*cheight+juice[0]*cheight);
}

void timerdraw(float total){
  int size = 300;
  float x=width/2;
  float y=0;
  
  noStroke();
  fill(255);
  arc(x,y,size,size,0,PI,OPEN);
  
  fill(150);
  arc (x,y, size,size,0,((float)timer/total)*PI);
  
  noFill();
  stroke(0);
  strokeWeight(5);
  arc(x,y,size,size,0,PI,OPEN);
  
  float angle = TWO_PI/20;
  stroke(0);
  for (int i=0; i<11; i++){
    //circumference...
    line(size/2*sin(angle*i-PI/2)+x,size/2*cos(angle*i-PI/2)+y,
        size/2*0.9f*sin(angle*i-PI/2)+x,size/2*0.9f*cos(angle*i-PI/2)+y);
  }
}

void playerdraw(){
  float xscale = squatter[0].width;
  float yscale = squatter[1].height;
  image(squatter[1], width/2+350, height-yscale-50, xscale, yscale);
  image(squatter[0], width/2-xscale-350, height-yscale-50, xscale, yscale);
}

void bottledraw(){
  noStroke();
  fill(juicecolor[0], juicecolor[1], juicecolor[2]);
  //rect(width/2-80,height-bottle.height-48,165,bottle.height-3);
  //image(bottle,width/2 - bottle.width/2,height-bottle.height-50,bottle.width,bottle.height);
  
  rect(0,0,width,100);
}

void carrotdraw(){
  float x = -100;
  float y = -100;
  float x0 = 150;
  float y0 = 100;
  float h = 250;
  float k = 25;
  if (carrotstate > -1){
    x = 150 + (350-150)*carrotstate;
    y = (y0-k)/((x0-h)*(x0-h)) * (x-h)*(x-h) + k;
    
    x = width/2-350+200*carrotstate;
    
    //QUICK FIXXXXXXXXXXXXXXXXXXX
    y = y+150;
  }
  image(carrot,x,y,carrot.width,carrot.height);
}

void daikondraw(){
  float x = -100;
  float y = -100;
  float x0 = width-150 - daikon.width;
  float y0 = 100;
  float h = width-250 - daikon.width;
  float k = 25;
  if (daikonstate > -1){
    x = width - daikon.width - 150 - (350-150)*daikonstate;
    y = (y0-k)/((x0-h)*(x0-h)) * (x-h)*(x-h) + k;
    
    x = width/2+350-200*daikonstate-100;
    
    //QUICK FIXXXXXXXXXXXXXXXXXXX
    y = y+150;
  }
  image(daikon,x,y,daikon.width,daikon.height);
}