real inflation=1;

struct mtile {
	transform transform;
	path[] domain;
	path[] range;
	pen colour;

  void operator init(transform transform=identity, path[] domain, path[] range, pen colour=invisible) {
    this.transform=transform;
    this.domain=domain;
    this.range=range;
    this.colour=colour;
  }

  void operator init(transform transform=identity, path[] range={}, pen colour=invisible) {
    this.transform=transform;
    this.domain=range;
    this.range=this.domain;
    this.colour=colour;
  }
}

mtile operator *(mtile t1, mtile t2) {
	mtile t3;
	t3.transform=t1.transform*t2.transform;
	t3.range=t2.range;
	t3.colour=t2.colour;
	return t3;
}

mtile operator *(transform T, mtile t1) {
	mtile t2=t1;
	t2.transform=T*t2.transform;
	return t2;
}

mtile copy(mtile T) {
	return mtile(T.transform, copy(T.domain), copy(T.range), T.colour);
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

void loop(mtile[] rule, mtile T, int n, int k, mtile[] tiles, real inflation=inflation) {
	if(k < n)
		for(int i; i < rule.length; ++i) {
			mtile rulei=rule[i];
			if(samepath(rulei.domain,T.range))
				loop(rule, T*rulei, n, k+1,tiles);
		}
 else
		tiles.push(scale(inflation)^n*T);
}

mtile[] substitute(mtile[] rule, path[] supertile, int n, real inflation=inflation) {
	mtile[] tiles;
	if(n == 0) {
		// Draw a tile when no iterations are asked for.
		for(int i=0; i < rule.length; ++i) {
			mtile Ti=rule[i];
			if(samepath(Ti.range,supertile)) {
				tiles.push(mtile(identity,supertile,Ti.colour));
				break;
			}
		}
	} else {
		int L=rule.length;
		real deflation=1/inflation;
		for(int i=0; i < L; ++i) {
			// Inflate transforms (without changing user data).
			transform Ti=rule[i].transform;
			mtile ruleci=copy(rule[i]);
			ruleci.transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
			rule[i]=ruleci;
		}
		loop(rule,mtile(supertile),n,0,tiles,inflation);
	}
	return tiles;
}

struct mosaic {
	// Normal entry point.
	mtile[] tiles;
	path[] supertile;
	int n;

	void operator init(path[] supertile, int n=0, real inflation=inflation ...mtile[] rule) {
		this.n=n;
		this.supertile=supertile;
		for(int i=0; i < rule.length; ++i) {
			mtile T=rule[i];
			if(T.range.length == 0) {
				T.domain=supertile;
				T.range=supertile;
			}
		}
		this.tiles=substitute(rule,supertile,n,inflation);
	}

	void operator init(path[] supertile, int n=0, real inflation=inflation, mtile[] rule) {
		this.n=n;
		this.supertile=supertile;
		for(int i=0; i < rule.length; ++i) {
			mtile T=rule[i];
			if(T.range.length == 0) {
				T.domain=supertile;
				T.range=supertile;
			}
		}
		this.tiles=substitute(rule,supertile,n,inflation);
	}
}

void draw(picture pic=currentpicture, mtile T, pen p=currentpen) {
	path[] Td=T.transform*T.range;
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
