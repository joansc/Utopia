class AudioDevice
{
  String label;
  int x, y, w, h;
  int mixerId;

  public AudioDevice(String _label, int _x, int _y, int _id)
  {
    label = _label;
    x = _x;
    y = _y;
    w = 200;
    h = 15;
    mixerId = _id;
  }

  public void draw()
  {
    if ( activeMixer == mixerId )
    {
      stroke(255);
      // indicate the mixer failed to return an input
      // by filling in the box with red
      if ( in == null )
      {
        fill( 255, 0, 0 );
      } else
      {
        fill( 0, 128, 0 );
      }
    } else
    {
      noStroke();
      fill( 128 );
    }

    rect(x, y, w, h);

    fill( 255 );
    text( label, x+5, y );
  }

  public boolean mousePressed()
  {
    return ( mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h );
  }
}
