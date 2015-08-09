class Effect{
      float effectWidth;
      float effectHeight;
      
      boolean thermodynamic;
      
      Effect(){
        this.effectWidth = float(displayWidth)/gridWidth;
        this.effectHeight = float(displayHeight)/gridHeight;
        this.thermodynamic = true;
      }
      
      void show(TuioObject obj){
        //println("thermodynamic:"+this.thermodynamic);
        if(thermodynamic && heat!=null){
            for(int i=0;i<heat.size();i++) {
                JSONObject heatObj = heat.getJSONObject(i);
                TuioObject tmp = null; 
                  for(TuioObject tobj : tuioObjectList){
                     if(tobj.getSymbolID()==heatObj.getInt("bid")){
                       tmp=tobj;
                       break;
                     } 
                  }
                if(heatObj.getString("type").equals("like")   ){fill(this.colorCode2RGB("#0071BC")[0],this.colorCode2RGB("#0071BC")[2],this.colorCode2RGB("#0071BC")[2],heatObj.getFloat("percent"));}
                if(heatObj.getString("type").equals("dislike")){fill(this.colorCode2RGB("#ED1C24")[0],this.colorCode2RGB("#ED1C24")[1],this.colorCode2RGB("#ED1C24")[2],heatObj.getFloat("percent"));}
                if(heatObj.getString("type").equals("draw")   ){fill(255);}
                if(tmp!=null){
                  rect(this.getX(tmp.getScreenX(width))*this.effectWidth,this.getY(tmp.getScreenY(height))*this.effectHeight,this.effectWidth,this.effectHeight);
                }
            }    
        }
        else if(obj != null){
          if( LIKE && !DISLIKE ){fill(this.colorCode2RGB("#0071BC")[0],this.colorCode2RGB("#0071BC")[2],this.colorCode2RGB("#0071BC")[2]);}
          if(!LIKE &&  DISLIKE ){fill(this.colorCode2RGB("#ED1C24")[0],this.colorCode2RGB("#ED1C24")[1],this.colorCode2RGB("#ED1C24")[2]);}
          if(!LIKE && !DISLIKE ){fill(255);}
          rect(this.getX(obj.getScreenX(width))*this.effectWidth,this.getY(obj.getScreenY(height))*this.effectHeight,this.effectWidth,this.effectHeight);
        }
      }
      void setStat(boolean stat){
        this.thermodynamic = stat; 
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
