import ddf.minim.*;
import ddf.minim.analysis.*;
import codeanticode.syphon.*;
import processing.opengl.*;
import javax.sound.sampled.*;


Minim minim;
AudioPlayer sample;
FFT fftLin;
FFT fftLog;
AudioInput in;
BeatDetect beat;
BeatListener bl;
Mixer.Info[] mixerInfo;
SyphonServer server;

boolean showGUI, showPrevisualization, showGrid = false;
boolean showMarkers = true;
boolean isLive = false;
int activeMixer = -1;
ArrayList<AudioDevice> mixerButtons = new ArrayList<AudioDevice>();
float kickSize, snareSize, hatSize;
int numLines = 3;
ArrayList<Behaviour> lines = new ArrayList<Behaviour>();
PGraphics main, markers, previsual, grid;
float xStep, yStep, xStepPrev, yStepPrev;
float numStrips = 10;
float numLeds = 60;

ArrayList<Waves> waves = new ArrayList<Waves>();
Leds leds;
Led l;
int numWaves = 15;

void setup()
{
  size(1024, 768, P3D);
  textAlign(LEFT, TOP);

  xStep = width/numStrips;
  yStep = ceil(height/numLeds);

  server = new SyphonServer(this, "Processing Syphon");
  minim = new Minim(this);
  mixerInfo = AudioSystem.getMixerInfo();
  main = createGraphics(width, height);
  markers = createGraphics(width, height);
  previsual = createGraphics(width, height);
  grid = createGraphics(width, height);

  for (int i = 0; i < mixerInfo.length+1; i++)
  {
    AudioDevice button;
    
    if(i== mixerInfo.length)
      button = new AudioDevice("Audio File", 10, 20+i*25, i);
    else
      button = new AudioDevice(mixerInfo[i].getName(), 10, 20+i*25, i);
      
    mixerButtons.add( button );
  }

  for (int i = 0; i < numLines; i++)
  {    
    lines.add( new Behaviour( 0, 
                int(random(0, height)), 
                color( random(100, 200), 0, 100  ), 
                color( 0, random(0, 200), 200 
                )));
  }

  minim = new Minim(this);
  sample = minim.loadFile("song.mp3", 1024);
  sample.play();
  beat = new BeatDetect(sample.bufferSize(), sample.sampleRate());
  
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  // note that what sensitivity you choose will depend a lot on what kind of audio 
  // you are analyzing. in this example, we use the same BeatDetect object for 
  // detecting kick, snare, and hat, but that this sensitivity is not especially great
  // for detecting snare reliably (though it's also possible that the range of frequencies
  // used by the isSnare method are not appropriate for the song).
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, sample);
  
  for(int i=0; i< numWaves ; i++){
     waves.add(new Waves(0, (i+1)* height/15, color(random(100,255),0, 255), color( 15, 245 , random( 120,255 )))  );
  }
  leds = new Leds();
  l = new Led( 60, width/10, height/60, width/10*2);
}

void draw()
{  
  //background(255);
  main.beginDraw();
  pushStyle();
  
  for(Waves wave: waves){
     wave.draw();
  }
  popStyle();
  
  // leds.draw();
  main.endDraw();
  /*pushStyle();
  for ( int i= 0; i < numLines; i++) {
    lines.get(i).draw();
  }
  popStyle();*/

  if (showPrevisualization){
    Previsualization();
  } else {
    image(main, 0, 0);
    if (showMarkers)
      drawMarkers();
    if (showGrid)
      drawGrid();
  }

  showAudioInSignal();

  if (showGUI) {
    for (int i = 0; i < mixerButtons.size(); ++i) { 
      mixerButtons.get(i).draw();
    }
  }

 // server.sendScreen();
}



void mousePressed()
{
  for (int i = 0; i < mixerButtons.size(); ++i)
  {
    if ( mixerButtons.get(i).mousePressed() )
    {
      activeMixer = i;
      break;
    }
  }

  if ( activeMixer != -1 )
  {
    Mixer mixer = AudioSystem.getMixer(mixerInfo[activeMixer]);

    if ( in != null )
    {
      in.close();
    }

    minim.setInputMixer(mixer);

    in = minim.getLineIn(Minim.STEREO);
  }
}


void keyPressed() {

  if (key == ' ') {
    showGUI = !showGUI;
  }

  if (key == 'p') {
    showPrevisualization = !showPrevisualization;
  }

  if (key == 'g') {
    showGrid = !showGrid;
  }

  if (key == 'm') {
    showMarkers = !showMarkers;
  }
}


void showAudioInSignal() {

  if ( in != null ) {
    stroke(255);
    // draw the waveforms
    for (int i = 0; i < in.bufferSize() - 1; i++)
    {
      line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
      line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
    }
  }
}

void Previsualization() {
  previsual.beginDraw();
  previsual.clear();
  for (int m = 0; m < numStrips; m++)
  {
    for (int n = 0; n < numLeds; n++)
    {
      color c = main.get((int)((xStep*m)+(xStep/2)), (int)((yStep*n)+(yStep/2))); 
      previsual.fill(c);
      previsual.noStroke();
      previsual.ellipse((xStep*m)+(xStep/2), (yStep*n)+(yStep/2), 5, 5);
    }
  }
  previsual.endDraw();
  background(0);
  image(previsual, 0, 0);
}


void drawMarkers() {
  markers.beginDraw();
  markers.clear();
  for (int m = 0; m < numStrips; m++)
  {
    for (int n = 0; n < numLeds; n++)
    {
      markers.fill(0, 255, 0);
      markers.noStroke();
      markers.ellipse((xStep*m)+(xStep/2), (yStep*n)+(yStep/2), 2, 2);
    }
  }
  markers.endDraw();
  image(markers, 0, 0);
}


void drawGrid() {
  grid.beginDraw();
  grid.clear();
  grid.stroke(255);

  for (int m = 0; m < numStrips; m++)
  {
    grid.line((xStep*m)+(xStep/2), 0, (xStep*m)+(xStep/2), height);
    for (int n = 0; n < numLeds; n++)
    {
      grid.line(0, (yStep*n)+(yStep/2), width, (yStep*n)+(yStep/2));
    }
  }
  grid.endDraw();
  image(grid, 0, 0);
}