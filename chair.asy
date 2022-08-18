settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

path[] colour(path[] B){
	for(int k=1; k < B.length; k+=4){
		fill(B[k],white);
		fill(B[k+1],orange);
		fill(B[k+2],blue);
		fill(B[k+3],blue);
	}
	return B;
}

path[] substitute(path[] B, path[] b0, path[] proto){
	path[] b1;
	path[] b2;
	path[] b3;
	path[] b4;

	b1=scale(1/2)*proto;
	b2=shift(1/2,1/2)*b1;
	b3=shift(2,0)*rotate(90)*b1;
	b4=shift(0,2)*rotate(270)*b1;
	return B=b0^^b1^^b2^^b3^^b4;
}

path[] substitution(path[] B, int N){
	path[] b0=B;
	B=substitute(B,b0,B[0:]);
	int i=1;
	while(i < N){
		B=substitute(B,b0,B[1:]);
		i+=1;
	}
	B=colour(B);
	return B;
}

int N=3;
path[] B=(0,0)--(0,2)--(1,2)--(1,1)--(2,1)--(2,0)--cycle;

B=substitution(B, N);
draw(B);
//path theBox=box((0,0),(1,2));
//clip(theBox);

