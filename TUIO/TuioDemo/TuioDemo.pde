import java.util.*;
import TUIO.*;
import processing.opengl.*;

void setup(){
  TuioPreSetup();
  carSetup();
  
  size(displayWidth,displayHeight);
  scale_factor = height/table_size;
  tuioClient  = new TuioProcessing(this);
  tuioObjectList = tuioClient.getTuioObjectList();
  
  img = loadImage("data/map.png");
  stat = INIT;
  effect = new Effect();
  timer = new Timer();
  timer.schedule(new runTime()      ,0,unitTime);
  timer.schedule(new init()         ,0,200);
  timer.schedule(new idle()         ,(initTime+2)*1000,   updateTime);
  timer.schedule(new like()         ,(initTime+2)*1000,   updateTime);
  timer.schedule(new dislike()      ,(initTime+2)*1000,   updateTime);
  timer.schedule(new comment()      ,(initTime+2)*1000,   updateTime);
  timer.schedule(new thermodynamic(),(initTime+1)*1000, 4*updateTime);
  
}

void draw(){
  tuioObjectList = tuioClient.getTuioObjectList();
  switch(stat){
    case INIT:
      if((initTime-EXECUTE_TIME/1000)==0){
        printText("initialize completely");
      }
      else{
        printText("initializing in "+(initTime-EXECUTE_TIME/1000)+"s");
      }
      break;
    case PROCESS:
      drawBackground();
      carRun();
      current = getSelectObj();
      if(current!=null){
         loadStrings(url+"/select/"+current.getSymbolID());
         effect.setStat(false);
      }
      if(LIKE || DISLIKE){
        stat = BIND;
      }

      break;
    case BIND:
      drawBackground();
      carRun();
      if(IDLE || COMMENT){
        stat = PROCESS;
        effect.setStat(true);
      }
      
      break;  
    default:
      break;
  }  
   //showTuioObj();
   //showTuioCursor();
   //showTuioBlob();
}
void keyPressed(){
     switch(key){
       case 's':
       case 'S':
          fix=!fix;
          break;
       default:
          break;   
     }
}
void printText(String str){
     textFont(font,18*scale_factor);
     background(0);
     fill(255,255,255);
     textSize(50);
     text(str,(width-textWidth(str))/2,height/2);
}
void drawBackground(){
     background(0);
     if(!fix){
        stroke(255);
        for(int i=0;i<gridWidth;i++){
           line(i*float(displayWidth)/gridWidth,0,i*float(displayWidth)/gridWidth,displayHeight);
        }
        for(int i=0;i<gridHeight;i++){
           line(0,i*float(displayHeight)/gridHeight,displayWidth,i*float(displayHeight)/gridHeight);
        }
        effect.show(current);
        image(img,0,0,displayWidth,displayHeight);
     }
     else{
       stroke(0,255,0);
       line(width/2,0,width/2,height);
       line(0,height/2,width,height/2);
     }
}
