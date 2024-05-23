settings.outformat="pdf";
size(300);

import mosaic;

real w=(sqrt(5)-1)/2;  // inverse golden mean

// Example 1: golden angle cubed, isosceles
// angles (radians)
// real alph=pi*w^3;
// real beta=(pi-alph)/2;
// real gamm=pi-alph-beta;
// bool isostart=true;

// Example 2: golden angle, isosceles
// real alph=pi*w;
// real beta=(pi-alph)/2;
// real gamm=pi-alph-beta;
// bool isostart=true;

// Example 3: golden angle, scalene
 real alph=pi*w;
 real beta=pi*w^3;
 real gamm=pi-alph-beta;
 bool isostart=false;

// Example 4: golden angle, scalene
//real alph=pi*w;
//real epsi=0.6;  // (needs 0.38196<epsi<1/2)
//real beta=(1-epsi)*alph;
//real gamm=pi-alph-beta;
//bool isostart=false;

// Example 5: rational angles (w.r.t. pi), scalene
//real alph=pi/4;
//real beta=pi/3;
//real gamm=pi-alph-beta;
//bool isostart=true;

// Example 6: optimal angles, isosceles
//real alph=pi*(2-sqrt(3));
//real beta=pi*(sqrt(3)-1)/2;
//real gamm=beta;
//bool isostart=true;

// angles (degrees)
real Alph=alph*180/pi;
real Beta=beta*180/pi;
real Gamm=gamm*180/pi;

write("alph=",alph);
write("beta=",beta);
write("gamm=",gamm);

if(alph<0) write("Warning: alph<0");
if(beta<0) write("Warning: beta<0");
if(gamm<0) write("Warning: gamm<0");
if(alph>pi) write("Warning: alph>pi");
if(beta>pi) write("Warning: beta>pi");
if(gamm>pi) write("Warning: gamm>pi");

// sides
real a = sin(beta)/sin(gamm);
real b = sin(alph)/sin(beta);
real c = 2a*b^2*cos(gamm);

// inflation factor
// newinflation=1+b^2; // Ex.1: keep top triangle same size
// newinflation=(1+b^2)/b^2; // Ex.2: keep bottom left triangle same size
//newinflation=newinflation=(b/(2*cos(gamm))+b^2)/(b/(2*cos(gamm))); // Ex.2: keep top triangle same size
//newinflation=(1+b^2)/b; // Ex.3: keep middle triangle same size
//newinflation=(1+b^2)*sqrt(sin(pi-alph)/(b^2*c*sin(gamm)));  // Ex.3: keep top triangle same size
newinflation=(a*b+c)/c;  // Ex.3: make bottom right of isosceles same size in iteration 2
//newinflation=(b/(2*cos(gamm))+b^2)/b^2; // Ex.4: keep bottom left triangle same size
//newinflation=1; // Ex.5: TBD
//newinflation=1+b^2; // Ex. 6: keep top triangle same size
write("inflation=",newinflation);

// thresholds
real area=c*a*b^2*sin(gamm)/2;  // area of iso
//real area=a*sin(alph)/2;  // area of sca when alph is acute
//real area=a*sin(pi-alph)/2;  // area of sca when alph is obtuse
area=area-exp(-20); // ensure subdivision when equal to threshold
write("threshold=",area);

// image settings
//real sepX=1.25*c; // for iso case
//real sepY=1.25*a*b^2*sin(gamm); // for iso case
real sepX=0.5*(1+b^2+a*cos(pi-alph)); // for sca case
real sepY=1.25a*sin(alph);  // for sca case

// line colour and width
pen linePen=black+0.01;

// colours
pen scaPen=paleblue;
//pen scaPen=lightblue;
pen isoPen=paleyellow;
//pen scaPen=paleblue;
//pen isoPen=lightred;
//pen scaPen=invisible;
//pen isoPen=invisible;

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
tile sca=tile((p1--p2--p6--cycle),drawpen=linePen, fillpen=scaPen);
tile iso=tile((q1--q2--q6--cycle),drawpen=linePen, fillpen=isoPen);

// starting tile
if(isostart){
  tile starttile=copy(iso);
}else{
  tile starttile=copy(sca);
}


// initialize substitutions
substitution scaSub=substitution(sca);
substitution isoSub=substitution(iso);

// scaling factors
real scaDefl=1/(1+b^2);
real isoDefl=c/(c+a*b);

// scalene tile substitution
transform r=shift(-2a*cos(alph),0)*reflect(p6,(a*cos(alph),0));  // vertical reflection through p6
scaSub.addtile(identity*scale(scaDefl),sca,scaPen);
scaSub.addtile(shift(scaDefl*(1+b*cos(gamm),b*sin(gamm)))*scale(b/a)*rotate(Gamm+Alph)*r*scale(scaDefl),sca,scaPen);
scaSub.addtile(shift(scaDefl*p2)*scale(b)*rotate(Gamm)*scale(scaDefl),sca,scaPen);
scaSub.addtile(shift(scaDefl*p4)*rotate(Alph+Gamm)*scale(scaDefl),iso,isoPen);

// isosceles tile substitution
isoSub.addtile(identity*scale(isoDefl),iso,isoPen);
isoSub.addtile(shift(isoDefl*q2)*scale(b)*rotate(-Beta-Gamm)*r*scale(isoDefl),sca,scaPen);
isoSub.addtile(shift(isoDefl*q6)*scale(a*b/c)*scale(isoDefl),iso,isoPen);
isoSub.addtile(shift(isoDefl*q4)*scale(b)*rotate(Alph)*r*scale(isoDefl),sca,scaPen);


// draw the starting tile and first 5 iterations

bool drawall=false;
bool clipPatch=false;
bool writeTileCount=false;
int N=10; // number of iterations to print tile count

if(drawall) {

  int n=0;
  mosaic m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //numtiles=m0.tilecount[n];
  //mosaic m0=mosaic(iso,n,scaSub,isoSub);
  filldraw(m);
  //draw(q1--q2--q6--cycle,linePen);

  n=1;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m1=mosaic(iso,n,true,scaSub,isoSub);
  filldraw(shift(sepX,0)*m);

  n=2;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m2=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(2sepX,0)*m);

  n=3;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m3=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(0,-sepY)*m);

  n=4;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m4=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(sepX,-sepY)*m);

  n=5;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m5=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(2sepX,-sepY)*m);

  n=6;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m6=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(0,-2sepY)*m);

  n=7;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m7=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(sepX,-2sepY)*m);

  n=8;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m8=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  filldraw(shift(2sepX,-2sepY)*m);

  n=9;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m8=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  //filldraw(shift(0,-3sepY)*m);

  n=10;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m8=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  //filldraw(shift(sepX,-3sepY)*m);

  n=11;
  m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
  //mosaic m8=mosaic(iso,n,multiscale=true,scaSub,isoSub);
  //filldraw(shift(2sepX,-3sepY)*m);

} else {
  int n=12;
  //mosaic m=mosaic(sca,n,scaSub,isoSub);
  //mosaic m=mosaic(iso,n,true,scaSub,isoSub)
  mosaic m=mosaic(sca,n,multiscale=true,threshold=area,scaSub,isoSub);
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
