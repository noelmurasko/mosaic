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
    this.prototile=this.supertile;
    this.colour=colour;
  }
}

struct mrule {
  path[] supertile;
  mtile[] patch;

  void operator init(path[] supertile={} ...mtile[] patch) {
    this.supertile=supertile;
    this.patch=patch;
    int L=patch.length;
    for(int i=0; i < L; ++i) {
      this.patch[i].supertile=supertile;
    }
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
  // Normal entry point.
  mtile[] tiles;
  path[] supertile;
  int n;
  mrule[] rules;
  mtile[] patch;

  void operator init(path[] supertile, int n=0, real inflation=inflation ...mrule[] rules) {
    this.n=n;
    this.supertile=supertile;
    this.rules=rules;
    int L=rules.length;
    for(int i=0; i < L; ++i)
      this.patch.append(rules[i].patch);
    this.tiles=substitute(this.patch,supertile,n,inflation);

  }
  /*
  void operator init(path[] supertile, int n=0, real inflation=inflation
                     ...mtile[] rule) {
    this.n=n;
    this.supertile=supertile;
    this.rule=rule;
    this.tiles=substitute(rule,supertile,n,inflation);
  }

  void operator init(path[] supertile, int n=0, real inflation=inflation,
                     mtile[] rule) {
    this.n=n;
    this.supertile=supertile;
    this.rule=rule;
    this.tiles=substitute(rule,supertile,n,inflation);
  }
  */
}
/*
mosaic substitute(mosaic M, int n, real inflation=inflation) {
  int Mn=M.n;
  if(n > Mn) {
    mosaic M2;
    M2.n=Mn;
    M2.supertile=M.supertile;
    M2.rule=M.rule;
    M2.tiles=substitute(M2.rule,M2.supertile,M.tiles,n-Mn,inflation);
    return M2;
  } else if(n < Mn) {
    mosaic M2=mosaic(M.supertile,n,inflation,M.rule);
    return M2;
  } else {
    return M;
  }
}
*/
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
  real scaling=scalelinewidth ? 0.5/(inflation)^(M.n-1) : linewidth(p);
  //real scaling=0.25;
  draw(pic, M.tiles, p+scaling);
}
