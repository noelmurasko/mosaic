real inflation=1;

//path[] prototiles;

struct ptransform {
  path prototile;
  transform transform;
  pen colour;

  void operator init(transform transform=identity, path prototile, pen colour=invisible) {
    this.prototile=prototile;
    this.transform=transform;
    this.colour=colour;
  }
}

struct mtransform {
  transform transform;
  path[] domain;
  path[] range;
  pen colour;

  void operator init(transform transform=identity, path[] domain, path[] range,
                     pen colour=invisible) {
    this.transform=transform;
    this.domain=domain;
    this.range=range;
    this.colour=colour;
  }

  void operator init(transform transform=identity, path[] range={},
                     pen colour=invisible) {
    this.transform=transform;
    this.domain=range;
    this.range=this.domain;
    this.colour=colour;
  }
}

struct mrule {
  path prototile;
  ptransform[] ptransforms;
  mtransform[] mtransforms;

  void operator init(path prototile ...ptransform[] ptransforms) {

    this.prototile=prototile;
    this.ptransforms=ptransforms;

    int L=ptransforms.length;

    for(int i=0; i < L; ++i) {
      ptransform ptransform=ptransforms[i];
      transform transform=ptransform.transform;
      path[] domain=this.prototile;
      path[] range=ptransform.prototile;
      pen colour=ptransform.colour;
      this.mtransforms[i]=mtransform(transform,domain,range,colour);
    }
  }
}

mtransform operator *(mtransform t1, mtransform t2) {
  mtransform t3;
  t3.transform=t1.transform*t2.transform;
  t3.range=t2.range;
  t3.colour=t2.colour;
  return t3;
}

mtransform operator *(transform T, mtransform t1) {
  mtransform t2=t1;
  t2.transform=T*t2.transform;
  return t2;
}

mtransform[] operator *(transform T, mtransform[] t1) {
  int L=t1.length;
  mtransform[] t2=new mtransform[L];
  for(int i=0; i < t1.length; ++i)
    t2[i]=T*t1[i];
  return t2;
}

mtransform copy(mtransform T) {
  return mtransform(T.transform, copy(T.domain), copy(T.range), T.colour);
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

void loop(mtransform[] rule, mtransform T, int n, int k, mtransform[] tiles,
          real inflation=inflation) {
  if(k < n)
    for(int i; i < rule.length; ++i) {
      mtransform rulei=rule[i];
      if(samepath(rulei.domain,T.range))
        loop(rule, T*rulei, n, k+1,tiles);
    }
  else
    tiles.push(scale(inflation)^n*T);
}

mtransform[] substitute(mtransform[] rule, path[] supertile, mtransform[] startTiles={}, int n,
                   real inflation=inflation) {
  mtransform[] tiles;
  for(int i=0; i < rule.length; ++i) {
    mtransform T=rule[i];
    if(T.range.length == 0) {
      T.domain=supertile;
      T.range=supertile;
    }
  }
  if(n == 0) {
    // Draw a tile when no iterations are asked for.
    for(int i=0; i < rule.length; ++i) {
      mtransform Ti=rule[i];
      if(samepath(Ti.range,supertile)) {
        tiles.push(mtransform(identity,supertile,Ti.colour));
        break;
      }
    }
  } else {
    int L=rule.length;
    mtransform[] rulecopy=new mtransform[L];
    real deflation=1/inflation;
    for(int i=0; i < L; ++i) {
      // Inflate transforms (without changing user data).
      transform Ti=rule[i].transform;
      mtransform rci=copy(rule[i]);
      rci.transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
      rulecopy[i]=rci;
    }
    int sTL=startTiles.length;
    if(sTL == 0)
      loop(rulecopy,mtransform(supertile),n,0,tiles,inflation);
    else
      for(int i=0; i < sTL; ++i)
        loop(rulecopy,startTiles[i],n,0,tiles,inflation);
  }
  return tiles;
}


struct mosaic {
  // Normal entry point.
  mtransform[] tiles;
  path[] supertile;
  int n;
  mtransform[] rule;

  void operator init(path[] supertile, int n=0, real inflation=inflation
                     ...mtransform[] rule) {
    this.n=n;
    this.supertile=supertile;
    this.rule=rule;
    this.tiles=substitute(rule,supertile,n,inflation);
  }

  void operator init(path[] supertile, int n=0, real inflation=inflation,
                     mtransform[] rule) {
    this.n=n;
    this.supertile=supertile;
    this.rule=rule;
    this.tiles=substitute(rule,supertile,n,inflation);
  }
}

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

mosaic operator *(transform T, mosaic M) {
  mosaic M2=M;
  M2.tiles=T*M2.tiles;
  return M2;
}

void draw(picture pic=currentpicture, mtransform T, pen p=currentpen) {
  path[] Td=T.transform*T.range;
  fill(pic, Td, T.colour);
  draw(pic,Td,p);
}

void draw(picture pic=currentpicture, mtransform[] T, pen p=currentpen) {
  for(int k=0; k < T.length; ++k)
    draw(pic, T[k], p);
}

void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, real inflation=inflation) {
  real scaling=scalelinewidth ? 0.5/(inflation)^(M.n-1) : linewidth(p);
  draw(pic, M.tiles, p+scaling);
}
