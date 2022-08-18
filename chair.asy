settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

struct Chair {

	path[] protoTile=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

	path[][] rule(path[] B){
		path[] b1=scale(1/2)*B;
		path[] b2=shift(1/2,1/2)*b1;
		path[] b3=shift(2,0)*rotate(90)*b1;
		path[] b4=shift(0,2)*rotate(270)*b1;
		path[][] A={b1,b2,b3,b4};
		return A;
	}
}

path[] colour(path[] B){
	for(int k=0; k < B.length; k+=4){
		fill(B[k],white);
		fill(B[k+1],orange);
		fill(B[k+2],blue);
		fill(B[k+3],blue);
	}
	return B;
}

path[] substitute(path[][] A){
	return A[0]^^A[1]^^A[2]^^A[3];
}

path[] substitution(Chair t, int N){
	int i=0;
	path[] B=t.protoTile;
	while(i < N){
		B=substitute(t.rule(B));
		i+=1;
	}
	B=colour(B);
	return B;
}

int N=8;
real lambda=2;    // expansion constant
real w=0.5/lambda^(N-1);    // scaled linewidth

Chair t;
path[] B=substitution(t, N);
draw(B, linewidth(w));

//path theBox=box((0,0),(1,2));
//clip(theBox);

