settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile chair=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;
//draw(chair);
// substitution rule
substitution chairRule=substitution(chair);
chairRule.addtile(lightred);
chairRule.addtile(shift(1,1),lightblue);
chairRule.addtile(shift(4,0)*rotate(90),lightgreen);
chairRule.addtile(shift(0,4)*rotate(270),lightyellow);

// draw patch

void updatetesserae(tessera[] tesserae) {
  for(int i=0; i < tesserae.length; ++ i) {
    real x=unitrand();
    tesserae[i].iterate=x < 0.5 ? false : true;
  }
}

int n=6;
mosaic M=mosaic(chair,n,updatetesserae,chairRule);
filldraw(M);
