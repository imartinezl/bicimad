import java.util.Collections; //<>//

Track track;
TripCount tripcount;
int t, t_step = 1*60;

void setup() {
  size(800, 800);
  background(255);

  track = new Track("bikes_path.csv");
  track.init();
  t = floor(track.lastTime()/t_step)*t_step;
  
  tripcount = new TripCount("trips_count.csv");
}


void draw() {
  background(255);
  display_date(t);
  tripcount.display(t);
  while (track.lastTime() < t + t_step) {
    track.next();
  }
  track.update();
  t = t + t_step;
  println(frameRate);
}


String readline(BufferedReader reader) {
  String line;
  try {
    line = reader.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  return line;
}
