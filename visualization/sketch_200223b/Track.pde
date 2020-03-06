class Track {

  ArrayList<Point> points = new ArrayList<Point>();
  int n_max = 4000, chunk = 0, chunk_max = 20;
  float opacity = 0;

  BufferedReader reader;

  Track(String file) {
    reader = createReader(file);
  }

  void init() {
    String header = read(); // read header
    parse(read()); // read first line
  }

  String read() {
    return readline(reader);
  }

  void parse(String line) {
    String[] pieces = split(line, ",");
    int id = int(pieces[0]);
    float x = float(pieces[1]);
    float y = float(pieces[2]);
    String date = pieces[3];
    int t = int(pieces[4]);
    x = x*width;
    y = (1-y)*height;
    points.add(new Point(id, x, y, date, t, chunk));
    if (points.size() > n_max) {
      points.remove(0);
    }
  }

  void next() {
    String line = read();
    if (line == null) {
      println("finish");
      noLoop();
    } else {
      parse(line);
    }
  }

  int lastTime() {
    return points.get(points.size() - 1).t;
  }

  void update() {
    Collections.sort(points);
    if (points.size() > 0) {
      display();
      removePoints();
    }
    chunk++;
  }

  void display() {
    Point prev = points.get(0);
    for (Point p : points) {
      draw_line(prev, p);
      //p.display_point();
      prev = p;
    }
  }

  void draw_line(Point p, Point q) {
    strokeWeight(1);
    stroke(255, 0, 0, opacity);
    if (p.id == q.id) {
      line(p.x, p.y, q.x, q.y);
      opacity += 5;
      opacity = min(opacity, 50);
    } else {
      opacity = 0;
    }
  }

  void removePoints() {
    for (int i=points.size()-1; i >= 0; i--) {
      if (chunk - points.get(i).chunk > chunk_max) {
        points.remove(i);
      }
    }
  }
}
