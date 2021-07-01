import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
PImage src, colorFilteredImage;
ArrayList<Contour> contours;
ArrayList<PVector> cornerPoints;

// <1> Set the range of Hue values for our filter
int rangeLow;
int rangeHigh;
int delay = 500;
String myCam;

SoundFile fileA = new SoundFile(this, "/Users/chandnirajendran/Documents/Sketchbook/ObjectTracking/ping.wav");
SoundFile fileB = new SoundFile(this, "/Users/chandnirajendran/Documents/Sketchbook/ObjectTracking/ping2.wav");
SoundFile fileC;
SoundFile fileD;
PImage overlay;
Boolean Q1;
Boolean Q2;
Boolean Q3;
Boolean Q4;

Dharma b = new Dharma( 500, 350, "babyD", 30, 50, fileA, false);
Dharma c = new Dharma( 250, 100, "bigD" , 100, 200, fileB, false);



//fileC = new SoundFile(this, "/Users/chandnirajendran/Documents/Sketchbook/ObjectTracking/ping3.wav");
//fileD = new SoundFile(this, "/Users/chandnirajendran/Documents/Sketchbook/ObjectTracking/ping4.wav"); 

Lemon lemon = new Lemon(320, 240);

void setup() {
            String[] cameras = Capture.list();  
            myCam = cameras[0];
            video = new Capture(this, 640, 480, myCam);
            video.start();
            
            
            opencv = new OpenCV(this, video.width, video.height);
            
            contours = new ArrayList<Contour>();
            
            //audio files
            
            
            Q1 = false;
            Q2 = false;
            Q3 = false;
            Q4 = false;
}

void settings() {
              size(1280, 480, P2D);
}

void draw() {
            if (video.available()) {
              video.read();
            }
            opencv.loadImage(video);
            opencv.useColor();
            src = opencv.getSnapshot();
            opencv.useColor(HSB);
            opencv.setGray(opencv.getH().clone());
            opencv.inRange(rangeLow, rangeHigh);
            colorFilteredImage = opencv.getSnapshot();
            contours = opencv.findContours(true, true);
            image(src, 0, 0);
            image(colorFilteredImage, src.width, 0);
            

             b.disp();
             c.disp();
             lemon.track();
            
}



void mousePressed() {
              color c = get(mouseX, mouseY);
              println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
              int hue = int(map(hue(c), 0, 255, 0, 180));
              println(hue(c));
              println("hue to detect: " + hue);
              println(contours.size());      
              rangeLow = hue - 2;
              rangeHigh = hue + 2;
}

class Lemon{
    int x,y;
    Lemon(int _x, int _y){
          x = _x;
          y = _y;
    }
  
     void track(){
            noStroke(); 
            fill(255, 0, 0);
            ellipse(x, y, 15, 15);
       
     if (contours.size() > 0) {
              Contour biggestContour = contours.get(0);
              Rectangle r = biggestContour.getBoundingBox();
              noStroke(); 
              fill(255, 0, 0);
              ellipse(r.x + r.width/2, r.y + r.height/2, 30, 30);
              x= r.x + r.width/2;
              y= r.y + r.height/2;
            }
     }
}

class Dharma{
          int x,y,sizeX,sizeY;
          String name;
          SoundFile audioFile;
          Boolean enter;
          Dharma(int _x, int _y, String _name, int _sizeX, int _sizeY, SoundFile _audioFile, Boolean _enter)
          {
            x = _x;
            y = _y;
            name=_name;
            sizeX = _sizeX;
            sizeY = _sizeY;
            audioFile = _audioFile;
            enter = _enter;
          }
  
           void disp()
            {
              noFill();
              stroke(0, 255, 0);
              rect(x,y,sizeX,sizeY);
              int currentX= lemon.x;
              int currentY= lemon.y;
              //ArrayList<Dharma> list = new ArrayList<Dharma>();
              if(isOver(currentX,currentY,name)) { 
                          if (enter == false){
                               audioFile.play();
                               println("isover-"+name);
                               enter=true;
                          }
                       } else {
                         //fileD.stop();
                         enter= false;
                       }
          }
  
          boolean isOver(int mx, int my, String name)
          {
            if (mx > x 
                && mx < x+sizeX
                && my > y
                && my < y+sizeY)
              {
                println("isover-"+name);
                return true;
              }
              else
              {
                return false;
              }
          }
}