import java.util.Collections; //<>//

Track track;
TripCount tripcount;
int t, t_step = 1*60;
color ctext = #FFFFFF;
color cline = #FFFFFF;
color cframe = #FFFFFF;
color cback = #000000;

void setup() {
  size(800, 800);
  background(255);

  track = new Track("bikes_path.csv");
  track.init();
  t = floor(track.lastTime()/t_step)*t_step;
  
  tripcount = new TripCount("trips_count.csv");
  
  // println(PFont.list());
  PFont myFont = createFont("BebasNeue-Regular", 32);
  textFont(myFont);
}


void draw() {
  background(cback);
  display_date(t);
  tripcount.display(t);
  while (track.lastTime() < t + t_step) {
    track.next();
  }
  track.update();
  t = t + t_step;
  //println(frameRate);
  //saveFrame("figures/img-######.png");
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
