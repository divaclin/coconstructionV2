TuioProcessing tuioClient;

/* customized var*/
final int initTime   =  2;  //  抓子一開始抓桌面的時間 default 7
final int maxID      = 77;

final String url     = "http://coconstructionv2.parseapp.com";

final int gridWidth  = 13;  //  長邊有幾格
final int gridHeight =  9;  //  寬邊有幾格

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

int commentingBuilding ; 
/*TUIO var end*/
