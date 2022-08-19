settings.outformat="pdf";
int pix=300;
size(pix,IgnoreAspect);
settings.render=16;

path[] join(path[][] A){
	path[] B=A[0];
	for(int k=1; k < A.length; ++k){
		B=B^^A[k];
	}
	return B;
}

// An array of colours provided
path[] colour(path[] B, pen[] colours){
	bool coloursNotCyclic=!colours.cyclic;

	if(coloursNotCyclic)
		colours.cyclic=true;

	for(int k=0; k < B.length; ++k)
		fill(B[k],colours[k]);

	if(coloursNotCyclic)
		colours.cyclic=false;

	return B;
}

// An array of colours provided
path[] subTile(path[] pTile, path[][] rule(path[] B), pen[] colours, int N){
	path[] B=pTile;
	int i=0;
	while(i < N){
		B=join(rule(B));
		i+=1;
	}
	if(colours.length > 0){
		B=colour(B,colours);
	}
	return B;
}

// A single colour provided
path[] subTile(path[] pTile, path[][] rule(path[] B), pen colour, int N){
	pen[] colours={colour};
	colours.cyclic=true;
	return subTile(pTile,rule,colours,N);
}

// No colours provided
path[] subTile(path[] pTile, path[][] rule(path[] B), int N){
	pen[] colours;
	return subTile(pTile,rule,colours,N);
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
pen[] colours={white,orange,blue,blue};

path[] B=subTile(protoTile, rule, colours, N);
draw(B, linewidth(w));

//path theBox=box((0,0),(1,2));
//clip(theBox);

