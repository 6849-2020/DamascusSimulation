PShape s;
import queasycam.*;

QueasyCam cam;

ArrayList<float[]> current;
String[] colors;

void setup() {
  size(1920, 1080, P3D);
  cam = new QueasyCam(this);
  writeNew();
  current = getCurrent();
  
}

void draw() {
  background(125);
  lights();
  translate(width/2, height/2);
  display();
  //shape(s, 0, 0);
}

/**
display points in current based on the color index
*/
void display(){
  for(int i = 0; i < current.size(); i++){
    if(colors[i].equals("1")){
       fill(255); 
    }
    else{
       fill(0);
    }
    pushMatrix();
    translate(current.get(i)[0] * 1000, current.get(i)[1] * 1000, current.get(i)[2] * 1000);
    sphere(10);
    popMatrix();
  }
}

/**
reads current points from obj file, puts them into current
*/
ArrayList<float[]> getCurrent() {
  ArrayList<float[]> newCurrent = new ArrayList<float[]>();
  String[] lines = loadStrings("damascusBox.obj");
  for (String i : lines) {

    if (i.substring(0, 1).equals("v")) {
      String[] spl = i.split(" ");
      float[] newCoord = new float[] {Float.parseFloat(spl[1]), Float.parseFloat(spl[2]), Float.parseFloat(spl[3])};
     
      if (newCoord[0] > .475 && newCoord[0] < .525 && newCoord[1] > .475 && newCoord[1] < .525) {
        newCurrent.add(newCoord);
      }
    }
  }

  return newCurrent;
}

/**
Cuts current in half, then
*/
ArrayList<float[]> cut(ArrayList<float[]> current) {
  ArrayList<float[]> newCurrent = new ArrayList<float[]>();
  for(float[] i : current){
    if(i[2] >= 0){
      newCurrent.add(new float[] {i[0], i[1] + .0125, i[2] - .15});
    }
    else{
      newCurrent.add(new float[] {i[0], i[1] - .0125, i[2] + .15});

    }
  }

  return newCurrent;
}

String[] colorIndex(ArrayList<float[]> current) {
  String[] colorIndex = new String[current.size()];
  int count = 0;
  for (float[] i : current) {
    if (
      (i[2] > .48 && i[2] < .485) ||
      (i[2] > .5 && i[2] < .505) ||
      (i[2] > .51 && i[2] < .515) ||
      (i[2] > .520 && i[2] < .525)
      ) {
      colorIndex[count] = "2";
    } else {
      colorIndex[count] = "1";
    }
    count++;
  }
  colors = colorIndex;
  saveStrings("colorIndex.txt", colorIndex);
  return colorIndex;
}


/**
test method
initialize a .obj with hardcoded layers and faces
*/
void writeNew() {
  String[] newBox = new String[17576 + 12 + 5];
  String[] colorIndex = new String[17576];
  newBox[0] = "# 17576 points";
  newBox[1] = "# 17576 vertices";
  newBox[2] = "# 17576 primitives";
  newBox[3] = "# Bounds: [0.475, 0.475, 0.475] to [0.525, 0.525, 0.525]";
  newBox[4] = "g";
  int count = 0;

  ArrayList<Integer> corners = new ArrayList<Integer>();

  for (float i = .475; i <= .525; i += .002) {
    for (float j = .475; j <= .525; j += .002) {
      for (float k = .475; k <= .525; k += .002) {

        newBox[count + 5] = "v " + i + " " + j + " " + k;
        if (
          (k > .48 && k < .485) ||
          (k > .5 && k < .505) ||
          (k > .51 && k < .515) ||
          (k > .520 && k < .525)
          ) {

          colorIndex[count] = "2";
        } else {
          colorIndex[count] = "1";
        }
        // print(count + "\n");

        count++;
        if ((i == .475 || i > .524) && (j == .475 || j > .524) &&( k == .475 || k > .524) ) {

          corners.add(count);
        }
      }
    }
  }
  int[][] faces = new int[][] { {1, 2, 3}, {2, 3, 4}, {2, 4, 8}, {2,6,8}, {1, 5, 7}, {1, 3, 7}, {5, 6, 8}, {5, 7, 8}, {1, 2, 5}, {2, 5, 6}, {3, 4, 7}, {4, 7, 8}};
  for (int[] i : faces) {
    newBox[count + 5] = "f " + corners.get(i[0] - 1) + " " + corners.get(i[1] - 1) + " " + corners.get(i[2] - 1);
    count++;
  }
  colors = colorIndex;
  saveStrings("damascusBox.obj", newBox);
  saveStrings("colorIndex.txt", colorIndex);
}




/**
Saves new obj file after the cut is performed
*/
void saveCut(){
  String[] newBox = new String[current.size() + 5];
  newBox[0] = "# " + current.size() + " points";
  newBox[1] = "# " + current.size() + " vertices";
  newBox[2] = "# " + current.size() + " primitives";
  newBox[3] = "# Bounds: [0, 0., 0] to [1, 1, 1]";
  newBox[4] = "g";
  int count = 0;

  for (float i = .475; i <= .525; i += .002) {
    for (float j = .475; j <= .525; j += .002) {
      for (float k = .475; k <= .525; k += .002) {

        newBox[count + 5] = "v " + i + " " + j + " " + k;
        
        count++;

      }
    }
  }

  saveStrings("cutBox.obj", newBox);
}
