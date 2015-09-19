class Effect{
      float effectWidth;
      float effectHeight;
      
      boolean thermodynamic = true ; 
      
      Effect(){
        this.effectWidth = float(displayWidth)/gridWidth;
        this.effectHeight = float(displayHeight)/gridHeight;
      }
      
      void show(int objId){       // 畫熱力圖
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
        }else{ // Radian add : 這個狀況是要 for 當使用者選取唯一建築的時候
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
// 在討論之後，決定在選取的時候只打那盞建築就好
//        else if(objId!=-1){
//          for(TuioObject obj : tuioObjectList){
//             if(obj.getSymbolID() == objId){
//                if( LIKE && !DISLIKE ){fill(#0071bc);}  // 喜歡
//                if(!LIKE &&  DISLIKE ){fill(#ed1c24);}  // 不喜歡
//                if(!LIKE && !DISLIKE ){fill(255);}      // 持平
//                println(objId);
//                rect(this.getX(obj.getScreenX(width))*this.effectWidth,this.getY(obj.getScreenY(height))*this.effectHeight,this.effectWidth,this.effectHeight);                
//                break;
//             }
//          }
//        }
      }
      
      void setStat(boolean stat){
        this.thermodynamic = stat;
        //check if thermodynamic effect or not 
      }
      int getX(float objWidth){ 
        return int(objWidth/this.effectWidth);
      }
      int getY(float objHeight){
        return int(objHeight/this.effectHeight);
      }
      int[] colorCode2RGB(String colorStr){
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
