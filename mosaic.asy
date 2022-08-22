struct Tile {
	path[] border;
	pen[] colour;
	colour.cyclic=true;
	string name="";
	transform transform=identity;

	void operator init(path[] border, pen colour=invisible) {
    pen[] colArray={colour};
    this.border=border;
    this.colour=colArray;
  }

  void operator init(path[] border, pen[] colour={invisible}) {
    this.border=border;
    this.colour=colour;
  }

  void operator init(Tile B, pen colour=invisible) {
    pen[] colArray={colour};
    this.border=B.border;
    this.colour=colArray;
    this.name=B.name;
  }

	void fillColour() {
		for(int k=0; k < border.length; ++k)
			fill(border[k],colour[k]);
	}
}

void draw(picture pic=currentpicture, Label L="", Tile B, align align=NoAlign,
	        pen p=currentpen, arrowbar arrow=None, arrowbar bar=None,
	        margin margin=NoMargin, Label legend="", marker marker=nomarker) {
	picture pict=pic;
	for(int k=0; k < B.border.length; ++k)
		draw(B.border[k], p=p, pic=pict, L=L, align=align, arrow=arrow,
			   bar, margin, legend, marker);
}

Tile operator *(transform tran, Tile tile1) {
	Tile tile2;
	tile2.border=tran*tile1.border;
	tile2.colour=tile1.colour;
	tile2.name=tile1.name;
	tile2.transform*=tile1.transform;
	return tile2;
}

Tile[] operator *(transform tran, Tile[] tiles1) {
	Tile[] tiles2;
	for(int k=0; k < tiles1.length; ++k)
		tiles2.push(tran*tiles1[k]);
	return tiles2;
}

Tile operator ^^(Tile tile1, Tile tile2) {
	Tile tile3;
	tile3.border=tile1.border^^tile2.border;
	tile3.colour=copy(tile1.colour);
	tile3.colour.append(copy(tile2.colour));
	return tile3;
}

Tile join(Tile[] A) {
	Tile B=A[0];
	for(int k=1; k < A.length; ++k)
		B=B^^A[k];
	return B;
}

Tile[] join(Tile[][] A) {
	Tile[] B;
	for(int i=0; i < A.length; ++i)
		B.push(join(A[i]));
	return B;
}

Tile[] subTile(Tile[] pTile, Tile[][] rule(Tile[]), int N=1) {
	Tile[] B=pTile;
	int i=0;
	while(i < N){
		B=join(rule(B));
		i+=1;
	}
	return B;
}

Tile subTile(Tile pTile, Tile[] rule(Tile, int), int N=1) {
	Tile[] B={pTile};
	int i=1;
	real lambda=1/2; //scaling factor
	while(i <= N){
		int M=B.length;
		int k=0;
		while(k < M){
			Tile Bk=B[k];
			B.delete(k);
			pair start=point(Bk.border[0],0);
			pair correction=(1-lambda)*start;
			Bk=shift(correction)*scale(lambda)*Bk;
			Tile[] rBk=rule(Bk,i);
			B.insert(k ... rBk);
			k+=rBk.length;
			M+=rBk.length-1;
			assert(M<100000);// For safety
		}
		i+=1;
	}
	return join(B);
}
