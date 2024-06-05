settings.outformat="pdf";
size(300);

import mosaic;

// pinwheel triangle
tile tria=(0,0)--(2,0)--(2,1)--cycle;
tile trip=(0,0)--(2,0)--(2,1)--cycle;

// inflation factor
inflation=sqrt(5);

transform Ta=reflect((0,0),(0,1))*rotate(90+aTan(2));
real varphi=aTan(1/2);
transform Tp=reflect((0,0),(0,1))*rotate(180-varphi);

// pinwheel substitution tiles
substitution pinaSub=substitution(tria);

// define the substitution rule
pinaSub.addtile(Ta, paleyellow);
pinaSub.addtile(Ta*shift(2,1), paleyellow);
pinaSub.addtile(Ta*reflect((2,0),(2,1)), lightred);
pinaSub.addtile(Ta*reflect((0,1),(1,1))*shift(2,1), paleblue);
pinaSub.addtile(Ta*shift(4,2)*rotate(-90), heavyred);


substitution pinpSub=substitution(trip);

// define the substitution rule

pinpSub.addtile(Tp, paleyellow);
pinpSub.addtile(Tp*shift(2,1), paleyellow);
pinpSub.addtile(shift(2*Cos(varphi),2*Sin(varphi))*rotate(180)*shift(-sqrt(5),0)*Tp, lightred);  // different from pinwheel
pinpSub.addtile(shift(2*Cos(varphi),2*Sin(varphi))*Tp, paleblue);  // different from pinwheel
pinpSub.addtile(Tp*shift(4,2)*rotate(-90), heavyred);

void updatetesserae(tessera[] tesserae, int) {
  for(int i=0; i < tesserae.length; ++ i) {
    real x=unitrand();
    tesserae[i].prototile=x < 0.5 ? tria : trip;
  }
}

// number of iterations
int n=5;
mosaic M=mosaic(trip,n,updatetesserae,pinaSub,pinpSub);

// draw the patch
filldraw(M);
