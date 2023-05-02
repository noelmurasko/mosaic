real inflation=1;

struct ptransform {
  path[] prototile;
  transform transform;
  pen colour;

  void operator init(transform transform=identity, path[] prototile={}, pen colour=invisible) {
    this.transform=transform;
    this.prototile=prototile;
    this.colour=colour;
  }
}

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
  path[] prototile;
  ptransform[] ptransforms;
  mtile[] patch;

  void operator init(path[] prototile={} ...ptransform[] ptransforms) {

    this.prototile=prototile;
    this.ptransforms=ptransforms;

    int L=ptransforms.length;

    for(int i=0; i < L; ++i) {
      ptransform ptransform=ptransforms[i];
      transform transform=ptransform.transform;
      path[] supertile=this.prototile;
      path[] prototile=ptransform.prototile;
      pen colour=ptransform.colour;
      this.patch[i]=mtile(transform,supertile,prototile,colour);
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

void loop(mtile[] rule, mtile T, int n, int k, mtile[] tiles,
          real inflation=inflation) {
  if(k < n)
    for(int i; i < rule.length; ++i) {
      mtile rulei=rule[i];
      if(samepath(rulei.supertile,T.prototile))
        loop(rule, T*rulei, n, k+1,tiles);
    }
  else
    tiles.push(scale(inflation)^n*T);
}

mtile[] substitute(mtile[] rule, path[] supertile, mtile[] startTiles={}, int n,
                   real inflation=inflation) {
  mtile[] tiles;
  for(int i=0; i < rule.length; ++i) {
    mtile T=rule[i];
    if(T.prototile.length == 0) {
      T.supertile=supertile;
      T.prototile=supertile;
    }
  }
  if(n == 0) {
    // Draw a tile when no iterations are asked for.
    for(int i=0; i < rule.length; ++i) {
      mtile Ti=rule[i];
      if(samepath(Ti.prototile,supertile)) {
        tiles.push(mtile(identity,supertile,Ti.colour));
        break;
      }
    }
  } else {
    int L=rule.length;
    mtile[] rulecopy=new mtile[L];
    real deflation=1/inflation;
    for(int i=0; i < L; ++i) {
      // Inflate transforms (without changing user data).
      transform Ti=rule[i].transform;
      mtile rci=copy(rule[i]);
      rci.transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
      rulecopy[i]=rci;
    }
    int sTL=startTiles.length;
    if(sTL == 0)
      loop(rulecopy,mtile(supertile),n,0,tiles,inflation);
    else
      for(int i=0; i < sTL; ++i)
        loop(rulecopy,startTiles[i],n,0,tiles,inflation);
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
      patch.append(rules[i].patch);
    this.tiles=substitute(patch,supertile,n,inflation);

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
  draw(pic, M.tiles, p+scaling);
}
