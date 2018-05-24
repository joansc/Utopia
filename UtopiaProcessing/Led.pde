class Led{
  
  int numLeds;
  float w,h , posx;
  
  public Led( int numLeds_ , float w_ , float h_, float posx_ ){
     posx = posx_;
     w = w_;
     h = h_;
     numLeds = numLeds_;
     rectMode(CORNER);
  }
  
  public void draw(color colorIn){
    
    for(int i = 0 ; i < numLeds ; i++){
      main.fill(colorIn);
      main.noStroke();
      main.rect( posx, i*h, w, h );
    }
  }
  
}