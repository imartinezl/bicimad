 //<>//
BufferedReader reader;
int pid = -1, id, n = 100;
float px = -1, py = -1, x, y;
String date;

void setup() {
  size(600, 600);
  background(255);

  reader = createReader("temp.csv");
  String header = readline(reader);
  println(header);
}

void draw() {
  for (int i=0; i<n; i++) {
    String line = readline(reader);
    if (line == null) {
      println("finish");
      noLoop();
      break;
    } else {
      process(line);
      display();
      update();
    }
  }
}


void display() {
  if (id == pid) {
    display_path();
    display_date();
  }
}

void display_path() {
  strokeWeight(0.2);
  stroke(0, 0, 0, 150);
  line(px, py, x, y);
}

void display_date() {
  PVector p = new PVector(50, 50);
  // rectangle
  fill(255, 0, 0);
  noStroke();
  rect(p.x, p.y, 110, 11);

  // date
  fill(0);
  textSize(10);
  textAlign(LEFT, TOP);
  text(date, p.x, p.y);
}

void update() {
  pid = id;
  px = x;
  py = y;
}
