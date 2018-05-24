class Waves {

  float x, y;
  color colorIn, colorOut, colorCalc;
  float second , ratio;
  
  public Waves( float x_, float y_ ,color colorIn_, color colorOut_) {
    x = x_;
    y = y_;
    colorIn = colorIn_;
    colorOut = colorOut_;
    ratio = random(0,1);
    rectMode(CENTER);
  }

  public void draw() {
     
    timeCalculation();
    
    for (int i = 0; i < width; i+=20) {
      noiseSeed(i);
      float posy = y + noise( x , (frameCount*.001) ) * height/4*sin(frameCount * 0.001); 
      noiseSeed(0);
      float rectHeight = (height / 7) * noise( i * 0.003 , posy * 0.03 );
      println(ratio);
      colorCalc = lerpColor(  colorIn, colorOut, ratio);
      main.fill(colorCalc , 150);
      main.noStroke();
      main.rect( i, posy, 50, rectHeight);
    }
  }
  public color calcColor( color colorIn, color colorOut, float ratio_) {
    
    colorCalc = lerpColor(  colorIn, colorOut, 0.2 );
    colorCalc = color(255, 0, 0);
    return colorCalc;
  }
  
  public void timeCalculation(){
     second = millis() / 1000 ;
     ratio =  abs(sin( second * 0.1 + ratio ));

  }
}