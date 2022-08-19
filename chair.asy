settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

int N=3;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

path[] protoTile=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

path[][] rule(path[] B){
		path[] b1=scale(1/2)*B;
		path[] b2=shift(1/2,1/2)*b1;
		path[] b3=shift(2,0)*rotate(90)*b1;
		path[] b4=shift(0,2)*rotate(270)*b1;
		path[][] A={b1,b2,b3,b4};
		return A;
}
pen[] colours={white,orange,blue,blue};

path[] B=subTile(protoTile, rule, colours, N);
draw(B, linewidth(w));

//path theBox=box((0,0),(1,2));
//clip(theBox);

