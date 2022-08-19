settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

import mosaic;

int N=5;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

path[] protoTile=box((0,0),(1,1));

path[][] rule(path[] B){
		path[] b1=scale(1/2)*B;
		path[] b2=shift(1/2,0)*b1;
	  path[] b3=shift(1/2,1/2)*b1;
		path[] b4=shift(0,1/2)*b1;
		path[][] A={b1,b2,b3,b4};
		return A;
}
pen[] colours={purple,yellow};

path[] B=subTile(protoTile, rule, colours, N);
draw(B, linewidth(w));
