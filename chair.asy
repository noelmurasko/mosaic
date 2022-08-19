settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

path[] colour(path[] B){
	for(int k=0; k < B.length; k+=4){
		fill(B[k],white);
		fill(B[k+1],orange);
		fill(B[k+2],blue);
		fill(B[k+3],blue);
	}
	return B;
}

path[] join(path[][] A){
	path[] B=A[0];
	for(int k=1; k < A.length; ++k){
		B=B^^A[k];
	}
	return B;
}

path[] substitution(path[] protoTile, path[][] rule(path[] B), int N){
	path[] B=protoTile;
	int i=0;
	while(i < N){
		B=join(rule(B));
		i+=1;
	}
	B=colour(B);
	return B;
}

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


path[] B=substitution(protoTile, rule, N);
draw(B, linewidth(w));

//path theBox=box((0,0),(1,2));
//clip(theBox);

