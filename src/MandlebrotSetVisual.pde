import java.util.HashMap;
import java.awt.geom.Point2D;

// Initiate starting variables and hashmap
HashMap<Coordinate, Integer> solved = new HashMap<Coordinate, Integer>();
float scrollCounter = 1;
float scrollMultiplier = 0.1;
float mx = 0.0;
float my = 0.0;
int maxI;
int pixelsSolved = 0;

void setup(){
  // Create 800x800 window
  size(800, 800);
}



void draw(){
  loadPixels();
  // Run for all pixels in the window
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      
      double ai = map(x, 0, width, -2*scrollCounter+mx*(abs(1 - scrollCounter)), 0.47*scrollCounter+mx*(abs(1 - scrollCounter)));
      double bi = map(y, 0, height, -1.12*scrollCounter+my*(abs(1 - scrollCounter)), 1.12*scrollCounter+my*(abs(1 - scrollCounter)));
      
      Coordinate ab = new Coordinate(ai, bi);
      
      int i = 0;
      
      if (solved.get(ab) == null){
        double a = ai;
        double b = bi;
        
        // Set the maximum iterations of the calculations before determining divergence
        // This is also the accuracy setting
        maxI = 500;
        
        double aTemp = 0;
        // Run Mandlebrot set equation, z(n+1) = z(n)^2 + c
        while(i < maxI){
          aTemp = a*a - b*b + ai;
          b = 2*a*b + bi;
          a = aTemp;
          i++;
          if(a*a + b*b >= 4){
            solved.put(ab, i);
            break;
          }
        }if(i >= maxI){
          solved.put(ab, i);
        }
      }else{
        i = solved.get(ab);
      }
      
      // Coloring pixels
      colorMode(HSB, 360, 100, 100);
      color c;
      int hue;
      int sat;
      int bright = 100;
      
      hue = int(360 * i / maxI);
      sat = 100;
      if (i < maxI){
        bright = 100;
      }else if(i >= maxI){
        bright = 0;
      }
      c = color(hue,  sat, bright);
      
      pixels[y*width+x] = c;
    }
  }
  // Run zoom function
  mouseWheel();
  // Update all pixels at once
  updatePixels();
}

// Mouse wheel scroll feature
void mouseWheel(MouseEvent event){
  mx = map(mouseX, 0, width, -2*scrollCounter+mx*(1 - scrollCounter), 0.47*scrollCounter+mx*(1 - scrollCounter));
  my = map(mouseY, 0, height, -1.12*scrollCounter+my*(1 - scrollCounter), 1.12*scrollCounter+my*(1 - scrollCounter));
  if ((event.getCount() == 1) && (scrollCounter > scrollMultiplier)){
    scrollCounter = scrollCounter - scrollMultiplier;
  }else if((event.getCount() == -1) && (scrollCounter < 1)){
    scrollCounter = scrollCounter + scrollMultiplier;
  }
  if((scrollCounter <= scrollMultiplier)&&(scrollCounter > scrollMultiplier*0.1)){
    scrollMultiplier = scrollMultiplier*0.1;
  }else if((scrollCounter > scrollMultiplier*10)){
    scrollMultiplier *= 10;
  }
  if(scrollCounter >= 1){
    scrollCounter = 1;
    scrollMultiplier = 0.1;
  }
  println("scroll counter: " + scrollCounter);
  println("scroll multiplier: " + scrollMultiplier);
  println("maxI: "+ maxI);
  
}


void keyPressed(){
  // Press 'r' to reset image
  if(key == 'r'){
    scrollCounter = 1;
  }
  // Test benchmark to see how many pixels have been solved
  if(key == 'p'){
    println("Solved: "+ solved.size());
  }
}

// Click and drag feature
void mouseDragged(MouseEvent event){
  mx = mx - map(mouseX, 0, width, -2*scrollCounter+mx*(abs(1 - scrollCounter)), 0.47*scrollCounter+mx*(abs(1 - scrollCounter))) + map(pmouseX, 0, width, -2*scrollCounter+mx*(abs(1 - scrollCounter)), 0.47*scrollCounter+mx*(abs(1 - scrollCounter)));
  my = my - map(mouseY, 0, height, -1.12*scrollCounter+my*(abs(1 - scrollCounter)), 1.12*scrollCounter+my*(abs(1 - scrollCounter))) + map(pmouseY, 0, height, -1.12*scrollCounter+my*(abs(1 - scrollCounter)), 1.12*scrollCounter+my*(abs(1 - scrollCounter)));
}
