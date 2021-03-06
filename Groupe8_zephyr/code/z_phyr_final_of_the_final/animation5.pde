// ANIMATION DU DREAMCATCHER 

final int nbWeeds2 = 120;
SeaWeed2[] weeds2;
PVector rootNoise2 = new PVector(random(123456), random(123456));
int mode2 = 1;
float radius2 = 220;
Boolean noiseOn2 = true;
PVector center2;

// Fonction setup - lancement de l'animation 
void init_animation5() {
  center2 = new PVector(width/2, height/2);

  weeds2 = new SeaWeed2[nbWeeds2];
  for (int i = 0; i < nbWeeds2; i++)
  {
    weeds2[i] = new SeaWeed2(i*TWO_PI/nbWeeds2, 3*radius2);
  }
}


// Fonction draw - définition graphique de l'animation ; taille, couleur
void loop_animation5() {
  noStroke();
  fill(20, 10, 20);//, 50);
  rect(0, 0, width, height);
  rootNoise2.add(new PVector(.01, .01));
  strokeWeight(1);
  for (int i = 0; i < nbWeeds2; i++)
  {
    weeds2[i].update();
  }
  stroke(120, 0, 0, 220);
  strokeWeight(2);
  noFill();
  ellipse(center2.x, center2.y, 2*radius2, 2*radius2);
}


// Définition de Seaweed2 
class SeaWeed2
{
  final static float DIST_MAX = 5.5;//length of each segment
  final static float maxWidth = 50;//max width of the base line
  final static float minWidth = 11;//min width of the base line
  final static float FLOTATION = -3.5;//flotation constant
  float mouseDist;//mouse interaction distance
  int nbSegments;
  PVector[] pos;//position of each segment
  color[] cols;//colors array, one per segment
  float[] rad;
  MyColor myCol = new MyColor();
  float x, y;//origin of the weed
  float cosi, sinu;

  SeaWeed2(float p_rad, float p_length)
  {
    nbSegments = (int)(p_length/DIST_MAX);
    pos = new PVector[nbSegments];
    cols = new color[nbSegments];
    rad = new float[nbSegments];
    cosi = cos(p_rad);
    sinu = sin(p_rad);
    x = width/2 + radius2*cosi;
    y = height/2 + radius2*sinu;
    mouseDist = 40;
    pos[0] = new PVector(x, y);
    for (int i = 1; i < nbSegments; i++)
    {
      pos[i] = new PVector(pos[i-1].x - DIST_MAX*cosi, pos[i-1].y - DIST_MAX*sinu);
      cols[i] = myCol.getColor();
      rad[i] = 3;
    }
  }


 // Remplacer position de la souris par la main
  void update()
  {
    PVector mouse = new PVector(handX, handY);

    pos[0] = new PVector(x, y);
    for (int i = 1; i < nbSegments; i++)
    {
      float n = noise(rootNoise2.x + .002 * pos[i].x, rootNoise2.y + .002 * pos[i].y);
      float noiseForce = (.5 - n) * 7;
      if(noiseOn2)
      {
        pos[i].x += noiseForce;
        pos[i].y += noiseForce;
      }
      PVector pv = new PVector(cosi, sinu);
      pv.mult(map(i, 1, nbSegments, FLOTATION, .6*FLOTATION));
      pos[i].add(pv);

      //hand interaction
      if(pHandX != handX || pHandY != handY)
      {
        float d = PVector.dist(mouse, pos[i]);
        if (d < mouseDist)// && pmouseX != mouseX && abs(pmouseX - mouseX) < 12)
        {
          PVector tmpPV = mouse.get();       
          tmpPV.sub(pos[i]);
          tmpPV.normalize();
          tmpPV.mult(mouseDist);
          tmpPV = PVector.sub(mouse, tmpPV);
          pos[i] = tmpPV.get();
        }
      }

      PVector tmp = PVector.sub(pos[i-1], pos[i]);
      tmp.normalize();
      tmp.mult(DIST_MAX);
      pos[i] = PVector.sub(pos[i-1], tmp);
      
      //keep the points inside the circle
      if(PVector.dist(center2, pos[i]) > radius2)
      {
        PVector tmpPV = pos[i].get();
        tmpPV.sub(center2);
        tmpPV.normalize();
        tmpPV.mult(radius2);
        tmpPV.add(center2);
        pos[i] = tmpPV.get();
      }
    }

    updateColors();

    if (mode2 == 0)
    {
      stroke(0, 100);
    }
    
    // début de la forme
    beginShape();
    noFill(); 
    for (int i = 0; i < nbSegments; i++)
    { 
      float r = rad[i];
      if (mode2 == 1)
      {
        stroke(cols[i]);
        vertex(pos[i].x, pos[i].y);
        //line(pos[i].x, pos[i].y, pos[i+1].x, pos[i+1].y);
      } else
      {
        fill(cols[i]);
        noStroke();
        ellipse(pos[i].x, pos[i].y, 2, 2);
      }
    }
    
    // fin de la forme 
    endShape();
  }

  void updateColors()
  {
    myCol.update();
    cols[0] = myCol.getColor();
    for (int i = nbSegments-1; i > 0; i--)
    {
      cols[i] = cols[i-1];
    }
  }
  
  
  // Définition de la couleur 
  class MyColor
{
  float R, G, B, Rspeed, Gspeed, Bspeed;
  final static float minSpeed = .6;
  final static float maxSpeed = 1.8;
  final static float minR = 200;
  final static float maxR = 255;
  final static float minG = 20;
  final static float maxG = 120;
  final static float minB = 100;
  final static float maxB = 140;
  
  MyColor()
  {
    init();
  }
  
  public void init()
  {
    R = random(minR, maxR);
    G = random(minG, maxG);
    B = random(minB, maxB);
    Rspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Gspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Bspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
  }
  
  public void update()
  {
    Rspeed = ((R += Rspeed) > maxR || (R < minR)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > maxG || (G < minG)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > maxB || (B < minB)) ? -Bspeed : Bspeed;
  }
  
  public color getColor()
  {
    return color(R, G, B);
  }
}
}
