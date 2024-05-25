settings.outformat="pdf";
size(300);

import mosaic;

string angleOrder="alpha-beta-gamma";
//string angleOrder="beta-alpha-gamma";
//string angleOrder="alpha-gamma-beta";

// angles (radians) - optimized for uniform distribution
real alph;
real beta;
real gamm;

if(angleOrder=="alpha-beta-gamma"){
  alph=pi*(7-sqrt(37))/3;   
  beta=pi*(-5+sqrt(37))/4; 
  gamm=pi*(-1+sqrt(37))/12;
}else if(angleOrder=="alpha-gamma-beta"){
  alph=pi*(7-sqrt(37))/3;  
  gamm=pi*(-5+sqrt(37))/4;
  beta=pi*(-5+sqrt(37))/4; 
}else if(angleOrder=="beta-alpha-gamma"){
  beta=pi*(7-sqrt(37))/3;   
  alph=pi*(-5+sqrt(37))/4;  
  gamm=pi*(-1+sqrt(37))/12;
}


// choose best start triangle
bool isostart;
if(angleOrder=="alpha-beta-gamma" | angleOrder=="beta-alpha-gamma"){
  isostart=true;
}else if(angleOrder=="alpha-gamma-beta" | angleOrder=="beta-gamma-alpha"){
  isostart=false;
}
write("isostart=",isostart);

write("alph=",alph);
write("beta=",beta);
write("gamm=",gamm);

// angles (degrees)
real Alph=alph*180/pi;
real Beta=beta*180/pi;
real Gamm=gamm*180/pi;

// sides
real a = sin(beta)/sin(gamm);
real b = sin(alph)/sin(beta);
real c = 2a*b^2*cos(gamm);

// inflation factor
if(isostart==true){
  newinflation=1+2*b*cos(gamm);  // keep top triangle the same
  //newinflation=1+a*b/c;  // keep bottom left triangle the same
  }else{
    newinflation=1+b^2;  // keep bottom left triangle the same
  }
write("inflation=",newinflation);


// thresholds
real area;
if(isostart==true){
  area=c*a*b^2*sin(gamm)/2;  // area of iso 
}else{
  area=a*sin(alph)/2;  // area of sca when alph is acute
}

area=area-exp(-20); // ensure subdivision when equal to threshold
write("threshold=",area);

// line colour and width
pen linePen=black+0.02;  

// colours
bool colourTiles=false;
pen pen1=invisible;
pen pen2=invisible;
pen pen3=invisible;
pen pen4=invisible;
if(colourTiles){
pen pen1=lightblue;  // iso top
pen pen2=lightred;  // iso middle
pen pen3=palered;  // iso bottom left
}

// image settings
real sepX;
real sepY;
if(isostart){
  sepX=1.25*c; 
  sepY=1.25*a*b^2*sin(gamm); 
}else{
  sepX=1.25(1+b^2+a*cos(pi-alph)); 
  sepY=1.25a*sin(alph);  
}

// points in the scalene substitution (counterclockwise)
pair p1=(0,0);
pair p2=(1,0);
pair p3=((1+b^2,0));
pair p4=(1+b*cos(gamm),b*sin(gamm));
pair p5=((a+a*b^2)*cos(alph),(a+a*b^2)*sin(alph));
pair p6=(a*cos(alph),a*sin(alph));

// tiles in the scalene substitution
tile T1=p1--p2--p6--cycle;
tile T2=p2--p3--p4--cycle;
tile T3=p4--p5--p6--cycle;
tile T4=p2--p4--p6--cycle;

// points in the isosceles substitution (counterclockwise)
pair q1=(0,0);
pair q2=(c,0);
pair q3=(c+a*b,0);
pair q4=(c+b*cos(alph),b*sin(alph));
pair q5=((a*b^2+a^2*b^3/c)*cos(gamm),(a*b^2+a^2*b^3/c)*sin(gamm));
pair q6=(a*b^2*cos(gamm),a*b^2*sin(gamm));

// tiles in the isosceles substitution
tile U1=q1--q2--q6--cycle;
tile U2=q2--q3--q4--cycle;
tile U3=q4--q5--q6--cycle;
tile U4=q2--q4--q6--cycle;

// prototiles
tile sca=tile((p1--p2--p6--cycle),drawpen=linePen, fillpen=pen2);
tile iso=tile((q1--q2--q6--cycle),drawpen=linePen, fillpen=pen1);


// initialize substitutions
substitution scaSub=substitution(sca);
substitution isoSub=substitution(iso);

// scaling factors
real scaDefl=1/(1+b^2);
real isoDefl=c/(c+a*b);

// scalene tile substitution
transform r=shift(-2a*cos(alph),0)*reflect(p6,(a*cos(alph),0));  // vertical reflection through p6
scaSub.addtile(identity*scale(scaDefl),sca,pen2);
scaSub.addtile(shift(scaDefl*(1+b*cos(gamm),b*sin(gamm)))*scale(b/a)*rotate(Gamm+Alph)*r*scale(scaDefl),sca,pen2);
scaSub.addtile(shift(scaDefl*p2)*scale(b)*rotate(Gamm)*scale(scaDefl),sca,pen2);
scaSub.addtile(shift(scaDefl*p4)*rotate(Alph+Gamm)*scale(scaDefl),iso,pen1);

// isosceles tile substitution
isoSub.addtile(identity*scale(isoDefl),iso,pen3);
isoSub.addtile(shift(isoDefl*q2)*scale(b)*rotate(-Beta-Gamm)*r*scale(isoDefl),sca,pen2);
isoSub.addtile(shift(isoDefl*q6)*scale(a*b/c)*scale(isoDefl),iso,pen1);
isoSub.addtile(shift(isoDefl*q4)*scale(b)*rotate(Alph)*r*scale(isoDefl),sca,pen2);


// draw the starting tile and first 5 iterations

bool drawall=true;
bool clipPatch=false;
bool writeTileCount=false;
int N=10; // iterations for tile count

if(drawall) {

  int n=0;
  mosaic m;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(m);

  n=1;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(sepX,0)*m);

  n=2;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(2sepX,0)*m);

  n=3;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(0,-sepY)*m);

  n=4;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(sepX,-sepY)*m);

  n=5;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(2sepX,-sepY)*m);

  n=6;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(0,-2sepY)*m);

  n=7;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(sepX,-2sepY)*m);

  n=8;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(shift(2sepX,-2sepY)*m);

  n=9;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  //filldraw(shift(0,-3sepY)*m);

  n=10;
  if(isostart){
    //m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    //m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  //filldraw(shift(sepX,-3sepY)*m);

  n=11;
  if(isostart){
    //m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    //m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  //filldraw(shift(2sepX,-3sepY)*m);

} else {
  int n=1;
  mosaic m;
  if(isostart){
    m=mosaic(iso,n,multiscale=true,threshold=area,scaSub,isoSub);
  }else{
    m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  }
  filldraw(m);

  real boxLength=0.25;
  path clipBox=(0,0)--(boxLength,0)--(boxLength,boxLength)--(0,boxLength)--cycle;
  clipBox=shift(boxLength,0)*clipBox;
  if(clipPatch) clip(g=clipBox);
}

if(writeTileCount){
write("tile count:");
for(int n=1; n<N; ++n){
mosaic m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
write(m.tilecount[n]);
}

write("tile count succesive ratios:");
for(int n=1; n<N; ++n){
mosaic m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
write(m.tilecount[n]/m.tilecount[n-1]);
}
}
