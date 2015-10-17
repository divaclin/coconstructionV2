import java.util.*;
import TUIO.*;
import processing.opengl.*;


int current = -1 ;

MapXY mapXY = new MapXY() ; 

boolean isSendingSelect = false ;  
Integer selectingBid = 0 ;   
boolean isSendingIdle = false ;


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
  
  // 這邊會去偵測 device P 現在在做什麼
  timer.schedule(new init()         ,0,200);
  timer.schedule(new idle()         ,(initTime+2)*1000,   updateTime);
  timer.schedule(new sendStatus()         ,(initTime+2)*1000,   updateTime);
//  timer.schedule(new like()         ,(initTime+2)*1000,   updateTime);
//  timer.schedule(new dislike()      ,(initTime+2)*1000,   updateTime);
//  timer.schedule(new comment()      ,(initTime+2)*1000,   updateTime);
  // 上面這邊互斥
  
  timer.schedule(new thermodynamic(),(initTime+1)*1000, 4*updateTime);
  frameRate(15);
}

void draw(){
  tuioObjectList = tuioClient.getTuioObjectList();
  
  int detect ;
  detect=findSelect(); // 偵測桌上的變化，並同步到雲端
  
  switch(stat){
    case INIT:   // 前面會抓取一開始桌面上有的建築
      if((initTime-EXECUTE_TIME/1000)==0){
        printText("initialize completely");
      }
      else{
        printText("initializing in "+(initTime-EXECUTE_TIME/1000)+"s");
      }
      break;
      
    case PROCESS: //  一直進行的模式
      drawBackground();
      carRun();
//      println("!!!freq") ;
      
      
      if (detect != -1){
        if (detect == 3){
          current = -1 ;
          isSendingIdle = true ; // would call in sendStatus timerTask : loadStrings(url+"/idle");    
        }else{
          isSendingIdle = false ; 
          current = detect;
        }
      }
       effect.show(current);
      
      print("P") ; 
      if(LIKE || DISLIKE){
        effect.setStat(false);
        stat = BIND;
      }

      break;
    case BIND: // 
      drawBackground();
      carRun();
      
      current = commentingBuilding ; // 等待實作，做一次就好
      effect.show(current);effect.show(current); 
      
      detect=findSelect(); // 偵測桌上的變化，並同步到雲端

      effect.show(current);
      
      
      if(IDLE || COMMENT){  
        stat = PROCESS;
        effect.setStat(true);
      }
      
      break;  
    default:
      break;
  }  
//   showTuioObj();
//   showTuioCursor();
//   showTuioBlob();
}
void keyPressed(){
     switch(key){
       case 's':   // 做校正
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
        stroke(30); // 格線顏色
        
        // 畫左右隔線
        for(int i=0;i<gridWidth;i++){
           line(i*float(displayWidth)/gridWidth,0,i*float(displayWidth)/gridWidth,displayHeight);
        }
        for(int i=0;i<gridHeight;i++){
           line(0,i*float(displayHeight)/gridHeight,displayWidth,i*float(displayHeight)/gridHeight);
        }
        // 畫熱力圖
        
        
        // 畫地圖
        image(img,0,0,displayWidth,displayHeight);
     }
     else{ // 做校正
       stroke(0,255,0);
       line(width/2,0,width/2,height);
       line(0,height/2,width,height/2);
     }
}


// 狀態是 comment 的時候可以做什麼
