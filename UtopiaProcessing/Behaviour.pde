class Behaviour 
{
  String label;
  int x, y, w, h;
  int mixerId;
  float alpha;
  color colorIn, colorOut, colorCalc;

  public Behaviour( int x_, int y_, color colorIn_, color colorOut_) {
    x = x_;
    y = y_;
    colorIn = colorIn_;
    colorOut = colorOut_;
  }

  public void draw() {  
    main.beginDraw();
    main.background(0);
    main.strokeWeight(5);
    fx();
    main.stroke(lerpColor(  colorIn, colorOut, 0.3 ));
    main.line( 0, y, width, y  );

    main.fill(lerpColor(  colorIn, colorOut, 0.3 ));
    if ( beatFile.isKick()) {
      main.fill(255);
      main.noStroke();
      main.rect( 0, 0, width, height );
    } 
    try {
      if ( beatLive.isKick()) {
        main.fill(255);
        main.noStroke();
        main.rect( 0, 0, width, height );
      }
    } 
    catch(NullPointerException e) {
    }
    main.endDraw();
  }

  public void fx() { 
    y = y + int(10*sin(  1000*millis()*50 ));
  }

  public void calcColor() {
    float ratio = 0.5;
    colorCalc = lerpColor(  colorIn, colorOut, ratio );
    colorCalc = color(255, 0, 0);
    ratio = ratio + int(10*sin(  1000*millis()*50 ));
  }
} 
