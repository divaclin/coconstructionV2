import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import TUIO.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TuioDemo extends PApplet {






int current = -1 ;
Main M = new Main () ; 

public void setup(){
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
  
  // \u9019\u908a\u6703\u53bb\u5075\u6e2c device P \u73fe\u5728\u5728\u505a\u4ec0\u9ebc
  timer.schedule(new init()         ,0,200);
  timer.schedule(new idle()         ,(initTime+2)*1000,   updateTime);
//  timer.schedule(new like()         ,(initTime+2)*1000,   updateTime);
//  timer.schedule(new dislike()      ,(initTime+2)*1000,   updateTime);
//  timer.schedule(new comment()      ,(initTime+2)*1000,   updateTime);
  // \u4e0a\u9762\u9019\u908a\u4e92\u65a5
  
  timer.schedule(new thermodynamic(),(initTime+1)*1000, 4*updateTime);
  frameRate(15);
}

public void draw(){
  tuioObjectList = tuioClient.getTuioObjectList();
  
  int detect ;
  detect=findSelect(); // \u5075\u6e2c\u684c\u4e0a\u7684\u8b8a\u5316\uff0c\u4e26\u540c\u6b65\u5230\u96f2\u7aef
  
  switch(stat){
    case INIT:   // \u524d\u9762\u6703\u6293\u53d6\u4e00\u958b\u59cb\u684c\u9762\u4e0a\u6709\u7684\u5efa\u7bc9
      if((initTime-EXECUTE_TIME/1000)==0){
        printText("initialize completely");
      }
      else{
        printText("initializing in "+(initTime-EXECUTE_TIME/1000)+"s");
      }
      break;
      
    case PROCESS: //  \u4e00\u76f4\u9032\u884c\u7684\u6a21\u5f0f
      drawBackground();
      carRun();
//      println("!!!freq") ;
      
      
      if (detect != -1){
        if (detect == 3){
          current = -1 ;
          loadStrings(url+"/idle");    
        }else{
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
      
      current = M.cloudBuilding()  ; // \u7b49\u5f85\u5be6\u4f5c\uff0c\u505a\u4e00\u6b21\u5c31\u597d
      effect.show(current);effect.show(current); 
      
      detect=findSelect(); // \u5075\u6e2c\u684c\u4e0a\u7684\u8b8a\u5316\uff0c\u4e26\u540c\u6b65\u5230\u96f2\u7aef

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
public void keyPressed(){
     switch(key){
       case 's':   // \u505a\u6821\u6b63
       case 'S':
          fix=!fix;
          break;
       default:
          break;   
     }
}
public void printText(String str){
     textFont(font,18*scale_factor);
     background(0);
     fill(255,255,255);
     textSize(50);
     text(str,(width-textWidth(str))/2,height/2);
}
public void drawBackground(){
     background(0);
     if(!fix){
        stroke(255); // \u683c\u7dda\u984f\u8272
        
        // \u756b\u5de6\u53f3\u9694\u7dda
        for(int i=0;i<gridWidth;i++){
           line(i*PApplet.parseFloat(displayWidth)/gridWidth,0,i*PApplet.parseFloat(displayWidth)/gridWidth,displayHeight);
        }
        for(int i=0;i<gridHeight;i++){
           line(0,i*PApplet.parseFloat(displayHeight)/gridHeight,displayWidth,i*PApplet.parseFloat(displayHeight)/gridHeight);
        }
        // \u756b\u71b1\u529b\u5716
        
        
        // \u756b\u5730\u5716
        image(img,0,0,displayWidth,displayHeight);
     }
     else{ // \u505a\u6821\u6b63
       stroke(0,255,0);
       line(width/2,0,width/2,height);
       line(0,height/2,width,height/2);
     }
}


// \u72c0\u614b\u662f comment \u7684\u6642\u5019\u53ef\u4ee5\u505a\u4ec0\u9ebc
class Car{
      float x;
      float y;
      int dir;
      PImage img;
      float radians = 0;
      float r;
      float speed;
      Car(float x,float y,int dir,float speed){
         this.x = x;
         this.y = y;
         this.dir = dir;
         this.img = loadImage("car"+PApplet.parseInt(random(1,4))+".png");  
         this.r = 0;
         this.speed = speed;
      }
      Car(int dir,float r){
         this.x = 615;
         this.y = 450;
         this.r = r;
         this.dir = dir;
         this.img = loadImage("car"+PApplet.parseInt(random(1,4))+".png");  
         this.speed = 0;
      }
      public void show(){
        switch(dir){
          case 1:
             imageMode(CENTER);
             pushMatrix();
             translate(this.x, this.y);
             rotate(radians(90-this.radians));
             image(this.img,0,0,53.25f,26.25f);
             popMatrix();   
             imageMode(CORNER);
             break;
          case 2:
             pushMatrix();
             translate(this.x-53.25f/2,this.y-26.25f/2);
             rotate(radians(90));
             image(this.img,0,0,53.25f,26.25f);
             popMatrix();
             break;
          case 3:
             pushMatrix();
             translate(this.x-53.25f*2,this.y-26.25f/2);
             rotate(radians(-90));
             image(this.img,0,0,53.25f,26.25f);
             popMatrix();             
             break;
          default:
             break;
        }
      }
      public void move(){
        switch(dir){
          case 1:
             this.x = 610+this.r*cos(radians(this.radians));
             this.y = 450-this.r*sin(radians(this.radians));
             this.radians++;
             break;
          case 2:
             if(this.y < -300){
               this.y = height;
             }
             this.y-=5*this.speed;
             break;
          case 3:
             if(this.y > displayHeight+300){
                this.y = 0;
             }
             this.y+=5*this.speed;
             break;
          default:
             break;
        }
      }
}

public void carSetup(){
     for(int i=0;i<carNum;i++){
       vehicle[i] = (i%3==0 ?new Car(1,105+25*(i/3+1)):new Car(displayWidth*0.78472f,displayHeight,i%3+1,i%3+1));
     }
}
public void carRun(){
     for(int i=0;i<carNum;i++){
       vehicle[i].move();
       vehicle[i].show();
     }
}
class Effect{
      float effectWidth;
      float effectHeight;
      
      boolean thermodynamic = true ; 
      
      Effect(){
        this.effectWidth = PApplet.parseFloat(displayWidth)/gridWidth;
        this.effectHeight = PApplet.parseFloat(displayHeight)/gridHeight;
      }
      
      public void show(int objId){       // \u756b\u71b1\u529b\u5716
       if ( heat == null ) return  ; 
//        print("showing...") ;      
//        println("thermodynamic:"+this.thermodynamic );
        if(objId == -1 ){
            print("s");
            for(int i=0;i<heat.size();i++) {
                JSONObject heatObj = heat.getJSONObject(i); // current drawing building
                TuioObject tmp = null; 
                  for(TuioObject tobj : tuioObjectList){
                     if(tobj.getSymbolID()==heatObj.getInt("bid")){
                       tmp=tobj;
                       break;
                     } 
                  }
                if(heatObj.getString("type").equals("like")   ){
//                  println("like") ;
                  fill(0,113,188,heatObj.getFloat("percent")*255 *100 * 10);
                }
                if(heatObj.getString("type").equals("dislike")){
//                  println("dislike") ;
                  //fill(this.colorCode2RGB("#ED1C24")[0],this.colorCode2RGB("#ED1C24")[1],this.colorCode2RGB("#ED1C24")[2],heatObj.getFloat("percent")*255 *100 * 100);
                  fill(237,28,36,heatObj.getFloat("percent")*255 *100 * 10);
                }
                if(heatObj.getString("type").equals("draw")   ){fill(255);}
                if(tmp!=null){
                  rect(this.getX(tmp.getScreenX(width))*this.effectWidth,this.getY(tmp.getScreenY(height))*this.effectHeight,this.effectWidth,this.effectHeight);
                }
            }
        }else{ // Radian add : \u9019\u500b\u72c0\u6cc1\u662f\u8981 for \u7576\u4f7f\u7528\u8005\u9078\u53d6\u552f\u4e00\u5efa\u7bc9\u7684\u6642\u5019
            print("o");
            for(int i=0;i<heat.size();i++) {
                JSONObject heatObj = heat.getJSONObject(i); // current drawing building
                if (heatObj.getInt("bid") !=objId ) continue ;
                
                TuioObject tmp = null; 
                  for(TuioObject tobj : tuioObjectList){
                     if(tobj.getSymbolID()==heatObj.getInt("bid") ){
                       tmp=tobj;
                       break;
                     } 
                  }
                if(heatObj.getString("type").equals("like")   ){
//                  println("like") ;
                  fill(0,113,188,heatObj.getFloat("percent")*255 *100 * 10);
                }
                if(heatObj.getString("type").equals("dislike")){
//                  println("dislike") ;
                  //fill(this.colorCode2RGB("#ED1C24")[0],this.colorCode2RGB("#ED1C24")[1],this.colorCode2RGB("#ED1C24")[2],heatObj.getFloat("percent")*255 *100 * 100);
                  fill(237,28,36,heatObj.getFloat("percent")*255 *100 * 10);
                }
                if(heatObj.getString("type").equals("draw")   ){fill(255);}
                if(tmp!=null){
                  rect(this.getX(tmp.getScreenX(width))*this.effectWidth,this.getY(tmp.getScreenY(height))*this.effectHeight,this.effectWidth,this.effectHeight);
                }
            }            
        }
// \u5728\u8a0e\u8ad6\u4e4b\u5f8c\uff0c\u6c7a\u5b9a\u5728\u9078\u53d6\u7684\u6642\u5019\u53ea\u6253\u90a3\u76de\u5efa\u7bc9\u5c31\u597d
//        else if(objId!=-1){
//          for(TuioObject obj : tuioObjectList){
//             if(obj.getSymbolID() == objId){
//                if( LIKE && !DISLIKE ){fill(#0071bc);}  // \u559c\u6b61
//                if(!LIKE &&  DISLIKE ){fill(#ed1c24);}  // \u4e0d\u559c\u6b61
//                if(!LIKE && !DISLIKE ){fill(255);}      // \u6301\u5e73
//                println(objId);
//                rect(this.getX(obj.getScreenX(width))*this.effectWidth,this.getY(obj.getScreenY(height))*this.effectHeight,this.effectWidth,this.effectHeight);                
//                break;
//             }
//          }
//        }
      }
      
      public void setStat(boolean stat){
        this.thermodynamic = stat;
        //check if thermodynamic effect or not 
      }
      public int getX(float objWidth){ 
        return PApplet.parseInt(objWidth/this.effectWidth);
      }
      public int getY(float objHeight){
        return PApplet.parseInt(objHeight/this.effectHeight);
      }
      public int[] colorCode2RGB(String colorStr){
        int[] tmp = new int[3];
        if(colorStr.length()==7){
           for(int i=1;i<=3;i++){
              tmp[i-1]=Character.getNumericValue(colorStr.charAt(2*i-1))*16+Character.getNumericValue(colorStr.charAt(2*i));
           }
        }
        if(colorStr.length()==4){
          for(int i=1;i<3;i++){
              tmp[i-1]=Character.getNumericValue(colorStr.charAt(i))*17;
          }
        }
        if(colorStr.length()!=4 || colorStr.length()!=7){
          tmp[0]=tmp[1]=tmp[2] = 255;
        }
        return tmp;
      }
}
class Main {
  Main(){}
  
  public int cloudBuilding (){
    return 1 ;
  }
  
  
  // 
}
TuioProcessing tuioClient;

/* customized var*/
final int initTime   =  2;  //  \u6293\u5b50\u4e00\u958b\u59cb\u6293\u684c\u9762\u7684\u6642\u9593 default 7
final int maxID      = 77;

final String url     = "http://coconstructionv2.parseapp.com";

final int gridWidth  = 13;  //  \u9577\u908a\u6709\u5e7e\u683c
final int gridHeight =  9;  //  \u5bec\u908a\u6709\u5e7e\u683c

final int INIT    = 1;
final int PROCESS = 2;
final int BIND    = 3;
int stat          = 0;
PImage img;
boolean fix = false;

Timer timer;
boolean IDLE         = false;
boolean LIKE         = false;
boolean DISLIKE      = false;
boolean COMMENT      = false;
int  EXECUTE_TIME    = 0; //ms
final int unitTime   = 100;
final int updateTime = 1000;
int updateCounter = 0;
 
HashMap<Integer,String> TuioObjStatus = new HashMap<Integer,String>(); // objectID , object Status 

ArrayList<TuioObject> tuioObjectList; // 
final int carNum = 3; 
Car vehicle[] = new Car[carNum];

Effect effect;

JSONArray heat;
/*customized var end */


/*TUIO var */
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = false; // updates only after callbacks

float obj_size = object_size*scale_factor; 
float cur_size = cursor_size*scale_factor;
/*TUIO var end*/
public String strArr2str(String[] strArr){
       String str = "";
       for(int i=0;i<strArr.length;i++){
         str += strArr[i];
       }
       return str;
} 
class init extends TimerTask{
      public void run(){
         if(EXECUTE_TIME <= initTime*1000 && stat == INIT){
            for(int i=0;i<tuioObjectList.size();i++){
                TuioObject tobj = tuioObjectList.get(i);
                if(TuioObjStatus.get(tobj.getSymbolID())==null && tobj.getSymbolID()<=maxID){
                   TuioObjStatus.put(tobj.getSymbolID(),"INIT");
                }
            }
          }
          else{
             stat = PROCESS;
             this.cancel();
          }   
      }
}
class idle extends TimerTask{
      public void run(){
         if(stat != INIT){
           String status = "" ;
           status =loadStrings(url+"/projectorStatus")[0] ;
           
           IDLE = false ; 
           LIKE = false ;  
           DISLIKE = false ; 
           COMMENT = false ; 
           
           
           startLine();
           switch (Integer.parseInt(status)){
              case 0 : IDLE = true ; break ;
              case 1 : LIKE = true ; break ;
              case 2 : DISLIKE = true ; break ;
              case 3 : COMMENT = true ; break ;
              default : break ;
            }
            
            if (IDLE){
              print("IDLE ");
            }else if (LIKE){
              print("LIKE ");
            }else if (DISLIKE){
              print("DISLIKE ");
            } else if (COMMENT){
              print("COMMENT ");
            }else {
              print("unknown ") ; 
            }
            
//            println("idle    = "+IDLE);
//            println("like    = "+LIKE);
//            println("dislike = "+DISLIKE);
//            println("comment = "+COMMENT);
           
            
         }
      }
}
//class like extends TimerTask{
//      void run(){
//         if(stat != INIT){
//            LIKE = !(loadStrings(url+"/like")[0].charAt(0)=='0');
//            if(LIKE){
//               current = Integer.parseInt(loadStrings(url+"/like")[0]);
//            }
//            println("like    = "+LIKE);
//         }
//      }
//}
//
//class dislike extends TimerTask{
//      void run(){
//        if(stat != INIT){
//           DISLIKE = !(loadStrings(url+"/dislike")[0].charAt(0)=='0');
//           if(DISLIKE){
//              current = Integer.parseInt(loadStrings(url+"/dislike")[0]);
//           }
//           println("dislike = "+DISLIKE);
//        }
//      }
//}
//class comment extends TimerTask{
//      void run(){
//         if(stat != INIT){
//            COMMENT=loadStrings(url+"/comment")[0].contains("1");
//            println("comment = "+COMMENT);
//            stopLine();
//         }
//      }
//}
class runTime extends TimerTask{
      public void run(){
         EXECUTE_TIME +=unitTime;
      }
}
class thermodynamic extends TimerTask{
      public void run(){
        heat = loadJSONArray(url+"/thermodynamic");
      }
}

public void stopLine(){
     String tmp = "";
     for(int i =1;updateCounter/i>0;i*=10){
         tmp+="-";
     }
     println("--------------------------------------"+tmp);
}
public void startLine(){ // \u7528\u4f86\u756b console \u7684\u7dda
     println("");
     print("-"+updateCounter++ +"- ");
}

public int findSelect(){
    if(tuioObjectList.size()<TuioObjStatus.size()){
       ArrayList<Integer> List   = new ArrayList<Integer>();
       ArrayList<Integer> Status = new ArrayList<Integer>();
               
       for(int i=0;i<tuioObjectList.size();i++){
           List.add(tuioObjectList.get(i).getSymbolID());
       }
       for(Map.Entry me : TuioObjStatus.entrySet()){
           Status.add((Integer)me.getKey());
       }
       Status.removeAll(List);
       
       loadStrings(url+"/select/"+Status.get(0));
       effect.setStat(false);
       // println(TuioObjStatus);               
       print(" -S"+Status.get(0) + "- " );
       return Status.get(0);
    }
    else{
         return -1;
    }
}
public void clearSelect(){
     for(Map.Entry me : TuioObjStatus.entrySet()){
         TuioObjStatus.put((Integer)me.getKey(),"CHECKED");  
     }
}     
      

public void TuioPreSetup(){
     // GUI setup
     noCursor();
     noStroke();
     fill(0);
  
     // periodic updates
     if (!callback) {
        frameRate(60); //<>//
        loop();
     } else noLoop(); // or callback updates 
     font = createFont("Arial", 18);
}
public void showTuioObj(){
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
   for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = tuioObjectList.get(i);
     stroke(0);
     fill(0,0,0);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     rotate(tobj.getAngle());
     rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
     popMatrix();
     fill(255);
     text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
     println(tobj);
   }
}
public void showTuioCursor(){
  ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
   for (int i=0;i<tuioCursorList.size();i++) {
      TuioCursor tcur = tuioCursorList.get(i);
      ArrayList<TuioPoint> pointList = tcur.getPath();
      
      if (pointList.size()>0) {
        stroke(0,0,255);
        TuioPoint start_point = pointList.get(0);
        for (int j=0;j<pointList.size();j++) {
           TuioPoint end_point = pointList.get(j);
           line(start_point.getScreenX(width),start_point.getScreenY(height),end_point.getScreenX(width),end_point.getScreenY(height));
           start_point = end_point;
        }
        
        stroke(192,192,192);
        fill(192,192,192);
        ellipse( tcur.getScreenX(width), tcur.getScreenY(height),cur_size,cur_size);
        fill(0);
        text(""+ tcur.getCursorID(),  tcur.getScreenX(width)-5,  tcur.getScreenY(height)+5);
      }
   }
}
public void showTuioBlob(){
  ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();
  for (int i=0;i<tuioBlobList.size();i++) {
     TuioBlob tblb = tuioBlobList.get(i); // \u4ec0\u9ebc\u662f blob
     stroke(0);
     fill(0);
     pushMatrix();
     translate(tblb.getScreenX(width),tblb.getScreenY(height));
     rotate(tblb.getAngle());
     ellipse(-1*tblb.getScreenWidth(width)/2,-1*tblb.getScreenHeight(height)/2, tblb.getScreenWidth(width), tblb.getScreenWidth(width));
     popMatrix();
     fill(255);
     text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenX(width));
   }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
public void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
public void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
public void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
public void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
public void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
public void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
public void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
public void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
public void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
public void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TuioDemo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
