real inflation=1;

struct mtile {
	transform tran;
	path[] domain;
	path[] range;
	pen colour;

  void operator init(transform tran=identity, path[] domain, path[] range, pen colour=invisible) {
    this.tran=tran;
    this.domain=domain;
    this.range=range;
    this.colour=colour;
  }

  void operator init(transform tran=identity, path[] range={}, pen colour=invisible) {
    this.tran=tran;
    this.domain=range;
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

bool samepath(path[] P1, path[] P2) {
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

void loop(mtile[] Ts, mtile T, int n, int k, mtile[] tiles,
					real inflation=inflation) {
	if(k < n)
		for(int i; i < Ts.length; ++i) {
			mtile Tsi=Ts[i];
			if(samepath(Tsi.domain,T.range))
				loop(Ts, T*Tsi, n, k+1,tiles);
		}
 else
		tiles.push(scale(inflation)^n*T);
}

mtile[] substitute(mtile[] Ts, path[] T, int n, real inflation=inflation) {
	mtile[] tiles;
	if(n == 0) {
		for(int i=0; i < Ts.length; ++i) {
			mtile Ti=Ts[i];
			if(samepath(Ti.range,T)) {
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
				T.domain=supertile;
				T.range=supertile;
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

void draw(picture pic=currentpicture, mtile T, pen p=currentpen) {
	path[] Td=T.tran*T.range;
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
