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
	}
}

Tile[] subTile(Tile[] Ts, path T, int nmax, int n=0) {
	Tile[] tiles;
	if(n < nmax)
		loop(Ts,Tile(T),nmax,n,tiles);
	return tiles;
}

void drawTiling(picture pic=currentpicture, Tile[] T,
	        pen p=currentpen) {
	picture pict=pic;
	for(int k=0; k < T.length; ++k)
		filldraw(T[k].tran*T[k].range, T[k].colour, p, pic=pict);
}
