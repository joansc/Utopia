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

    sample.close();
    minimFile.stop();
    minimLive.setInputMixer(mixer);
    int buffersize = 0;
    in = minimLive.getLineIn(Minim.MONO, 512);
    beatLive = new BeatDetect(in.bufferSize(), in.sampleRate());
    beatLive.setSensitivity(300);
    bl = new BeatListenerLive(beatLive, in);
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
