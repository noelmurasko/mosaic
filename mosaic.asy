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
path[] subTile(path[] pTile, path[][] rule(path[] B), pen[] colours, int N=1){
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
path[] subTile(path[] pTile, path[][] rule(path[] B), pen colour, int N=1){
	pen[] colours={colour};
	colours.cyclic=true;
	return subTile(pTile,rule,colours,N);
}

// No colours provided
path[] subTile(path[] pTile, path[][] rule(path[] B), int N=1){
	pen[] colours;
	return subTile(pTile,rule,colours,N);
}