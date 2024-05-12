settings.outformat="pdf";
//settings.render=32;
size(300);

import mosaic;


// angles (radians)
real w=(sqrt(5)-1)/2;
real alph=pi*w^3;  // Ex.1
real alph=pi*w;  // Ex.2
//real alph=pi/4;  // Ex.3
//real beta=(1-epsi)*alph;
//real epsi=0.6;  // general case (use 0.38196<epsi<1/2)
real beta=(pi-alph)/2;  // Ex.1, Ex.2: case beta=gamm
//real beta=pi/3;  // Ex.3
real gamm=pi-alph-beta;

// angles (degrees)
real Alph=alph*180/pi;
real Beta=beta*180/pi;
real Gamm=gamm*180/pi;

if(beta<0) write("Warning: beta<0");
if(gamm<0) write("Warning: gamm<0");

// sides
real a = sin(beta)/sin(gamm);
real b = sin(alph)/sin(beta);
real c = 2a*b^2*cos(gamm);


//newinflation=1+b^2; // Ex.1
newinflation=(1+b^2)/b^2; // Ex.2

// image settings
// real sepX=1.25;
real sepX=1.25*c;
//real sepY=a*sin(alph);
real sepY=1.25*a*b^2*sin(gamm);

// line colour and width
pen linePen=black+0.005;

// colours
//pen scaP1=paleblue;
//pen scaP2=lightblue;
//pen isoP1=paleyellow;
pen scaP1=invisible;
pen scaP2=invisible;
pen isoP1=invisible;

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
tile sca=tile((p1--p2--p6--cycle),drawpen=linePen);
tile iso=tile((q1--q2--q6--cycle),drawpen=linePen);

// initialize substitutions
substitution scaSub=substitution(sca);
substitution isoSub=substitution(iso);

// scaling factors
real scaDefl=1/(1+b^2);
real isoDefl=c/(c+a*b);

// scalene tile substitution
transform r=shift(-2a*cos(alph),0)*reflect(p6,(a*cos(alph),0));  // vertical reflection through p6
scaSub.addtile(identity*scale(scaDefl),sca,scaP1);
scaSub.addtile(shift(scaDefl*(1+b*cos(gamm),b*sin(gamm)))*scale(b/a)*rotate(Gamm+Alph)*r*scale(scaDefl),sca,scaP2);
scaSub.addtile(shift(scaDefl*p2)*scale(b)*rotate(Gamm)*scale(scaDefl),sca,scaP1);
scaSub.addtile(shift(scaDefl*p4)*rotate(Alph+Gamm)*scale(scaDefl),iso,isoP1);

// isosceles tile substitution
isoSub.addtile(identity*scale(isoDefl),iso,isoP1);
isoSub.addtile(shift(isoDefl*q2)*scale(b)*rotate(-Beta-Gamm)*r*scale(isoDefl),sca,scaP2);
isoSub.addtile(shift(isoDefl*q6)*scale(a*b/c)*scale(isoDefl),iso,isoP1);
isoSub.addtile(shift(isoDefl*q4)*scale(b)*rotate(Alph)*r*scale(isoDefl),sca,scaP2);


// draw the starting tile and first 5 iterations

bool drawall=false;

if(drawall) {
  int n=0;
  //mosaic m0=mosaic(sca,n,scaSub,isoSub);
  mosaic m0=mosaic(iso,n,scaSub,isoSub);
  //filldraw(p1--p2--p6--cycle,fillpen=lightgray,drawpen=linePen);
  draw(q1--q2--q6--cycle,linePen);

  n=1;
  //mosaic m1=mosaic(sca,n,scaSub,isoSub);
  mosaic m1=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(sepX,0)*m1);

  n=2;
  //mosaic m2=mosaic(sca,n,scaSub,isoSub);
  mosaic m2=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(2sepX,0)*m2);

  n=3;
  //mosaic m3=mosaic(sca,n,scaSub,isoSub);
  mosaic m3=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(0,-sepY)*m3);

  n=4;
  //mosaic m4=mosaic(sca,n,scaSub,isoSub);
  mosaic m4=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(sepX,-sepY)*m4);

  n=5;
  //mosaic m5=mosaic(sca,n,scaSub,isoSub);
  mosaic m5=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(2sepX,-sepY)*m5);

  n=6;
  //mosaic m6=mosaic(sca,n,scaSub,isoSub);
  mosaic m6=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(0,-2sepY)*m6);

  n=7;
  //mosaic m6=mosaic(sca,n,scaSub,isoSub);
  mosaic m7=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(sepX,-2sepY)*m7);

  n=8;
  //mosaic m6=mosaic(sca,n,scaSub,isoSub);
  mosaic m8=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(2sepX,-2sepY)*m8);
} else {
  int n=10;
  //mosaic m1=mosaic(sca,n,scaSub,isoSub);
  mosaic m1=mosaic(iso,n,true,scaSub,isoSub);
  draw(shift(sepX,0)*m1);

}
write("alph=",alph);
write("beta=",beta);
write("gamm=",gamm);
