struct Tile{
	path[] border;
	pen[] id;
	id.cyclic=true;
}
Tile operator *(transform tran,Tile tile1){
	Tile tile2;
	tile2.border=tran*tile1.border;
	tile2.id=tile1.id;
	return tile2;
}
Tile operator ^^(Tile tile1, Tile tile2){
	Tile tile3;
	tile3.border=tile1.border^^tile2.border;
	tile3.id=copy(tile1.id);
	tile3.id.append(copy(tile2.id));
	return tile3;
}

Tile join(Tile[] A){
	Tile B=A[0];
	for(int k=1; k < A.length; ++k)
		B=B^^A[k];
	return B;
}

Tile[] join(Tile[][] A){
	Tile[] B;
	for(int i=0; i<A.length; ++i){
		Tile Bi=A[i][0];
		for(int k=1; k < A[i].length; ++k)
			Bi=Bi^^A[i][k];
		B.push(Bi);
	}
	return B;
}

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


void colour(Tile B){
	for(int k=0; k < B.border.length; ++k)
		fill(B.border[k],B.id[k]);
}

/*
//Colouring is currently kinda broken.
path[][] subTile(path[][] pTile, path[][][] rule(path[][]), pen[] colours, int N=1, int colourTile=0){
	path[][] B=pTile;
	int pTiles=pTile.length;
	int i=0;
	while(i < N){
		path[][][] super=rule(B);
		for(int k=0; k < pTiles; ++k)
			B[k]=join(super[k]);
		i+=1;
	}

	if(colours.length > 0){
		B[colourTile]=colour(B[colourTile],colours);
	}
	return B;
}
*/
Tile[] subTile(Tile[] pTile, Tile[][] rule(Tile[]), int N=1){
	Tile[] B=pTile;
	int i=0;
	while(i < N){
		B=join(rule(B));
		i+=1;
	}
	colour(B[0]);
	return B;
}

// An array of colours provided
Tile subTile(Tile pTile, Tile[] rule(Tile), int N=1){
	Tile B=pTile;
	int i=0;
	while(i < N){
		B=join(rule(B));
		i+=1;
	}
	colour(B);
	return B;
}
/*
// An array of colours provided
path[] subTile(path[] pTile, path[] rule(path[]), pen[] colours, int N=1){
	path[] B=pTile;
	int i=0;
	while(i < N){
		B=rule(B);
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
// A single colour provided
path[] subTile(path[] pTile, path[] rule(path[] B), pen colour, int N=1){
	pen[] colours={colour};
	colours.cyclic=true;
	return subTile(pTile,rule,colours,N);
}

// No colours provided
path[] subTile(path[] pTile, path[] rule(path[] B), int N=1){
	pen[] colours;
	return subTile(pTile,rule,colours,N);
}
*/