void display_date(float ts) {
  int x = 25;
  int y = 20;

  // date
  fill(ctext);
  textSize(20);
  textAlign(RIGHT, TOP);
  String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(ts*1000L); 
  text(date, width-x, y);
  
  // title
  fill(ctext);
  textSize(40);
  textAlign(LEFT, TOP);
  text("Madrid Biking Map", x, y);
  
  display_lines(10, 2);
}

void display_lines(int d, float sw){
  stroke(cframe);
  strokeWeight(sw);
  line(d, 0, d, height);
  line(width-d, 0, width-d, height);
  line(0, d, width, d);
  line(0, height-d, width, height-d);
}
