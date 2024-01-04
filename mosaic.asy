real inflation=1;

struct mtile {
  transform transform;
  path[] supertile;
  path[] prototile;
  pen colour;

  void operator init(transform transform=identity, path[] supertile, path[] prototile,
                     pen colour=invisible) {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile=prototile;
    this.colour=colour;
  }

  void operator init(transform transform=identity, path[] prototile={},
                     pen colour=invisible) {
    this.transform=transform;
    this.supertile=prototile;
    this.prototile=prototile;
    this.colour=colour;
  }
}

struct mrule {
  path[] supertile;
  mtile[] patch;

  void operator init(path[] supertile={}) {
    this.supertile=supertile;
  }

  void addtile(transform transform=identity, path[] prototile={},
                     pen colour=invisible) {
    mtile m;
    if(prototile.length == 0)
      m=mtile(transform,this.supertile,colour);
    else
      m=mtile(transform,this.supertile,prototile,colour);
    this.patch.push(m);
  }
}

mtile operator *(mtile t1, mtile t2) {
  mtile t3;
  t3.transform=t1.transform*t2.transform;
  t3.prototile=t2.prototile;
  t3.colour=t2.colour;
  return t3;
}

mtile operator *(transform T, mtile t1) {
  mtile t2=t1;
  t2.transform=T*t2.transform;
  return t2;
}

mtile[] operator *(transform T, mtile[] t1) {
  int L=t1.length;
  mtile[] t2=new mtile[L];
  for(int i=0; i < t1.length; ++i)
    t2[i]=T*t1[i];
  return t2;
}

mtile copy(mtile T) {
  return mtile(T.transform, copy(T.supertile), copy(T.prototile), T.colour);
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

void loop(mtile[] patch, mtile T, int n, int k, mtile[] tiles,
          real inflation=inflation) {
  if(k < n)
    for(int i; i < patch.length; ++i) {
      mtile patchi=patch[i];
      if(samepath(patchi.supertile,T.prototile))
        loop(patch, T*patchi, n, k+1,tiles);
    }
  else
    tiles.push(scale(inflation)^n*T);
}

mtile[] substitute(mtile[] patch, path[] supertile, mtile[] startTiles={}, int n,
                   real inflation=inflation) {
  int L=patch.length;
  mtile[] patchcopy=new mtile[L];
  for(int i=0; i < L; ++i) {
    patchcopy[i]=copy(patch[i]);
  }
  mtile[] tiles;
  for(int i=0; i < L; ++i) {
    mtile T=patchcopy[i];
    if(T.prototile.length == 0) {
      T.prototile=supertile;
    }
    if(T.supertile.length == 0) {
      T.supertile=supertile;
    }
  }
  if(n == 0) {
    // Draw a tile when no iterations are asked for.
    for(int i=0; i < L; ++i) {
      mtile Ti=patchcopy[i];
      if(samepath(Ti.prototile,supertile)) {
        tiles.push(mtile(identity,supertile,Ti.colour));
        break;
      }
    }
  } else {
    real deflation=1/inflation;
    for(int i=0; i < L; ++i) {
      // Inflate transforms (without changing user data).
      transform Ti=patchcopy[i].transform;
      patchcopy[i].transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
    }
    int sTL=startTiles.length;
    if(sTL == 0)
      loop(patchcopy,mtile(supertile),n,0,tiles,inflation);
    else
      for(int i=0; i < sTL; ++i)
        loop(patchcopy,startTiles[i],n,0,tiles,inflation);
  }
  return tiles;
}

struct mosaic {
  mtile[] tiles;
  path[] supertile;
  int n;
  mrule[] rules;
  mtile[] patch;

  void operator init(path[] supertile={}, int n=0, real inflation=inflation ...mrule[] rules) {
    // If supertile is not specified, use supertile from first specified rule.
    if(supertile.length == 0)
      this.supertile=rules[0].supertile;
    else
      this.supertile=supertile;

    this.n=n;
    this.rules=rules;
    int L=rules.length;
    for(int i=0; i < L; ++i)
      this.patch.append(rules[i].patch);
    this.tiles=substitute(this.patch,this.supertile,n,inflation);
  }
}

mosaic substitute(mosaic M, int n, real inflation=inflation) {
  if(n > M.n)
    M.tiles=substitute(M.patch,M.supertile,M.tiles,n-M.n,inflation);
    M.n=n;
  return M;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=M;
  M2.tiles=T*M2.tiles;
  return M2;
}

void draw(picture pic=currentpicture, mtile T, pen p=currentpen) {
  path[] Td=T.transform*T.prototile;
  fill(pic, Td, T.colour);
  draw(pic,Td,p);
}

void draw(picture pic=currentpicture, mtile[] T, pen p=currentpen) {
  for(int k=0; k < T.length; ++k)
    draw(pic, T[k], p);
}

void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, real inflation=inflation) {
  real scaling=(scalelinewidth ? (inflation)^(1-max(M.n,1)) : 1)*linewidth(p);
  draw(pic, M.tiles, p+scaling);
}
