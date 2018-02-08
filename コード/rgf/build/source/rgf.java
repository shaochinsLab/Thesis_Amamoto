import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class rgf extends PApplet {

public void setup() {
  RestricedGrowthFunction rgf = new RestricedGrowthFunction(5,3) ;
  do {
      println(rgf) ;
  } while (rgf.increment()) ;
  exit() ;
}
class RestricedGrowthFunction {
  int[] body ;
  int upperLimit ;
  int[] bMax ;
  RestricedGrowthFunction(int n, int m) {
    body = new int[n] ;
    upperLimit = m - 1 ;
    bMax = new int[n] ;
    normalize() ;
  }
  public String toString() {
    return join(nf(body, 0), ",") ;
  }
  public boolean increment() {
    for (int i = body.length - 1 ; i > 0 ; i--) {
      if (body[i] == min(bMax[i] + 1, upperLimit)) {
        body[i] = 0 ;
      }
      else {
        body[i]++ ;
        if (body[i] > bMax[i]) {
          for (int j = i + 1 ; j < body.length ; j++)
            bMax[j] = body[i] ;
        }
        normalize() ;
        return true ;
      }
    }
    return false ;
  }
  public void normalize() {
    for (int j = 1 ; j < body.length ; j++) {
      int k = body.length - j ;
      int v = upperLimit + 1 - j ;
      if (bMax[k] >= v) break ;
      body[k] = v ;
      bMax[k] = v - 1 ;
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rgf" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
