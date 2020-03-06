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

void process(String line) {
  String[] pieces = split(line, ",");
  id = int(pieces[0]);
  x = float(pieces[1]);
  y = float(pieces[2]);
  date = pieces[3];
  x = x*width;
  y = (1-y)*height;
}
