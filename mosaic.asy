real inflation=1;

struct region {
	path[] outline;
	int length;

	void operator init(path[] outline) {
    this.outline=outline;
    this.length=outline.length;
  }
}

bool operator ==(region D1, region D2) {
	path[] P1=D1.outline;
	int L=P1.length;
	path[] P2=D2.outline;
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
	path[] P1=D1.outline;
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

region operator *(transform T, region R1) {
	region R2=R1;
	R2.outline=T*R2.outline;
	return R2;
}

struct mtile {
	transform tran;
	region domain;
	region range;
	pen colour;

  void operator init(transform tran=identity, path[] domain, path[] range, pen colour=invisible) {
    this.tran=tran;
    this.domain=region(domain);
    this.range=region(range);
    this.colour=colour;
  }

  void operator init(transform tran=identity, path[] range={}, pen colour=invisible) {
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

void loop(mtile[] Ts, mtile T, int n, int k, mtile[] tiles,
					real inflation=inflation) {
	if(k < n) {
		int imax=Ts.length;
		for(int i; i < imax; ++i) {
			mtile Tsi=Ts[i];
			if(Tsi.domain == T.range) {
				loop(Ts, T*Tsi, n, k+1,tiles);
			}
		}
	} else {
		tiles.push(scale(inflation)^n*T);
	}
}

mtile[] substitute(mtile[] Ts, path[] T, int n, real inflation=inflation) {
	mtile[] tiles;
	if(n == 0) {
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
		for(int i=0; i < Ts2.length; ++i) {
			mtile Tsi=Ts[i];
			Ts2[i].tran=(shiftless(Tsi.tran)+scale(deflation)*shift(Tsi.tran))*scale(deflation);
		}
		loop(Ts2,mtile(T),n,0,tiles,inflation);
	}
	return tiles;
}

mtile[] substitute(mtile[] Ts, path T, int n, real inflation=inflation) {
	path[] pT={T};
	return substitute(Ts,pT,n);
}

struct mosaic {
	mtile[] tiles;
	path[] supertile;
	int n;

	void operator init(path[] supertile, int n=0, real inflation=inflation ...mtile[] rule) {
		this.n=n;
		this.supertile=supertile;
		for(int i=0; i < rule.length; ++i) {
			mtile T=rule[i];
			if(T.domain.length == 0 && T.range.length == 0) {
				T.domain=region(supertile);
				T.range=region(supertile);
			}
		}
		this.tiles=substitute(rule,supertile,n,inflation);
	}

	void operator init(path[] supertile, int n=0, real inflation=inflation, mtile[] rule) {
		this.n=n;
		this.supertile=supertile;
		this.tiles=substitute(rule,supertile,n,inflation);
	}
}

path[] getpath(mtile T) {
	path[] P=T.tran*T.range.outline;
	return P;
}

void draw(picture pic=currentpicture, mtile T, pen p=currentpen) {
	path[] Td=getpath(T);
	fill(pic, Td, T.colour);
	draw(pic,Td,p);
}

void draw(picture pic=currentpicture, mtile[] T, pen p=currentpen) {
	for(int k=0; k < T.length; ++k)
		draw(pic, T[k], p);
}

void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
				  bool scalelinewidth=true, real inflation=inflation) {
	real scaling=scalelinewidth ? 0.5/(inflation)^(M.n-1) : linewidth(p);
	draw(pic, M.tiles, p+scaling);
}
