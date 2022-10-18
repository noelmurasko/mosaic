struct region {
	path[] domain;

	void operator init(path[] domain) {
    this.domain=domain;
  }

  void operator init(path domain) {
  	path[] domain={domain};
    this.domain=domain;
  }
}

bool operator ==(region D1, region D2) {
	path[] P1=D1.domain;
	int L=P1.length;
	path[] P2=D2.domain;
	if(P2.length != L) {
		return false;
	} else {
		for(int i=0; i < L; ++i) {
			if(P1[i] != P2[i])
				return false;
		}
	}
	return true;
}

bool operator !=(region D1, region D2) {
	if(!(D1 == D2))
		return false;
	return true;
}

bool operator ==(region D1, path[] P2) {
	path[] P1=D1.domain;
	int L=P1.length;
	if(P2.length != L) {
		return false;
	} else {
		for(int i=0; i < L; ++i) {
			if(P1[i] != P2[i])
				return false;
		}
	}
	return true;
}

bool operator !=(region D1, path[] P2) {
	if(!(D1 == P2))
		return false;
	return true;
}

bool operator ==(path[] P2, region D1) {
	if(D1 != P2)
		return false;
	return true;
}

bool operator !=(path[] P2, region D1) {
	if(D1 != P2)
		return true;
	return false;
}

struct Tile {
	transform tran;
	region domain;
	region range;
	pen colour;

	void operator init(transform tran=identity, path domain, path range, pen colour=invisible) {
    this.tran=tran;
    this.domain=region(domain);
    // Note: tiles obtained through multiplication don't have domains...
    this.range=region(range);
    this.colour=colour;
  }

  void operator init(transform tran=identity, path range, pen colour=invisible) {
    this.tran=tran;
    this.domain=region(range);
    this.range=this.domain;
    this.colour=colour;
  }

  void operator init(transform tran=identity, path[] domain, path[] range, pen colour=invisible) {
    this.tran=tran;
    this.domain=region(domain);
    // Note: tiles obtained through multiplication don't have domains...
    this.range=region(range);
    this.colour=colour;
  }

  void operator init(transform tran=identity, path[] range, pen colour=invisible) {
    this.tran=tran;
    this.domain=region(range);
    this.range=this.domain;
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

Tile[] subTile(Tile[] Ts, path[] T, int nmax, int n=0) {
	Tile[] tiles;
	if(nmax == 0) {
		for(int i=0; i < Ts.length; ++i) {
			Tile Ti=Ts[i];
			if(Ti.range == T) {
				tiles.push(Tile(identity,T,Ti.colour));
				break;
			}
		}
	}
	if(n < nmax)
		loop(Ts,Tile(T),nmax,n,tiles);
	return tiles;
}

Tile[] subTile(Tile[] Ts, path T, int nmax, int n=0) {
	path[] pT={T};
	return subTile(Ts,pT,nmax,n);
}

void drawTiling(picture pic=currentpicture, Tile[] T,
	        pen p=currentpen) {
	picture pict=pic;
	for(int k=0; k < T.length; ++k)
		filldraw(T[k].tran*T[k].range.domain, T[k].colour, p, pic=pict);
}
