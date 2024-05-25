settings.outformat="pdf";
size(300);

import mosaic;

// angles (radians) - optimized for uniform distribution
real w=(sqrt(5)-1)/2;
real alph=pi*w^3;   
real beta=(pi-alph)/2;  
write("alph=",alph);
write("beta=",beta);

// angles (degrees)
real Alph=alph*180/pi;
real Beta=beta*180/pi;

// sides
real a = 1;
real b = sin(alph)/sin(beta);
real c = 2b^2*cos(beta);

// inflation factor
newinflation=1+b^2;
write("inflation=",inflation);

// threshold area for subdivision
real area=c*b^2*sin(beta)/2;  // area of the protile
area=area-exp(-20); // ensure subdivision when equal to threshold
write("threshold=",area);

// line colour and width
pen linePen=black+0.02;  

// colours
pen pen1=lightblue;  // top
pen pen2=palered;  // bottom left
pen pen3=lightred;  // bottom right
pen pen4=lightred;  // middle

// image settings
real sepX=1.25*c; 
real sepY=1.25*b^2*sin(beta);

// vertices in the substitution rclockwise)
pair q1=(0,0);
pair q2=(c,0);
pair q3=(b+c,0);
pair q4=(c+b*cos(alph),b*sin(alph));
pair q5=((b^2+b^3/c)*cos(beta),(b^2+b^3/c)*sin(beta));
pair q6=(b^2*cos(beta),b^2*sin(beta));

// tiles in the isosceles substitution
tile U1=q1--q2--q6--cycle;
tile U2=q2--q3--q4--cycle;
tile U3=q4--q5--q6--cycle;
tile U4=q2--q4--q6--cycle;

// prototile
tile iso=tile((q1--q2--q6--cycle),drawpen=linePen,fillpen=pen1);
substitution isoSub=substitution(iso);

// subdivide rule
real isoDefl=c/(b+c);
isoSub.addtile(scale(isoDefl),pen2);
isoSub.addtile(shift(q6*isoDefl)*scale(isoDefl*b/c),pen1);
isoSub.addtile(shift(q3*isoDefl)*rotate(180-Beta)*scale(isoDefl/b),pen3);
isoSub.addtile(shift(q6*isoDefl)*rotate(-Beta)*scale(isoDefl*b^2/c),pen4);

bool drawall=true;

if(drawall) {

  int n=0;
  mosaic m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(m);

  n=1;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(sepX,0)*m);

  n=2;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(2sepX,0)*m);

  n=3;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(0,-sepY)*m);

  n=4;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(sepX,-sepY)*m);

  n=5;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(2sepX,-sepY)*m);

  n=6;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(0,-2sepY)*m);

  n=7;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(sepX,-2sepY)*m);

  n=8;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(shift(2sepX,-2sepY)*m);

  n=9;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  //filldraw(shift(0,-3sepY)*m);

  n=10;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  //filldraw(shift(sepX,-3sepY)*m);

  n=11;
  m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  //filldraw(shift(2sepX,-3sepY)*m);

} else {
  int n=10;
  mosaic m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
  filldraw(m);

  bool clipPatch=false;
  real boxLength=0.25;
  path clipBox=(0,0)--(boxLength,0)--(boxLength,boxLength)--(0,boxLength)--cycle;
  clipBox=shift(boxLength,0)*clipBox;
  clip(g=clipBox);
}

bool writeTileCount=false;
int N=10;

if(writeTileCount){
write("tile count:");
for(int n=1; n<N; ++n){
mosaic m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
write(m.tilecount[n]);
}

write("tile count succesive ratios:");
for(int n=1; n<N; ++n){
mosaic m=mosaic(iso,n,multiscale=true,threshold=area,isoSub);
write(m.tilecount[n]/m.tilecount[n-1]);
}
}
