real inflation=1;

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

struct mtile {
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

mtile operator *(mtile t1, mtile t2) {
	mtile t3;
	t3.tran=t1.tran*t2.tran;
	t3.range=t2.range;
	t3.colour=t2.colour;
	return t3;
}

mtile operator *(transform T, mtile t1) {
	mtile t2=t1;
	t2.tran=T*t2.tran;
	return t2;
}

void loop(mtile[] Ts, mtile T, int nmax, int n, mtile[] tiles) {
	if(n < nmax) {
		int imax=Ts.length;
		for(int i; i < imax; ++i) {
			mtile Tsi=Ts[i];
			if(Tsi.domain == T.range) {
				loop(Ts, T*Tsi, nmax, n+1,tiles);
			}
		}
	} else {
		tiles.push(scale(inflation)^n*T);
	}
}

mtile[] substitute(mtile[] Ts, path[] T, int nmax) {
	mtile[] tiles;
	if(nmax == 0) {
		for(int i=0; i < Ts.length; ++i) {
			mtile Ti=Ts[i];
			if(Ti.range == T) {
				tiles.push(mtile(identity,T,Ti.colour));
				break;
			}
		}
	} else {
		mtile[] Ts2=copy(Ts);
		real deflation=1/inflation;
		for(int i; i < Ts2.length; ++i)
			Ts2[i].tran=(shiftless(Ts[i].tran)+scale(deflation)*shift(Ts[i].tran))*scale(deflation);
		loop(Ts2,mtile(T),nmax,0,tiles);
	}
	return tiles;
}

mtile[] substitute(mtile[] Ts, path T, int nmax) {
	path[] pT={T};
	return substitute(Ts,pT,nmax);
}

struct mosaic {
	mtile[] tiles;
	path[] supertile;
	int n;

	void operator init(path[] supertile, int n=0 ...mtile[] rule) {
		this.n=n;
		this.supertile=supertile;
		this.tiles=substitute(rule,supertile,n);
	}

	void operator init(path[] supertile, int n=0, mtile[] rule) {
		this.n=n;
		this.supertile=supertile;
		this.tiles=substitute(rule,supertile,n);
	}
}

void draw(picture pic=currentpicture, mtile T, pen p=currentpen) {
	path[] Td=T.tran*T.range.domain; // .range.domain is pretty awful
	fill(pic, Td, T.colour);
	draw(pic,Td,p);
}

void draw(picture pic=currentpicture, mtile[] T, pen p=currentpen) {
	for(int k=0; k < T.length; ++k)
		draw(pic, T[k], p);
}

void draw(picture pic=currentpicture, mosaic M, pen p=currentpen) {
	draw(pic, M.tiles, p);
}
