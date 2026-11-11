settings.outformat="pdf";
size(300);

import mosaic;
import x11colors;

// Fivefold shuriken substitution (the 12-tile version).
// Tile numbers follow Figure 8 of Frettloh, Say-awen and de las Penas:
// https://arxiv.org/abs/1602.00518
// https://tilings.math.uni-bielefeld.de/substitution/dto_c5/
real phi=(1+sqrt(5))/2;
real s=Sin(36);
currentinflation=sqrt(6+sqrt(5));

// Prototile vertices, in substitution order. T3--T5 have the same shape,
// as do T6--T7, but their edge markings give different substitution rules.
pair[][] vertices;
pair[] pentagon;
for(int k=0; k < 5; ++k)
  pentagon.push(dir(90+72*k)/(2*s));
vertices.push(pentagon);
vertices.push(new pair[] {(0,0),(2,0),(2+Cos(36),s)});
for(int k=0; k < 3; ++k)
  vertices.push(new pair[] {(0,0),(phi,0),(phi/2,s)});
for(int k=0; k < 2; ++k)
  vertices.push(new pair[] {(0,0),(1/phi,0),(1/(2*phi),Sin(72))});
// T8--T12 are the enlarged intermediate triangles.
for(int k=2; k < 7; ++k) {
  pair[] enlarged;
  for(pair p : vertices[k]) enlarged.push(currentinflation*p);
  vertices.push(enlarged);
}

// Golden autumn: gold pentagons, deeper red triangles.
pen[] colours={Gold,Yellow,Orange,DarkOrange,DarkRed,OrangeRed,Goldenrod};

// Greyscale
// pen[] colours={heavygray,palegray,gray,lightgray,deepgray,mediumgray,white};

tile[] prototiles;
substitution[] rules;
for(int k=0; k < 12; ++k) {
  guide boundary=vertices[k][0];
  for(int j=1; j < vertices[k].length; ++j)
    boundary=boundary--vertices[k][j];
  int colour=k < 7 ? k : k-5;
  tile t=tile(boundary--cycle,colours[colour]);
  prototiles.push(t);
  rules.push(substitution(t));
}

// Coordinates in a frame whose edges have directions 0, 36, 72, ... degrees.
pair grid(int a, int b, int c, int d) {
  return ((a+b*phi)/2,(c+d*phi)*s);
}

// Match three vertices, including the reflected orientation when required.
real orientation(pair a, pair b, pair c) {
  pair u=b-a, v=c-a;
  return u.x*v.y-u.y*v.x;
}

transform placement(pair a, pair b, pair c, pair A, pair B, pair C) {
  transform F=orientation(a,b,c)*orientation(A,B,C) < 0
              ? reflect(a,b) : identity;
  pair z=(B-A)/(b-a);
  return shift(A)*rotate(degrees(z))*scale(abs(z))*shift(-a)*F;
}

transform[] frames;
for(int k=0; k < 12; ++k) frames.push(identity);

// Align a dissection frame with its inflated parent tile.
void setframe(int number, pair a, pair b, pair c) {
  pair[] v=vertices[number-1];
  frames[number-1]=placement(a,b,c,currentinflation*v[0],
                            currentinflation*v[1],currentinflation*v[2]);
}

void put(int number, int kind, pair A, pair B, pair C,
         transform R=identity) {
  pair[] v=vertices[kind-1];
  rules[number-1].addtile(R*frames[number-1]*placement(v[0],v[1],v[2],A,B,C),
                           prototiles[kind-1]);
}

// Construct an isosceles triangle on the edge A--B. A negative tile number
// reverses the marked base edge; above chooses the side of that edge.
void triangle(int number, int kind, pair A, pair B, bool above=true,
              transform R=identity) {
  int k=abs(kind)-1;
  real height=k < 5 ? s : Sin(72);
  pair C=(A+B)/2+(above ? 1 : -1)*height*(rotate(90)*unit(B-A));
  if(kind > 0) put(number,kind,A,B,C,R);
  else put(number,-kind,B,A,C,R);
}

// A strip of triangles on each side of consecutive equal base edges.
// Two occupied sides make a rhombus. Zero leaves that half unoccupied.
void strip(int number, pair A, int angle, int[] above, int[] below) {
  int kind=0;
  for(int k : above) if(k != 0) {kind=abs(k); break;}
  if(kind == 0)
    for(int k : below) if(k != 0) {kind=abs(k); break;}
  real width=kind < 6 ? phi : 1/phi;
  pair step=width*dir(36*angle);
  for(int j=0; j < above.length; ++j) {
    pair a=A+j*step, b=a+step;
    if(above[j] != 0) triangle(number,above[j],a,b);
    if(below[j] != 0) triangle(number,below[j],a,b,above=false);
  }
}

// A single rhombus, with independently marked triangular halves.
void rhombus(int number, pair A, int angle, int above, int below) {
  strip(number,A,angle,new int[] {above},new int[] {below});
}

// Regular pentagons turn through 72 degrees at every vertex.
void pentagon(int number, pair A, int angle, int hand=1) {
  pair edge=dir(36*angle), B=A+edge;
  put(number,1,A,B,B+rotate(72*hand)*edge);
}

// The scalene triangle has consecutive edges of lengths 2 and 1.
void scalene(int number, pair A, int angle, int hand=1,
             transform R=identity) {
  pair edge=dir(36*angle), B=A+2*edge;
  put(number,2,A,B,B+rotate(36*hand)*edge,R);
}

// T3--T7 inflate to one enlarged intermediate triangle each.
for(int k=2; k < 7; ++k)
  rules[k].addtile(prototiles[k+5]);

// T1 substitution rule.
setframe(1,grid(0,0,0,0),grid(4,1,1,0),grid(3,2,1,3));
pentagon(1,grid(3,0,1,1),2,1);
// One sector contains a scalene triangle and four isosceles triangles.
for(int k=0; k < 5; ++k) {
  transform R=rotate(72*k);
  scalene(1,grid(1,0,3,3),9,1,R);
  triangle(1,5,grid(1,0,3,3),grid(2,0,2,2),above=true,R);
  triangle(1,4,grid(1,0,3,3),grid(2,0,2,2),above=false,R);
  triangle(1,5,grid(2,-2,2,2),grid(2,0,2,2),above=true,R);
  triangle(1,5,grid(1,1,2,3),grid(2,1,1,2),above=false,R);
}

// T2 substitution rule.
setframe(2,grid(0,0,0,0),grid(4,4,4,0),grid(2,7,5,2));
scalene(2,grid(4,4,4,0),2,-1);
scalene(2,grid(2,2,2,0),1,-1);
scalene(2,grid(0,0,0,0),1,-1);
rhombus(2,grid(2,4,4,0),1,5,5);
strip(2,grid(0,4,4,0),1,new int[] {0,0},new int[] {5,5});
rhombus(2,grid(2,3,3,0),3,7,6);
rhombus(2,grid(2,2,2,0),3,7,6);

// T8 substitution rule.
setframe(8,grid(0,0,0,0),grid(7,9,-2,-7),grid(10,4,0,0));
pentagon(8,grid(8,3,-1,-2),2,1);
pentagon(8,grid(8,5,-1,-2),7,-1);
strip(8,grid(8,0,0,0),0,new int[] {0,0},new int[] {4,4});
rhombus(8,grid(9,4,-1,-3),1,5,4);
rhombus(8,grid(8,4,0,-2),1,3,4);
rhombus(8,grid(7,4,-1,-1),2,4,3);
rhombus(8,grid(7,2,-1,-1),2,4,5);
strip(8,grid(11,5,-2,-3),3,new int[] {4,4},new int[] {0,0});
rhombus(8,grid(9,5,0,-1),4,-3,-3);
rhombus(8,grid(10,6,-2,-4),4,3,4);
rhombus(8,grid(7,1,0,-1),4,-3,-4);
rhombus(8,grid(9,7,-2,-5),4,4,4);
strip(8,grid(8,5,-1,-4),4,new int[] {3,-4,-3},new int[] {3,-4,-3});
rhombus(8,grid(5,1,0,-1),4,-4,-4);
rhombus(8,grid(8,8,-2,-6),4,4,3);
strip(8,grid(7,6,-1,-5),4,new int[] {4,-5,5,-4},new int[] {5,-5,5,-5});
rhombus(8,grid(3,1,0,-1),4,-4,-3);
rhombus(8,grid(7,9,-2,-7),4,0,3);
strip(8,grid(6,7,-1,-6),4,new int[] {0,0,0,0,0},new int[] {3,3,-4,-3,-3});
rhombus(8,grid(1,1,0,-1),4,0,-3);
rhombus(8,grid(6,7,-1,-6),1,-7,-7);
rhombus(8,grid(7,6,-1,-5),1,-7,-7);
rhombus(8,grid(8,5,-1,-4),1,-6,-6);
rhombus(8,grid(7,3,0,-1),1,-6,-6);
rhombus(8,grid(7,1,0,-1),1,7,6);
rhombus(8,grid(9,5,-2,-3),2,6,7);
rhombus(8,grid(8,5,-1,-2),2,-6,-6);
rhombus(8,grid(5,2,-1,-1),2,-6,-6);
rhombus(8,grid(3,2,-1,-1),2,-7,-7);
rhombus(8,grid(1,2,-1,-1),2,-7,-7);
rhombus(8,grid(8,4,0,-2),4,6,6);

// T9 substitution rule.
setframe(9,grid(0,0,0,0),grid(7,9,-2,-7),grid(10,4,0,0));
pentagon(9,grid(8,4,0,0),8,-1);
pentagon(9,grid(3,3,0,-1),9,-1);
pentagon(9,grid(2,2,0,0),9,-1);
pentagon(9,grid(8,5,-1,-2),1,1);
pentagon(9,grid(5,6,-1,-5),0,1);
pentagon(9,grid(8,7,-1,-6),2,1);
strip(9,grid(2,0,0,0),0,new int[] {0,0},new int[] {-5,-5});
rhombus(9,grid(6,3,-1,-2),1,5,3);
rhombus(9,grid(4,3,-1,-2),1,5,5);
rhombus(9,grid(5,3,0,-1),1,-4,-5);
rhombus(9,grid(3,3,0,-1),1,5,3);
rhombus(9,grid(6,7,-1,-4),2,3,5);
rhombus(9,grid(7,6,-1,-3),2,-5,-4);
rhombus(9,grid(6,5,-1,-4),2,5,5);
rhombus(9,grid(7,4,-1,-3),2,3,5);
strip(9,grid(8,8,-2,-6),3,new int[] {-5,-5},new int[] {0,0});
rhombus(9,grid(9,5,0,-1),4,-4,-4);
rhombus(9,grid(7,4,-1,-3),4,-4,-3);
strip(9,grid(6,5,-1,-4),4,new int[] {3,-3},new int[] {3,-3});
rhombus(9,grid(7,9,-2,-7),4,0,4);
strip(9,grid(6,7,-1,-6),4,new int[] {0,0,0,0,0},new int[] {5,5,-4,-5,-5});
rhombus(9,grid(1,1,0,-1),4,0,-4);
rhombus(9,grid(6,6,0,-4),1,-7,-7);
rhombus(9,grid(7,5,0,-3),1,-6,-6);
rhombus(9,grid(1,1,0,-1),1,7,7);
rhombus(9,grid(6,8,-2,-6),2,7,7);
rhombus(9,grid(5,4,-1,-1),2,-6,-6);
rhombus(9,grid(3,4,-1,-1),2,-7,-7);
rhombus(9,grid(8,4,0,-2),4,6,6);
rhombus(9,grid(7,7,0,-5),4,7,7);
rhombus(9,grid(3,3,0,-1),4,-7,-7);

// T10 substitution rule.
setframe(10,grid(0,0,0,0),grid(7,9,-2,-7),grid(10,4,0,0));
pentagon(10,grid(9,5,0,-1),5,1);
pentagon(10,grid(9,2,-1,-1),2,1);
pentagon(10,grid(8,4,0,-2),9,-1);
pentagon(10,grid(7,7,0,-5),6,1);
strip(10,grid(8,0,0,0),0,new int[] {0,0},new int[] {5,5});
rhombus(10,grid(7,6,-1,-5),2,-3,-3);
rhombus(10,grid(8,5,-1,-4),2,-5,-5);
rhombus(10,grid(7,4,-1,-1),2,5,3);
strip(10,grid(8,8,-2,-6),3,new int[] {-5,-5},new int[] {0,0});
rhombus(10,grid(9,5,0,-1),4,-5,-5);
rhombus(10,grid(8,3,-1,-2),4,5,5);
rhombus(10,grid(7,1,0,-1),4,5,5);
strip(10,grid(8,5,-1,-4),4,new int[] {-5,-4,5},new int[] {-5,-4,5});
rhombus(10,grid(5,1,0,-1),4,5,5);
strip(10,grid(7,6,-1,-5),4,new int[] {-3,-3,5,4},new int[] {-3,-5,5,5});
rhombus(10,grid(3,1,0,-1),4,-3,-3);
rhombus(10,grid(7,9,-2,-7),4,0,4);
strip(10,grid(6,7,-1,-6),4,new int[] {0,0,0,0,0},new int[] {5,4,-4,-3,-3});
rhombus(10,grid(1,1,0,-1),4,0,-5);
rhombus(10,grid(8,6,0,-4),0,7,6);
rhombus(10,grid(9,5,0,-3),0,-6,-6);
rhombus(10,grid(9,2,-1,-1),0,7,7);
rhombus(10,grid(7,1,0,-1),1,-7,-7);
rhombus(10,grid(6,8,-2,-6),2,7,7);
rhombus(10,grid(5,2,-1,-1),2,7,7);
rhombus(10,grid(3,2,-1,-1),2,7,7);
rhombus(10,grid(1,2,-1,-1),2,6,6);
rhombus(10,grid(9,5,0,-3),4,-7,-7);
rhombus(10,grid(8,4,0,-2),4,6,6);

// T11 substitution rule.
setframe(11,grid(0,0,0,0),grid(-8,3,-5,-2),grid(2,7,-5,-2));
pentagon(11,grid(0,4,-4,-2),5,-1);
pentagon(11,grid(-1,4,-3,-1),3,1);
pentagon(11,grid(0,4,-4,-2),9,1);
strip(11,grid(0,3,-5,-2),0,new int[] {3,4},new int[] {0,0});
rhombus(11,grid(-2,2,-4,-2),0,3,3);
rhombus(11,grid(-2,1,-3,-2),0,3,5);
rhombus(11,grid(-2,0,-2,-2),0,5,5);
rhombus(11,grid(-2,0,-2,-2),2,0,5);
rhombus(11,grid(-1,2,-3,-1),3,5,5);
rhombus(11,grid(-1,1,-2,-1),3,5,5);
strip(11,grid(2,6,-4,-2),4,new int[] {-3,-5},new int[] {0,0});
rhombus(11,grid(-2,3,-3,-2),1,7,7);
rhombus(11,grid(-1,4,-3,-1),1,7,7);
rhombus(11,grid(-2,2,-2,-2),1,7,7);
rhombus(11,grid(-2,1,-1,-2),1,6,6);
rhombus(11,grid(0,7,-5,-2),2,7,6);
rhombus(11,grid(-4,3,-5,-2),2,7,7);
rhombus(11,grid(-2,3,-3,0),2,-7,-7);
strip(11,grid(-6,3,-5,-2),2,new int[] {6,7},new int[] {6,7});
rhombus(11,grid(-2,2,-2,0),2,-7,-6);
strip(11,grid(-8,3,-5,-2),2,new int[] {0,0,0},new int[] {-7,7,7});
rhombus(11,grid(-2,1,-1,0),2,0,-6);
rhombus(11,grid(0,3,-5,-2),3,6,6);

// T12 substitution rule.
setframe(12,grid(0,0,0,0),grid(8,-3,-5,-2),grid(10,4,0,0));
pentagon(12,grid(2,1,-1,0),4,1);
rhombus(12,grid(2,1,-1,0),0,-4,-3);
strip(12,grid(2,0,0,0),0,new int[] {0,0},new int[] {-3,-3});
strip(12,grid(8,1,-1,-2),1,new int[] {3,3},new int[] {0,0});
rhombus(12,grid(6,0,-2,-2),1,3,3);
rhombus(12,grid(7,2,-1,-1),1,3,4);
strip(12,grid(4,0,-2,-2),1,new int[] {5,-5},new int[] {5,-5});
strip(12,grid(2,0,-2,-2),1,new int[] {5,-3},new int[] {5,-3});
rhombus(12,grid(3,1,-2,-1),3,-5,-3);
rhombus(12,grid(2,0,-2,-2),3,0,5);
rhombus(12,grid(1,1,-2,-1),2,-6,-6);
rhombus(12,grid(10,3,-1,0),3,-7,-7);
rhombus(12,grid(8,3,-1,0),3,-7,-7);
rhombus(12,grid(6,3,-1,0),3,-7,-6);
strip(12,grid(6,2,-2,0),3,new int[] {-7,-6},new int[] {-7,-6});
rhombus(12,grid(4,2,-2,0),3,-6,-7);
rhombus(12,grid(8,-1,-3,-2),3,7,7);
strip(12,grid(8,-2,-4,-2),3,new int[] {-7,7},new int[] {-6,7});
strip(12,grid(8,-3,-5,-2),3,new int[] {0,0,0},new int[] {-7,6,7});
rhombus(12,grid(2,-1,-1,0),3,0,-7);
rhombus(12,grid(7,2,-1,-1),4,-6,-6);
rhombus(12,grid(8,1,-1,-2),4,-6,-7);

// Number of substitutions. Starting with T1 preserves fivefold symmetry.
int n=5;
mosaic M=mosaic(n ...rules);

// Draw the patch.
filldraw(M);
