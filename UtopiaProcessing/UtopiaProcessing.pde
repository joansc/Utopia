import ddf.minim.analysis.*;
import ddf.minim.*;
import javax.sound.sampled.*;
import codeanticode.syphon.*;

Minim minimFile, minimLive;
AudioPlayer sample;
FFT fftLin;
FFT fftLog;
AudioInput in;
BeatDetect beatFile, beatLive;
BeatListenerFile bf;
BeatListenerLive bl;

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

void setup()
{
  size(displayWidth, 768, P3D);
  textAlign(LEFT, TOP);

  xStep = width/numStrips;
  yStep = ceil(height/numLeds);

  server = new SyphonServer(this, "Processing Syphon");
  minimFile = new Minim(this);
  minimLive = new Minim(this);
  mixerInfo = AudioSystem.getMixerInfo();
  main = createGraphics(width, height);
  markers = createGraphics(width, height);
  previsual = createGraphics(width, height);
  grid = createGraphics(width, height);

  for (int i = 0; i < mixerInfo.length; i++)
  {
    AudioDevice button;
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


  sample = minimFile.loadFile("song.mp3", 1024);
  sample.play();
  beatFile = new BeatDetect(sample.bufferSize(), sample.sampleRate());
  beatFile.setSensitivity(300);
  kickSize = snareSize = hatSize = 16;
  bf = new BeatListenerFile(beatFile, sample);

}

void draw()
{
  background(0);

  pushStyle();
  for ( int i= 0; i < numLines; i++) {
    lines.get(i).draw();
  }
  popStyle();

  if (showPrevisualization)
  {
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

  server.sendScreen();
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


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minimFile.stop();
  minimLive.stop();
  super.stop();
}
