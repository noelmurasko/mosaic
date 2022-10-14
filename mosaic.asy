struct Tile {
	transform tran;
	path domain;
	path range;
	pen colour;

	void operator init(transform tran=identity, path domain, path range, pen colour=invisible) {
    this.tran=tran;
    this.domain=domain;
    // Note: tiles obtained through multiplication don't have domains...
    this.range=range;
    this.colour=colour;
  }

  void operator init(transform tran=identity, path range, pen colour=invisible) {
    this.tran=tran;
    this.domain=range;
    this.range=range;
    this.colour=colour;
  }
}

Tile operator *(Tile t1, Tile t2) {
	Tile t3;
	t3.tran=t1.tran*t2.tran;
	t3.range=t2.range;
	t3.colour=t2.colour;
	return t3;
}

void loop(Tile[] Ts, Tile T, int nmax, int n, Tile[] tiles) {
	if(n < nmax) {
		int imax=Ts.length;
		for(int i; i < imax; ++i) {
			Tile Ti=Ts[i];
			if(Ti.domain == T.range)
				loop(Ts, T*Ts[i], nmax, n+1,tiles);
		}
	} else {
		tiles.push(T);
		//filldraw(T.tran*T.range,T.colour,black+linewidth(0.5/(2^n)));
	}
}

Tile[] subTile(Tile[] Ts, path T, int nmax, int n=0) {
	Tile[] tiles;
	if(n < nmax)
		loop(Ts,Tile(T),nmax,n,tiles);
	return tiles;
}

void drawTiling(picture pic=currentpicture, Tile[] T, align align=NoAlign,
	        pen p=currentpen) {
	picture pict=pic;
	for(int k=0; k < T.length; ++k)
		filldraw(T[k].tran*T[k].range, T[k].colour, p, pic=pict);
}


/*
void draw(picture pic=currentpicture, Label L="", Tile[] T, align align=NoAlign,
	        pen p=currentpen, arrowbar arrow=None, arrowbar bar=None,
	        margin margin=NoMargin, Label legend="", marker marker=nomarker) {
	picture pict=pic;
	for(int k=0; k < T.length; ++k)
		draw(T[k].tran*T[k].range, p=p, pic=pict, L=L, align=align, arrow=arrow,
			   bar, margin, legend, marker);
}

struct Tile {
	path[] border;
	pen[] colour;
	transform T;
	string name;
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

Tile[] operator *(transform tran, Tile[] tiles1) {
	int L=tiles1.length;
	Tile[] tiles2=new Tile[L];
	for(int i=0; i < L; ++i)
		tiles2[i]=tran*tiles1[i];
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
	int L=A.length;
	Tile[] B=new Tile[L];
	for(int i=0; i < L; ++i)
		B[i]=join(A[i]);
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
*/
