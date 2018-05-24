class Leds {
  int numStripes = 10;
  Led[] leds = new Led[numStripes];
  
  public Leds() {
    for ( int i=0; i< numStripes; i++) {
      leds[i] = new Led( 60, width/numStripes, height/60, width/numStripes*i);
    }
  }
  
  public void draw() {
    for ( int i=0; i< numStripes; i++) {
      leds[i].draw(color(random(0,255),0,0));
    }
  }  
}