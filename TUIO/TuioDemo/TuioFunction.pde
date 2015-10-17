int findSelect(){
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
       selectingBid = Status.get(0) ; 

       isSendingSelect = true ; // loadStrings(url+"/select/"+ selectingBid);
       
       effect.setStat(false);
       // println(TuioObjStatus);               
       print(" -S"+Status.get(0) + "- " );
       return Status.get(0);
    }
    else{
//      isSendingSelect = false ;
         return -1;
    }
}
void clearSelect(){
     for(Map.Entry me : TuioObjStatus.entrySet()){
         TuioObjStatus.put((Integer)me.getKey(),"CHECKED");  
     }
}     
      

