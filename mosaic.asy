struct Tile {
	path[] border;
	pen[] colour;
	colour.cyclic=true;

	void operator init(path[] border, pen colour) {
    pen[] colArray={colour};
    this.border=border;
    this.colour=colArray;
  }

  void operator init(path[] border, pen[] colour) {
    this.border=border;
    this.colour=colour;
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
	return tile2;
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

Tile subTile(Tile pTile, Tile[] rule(Tile), int N=1) {
	Tile B=pTile;
	int i=0;
	while(i < N){
		B=join(rule(B));
		i+=1;
	}
	return B;
}
