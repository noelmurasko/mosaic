settings.outformat="pdf";
size(300);

import mosaic;

tile s=tile((0,0)--(1,0)--(1,1)--(0,1)--cycle, fillpen=black);

substitution sRule=substitution(s);
for(int i=0; i < 9; ++i) {
	if(i != 4) {
		sRule.addtile(scale(1/3)*shift(i#3,i%3));
	}
}

int n=5;
mosaic carpet=mosaic(n, sRule);

fill(carpet);