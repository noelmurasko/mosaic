real inflation=1;

struct tile {
  restricted path[] boundary;
  restricted int length;

  void operator init(path[] boundary) {
    this.boundary=boundary;
    this.length=boundary.length;
  }
}

tile operator cast(path[] p) {
  return tile(p);
}

tile operator cast(pair p) {
  return tile((path) p);
}

tile operator cast(path p) {
  return tile(p);
}

tile operator cast(guide g) {
  return tile(g);
}

tile copy(tile T) {
  return tile(copy(T.boundary));
}

bool alias(tile T1, tile T2) {
  return alias(T1.boundary,T2.boundary);
}

tile nulltile=tile(nullpath);

private struct mtile {
  transform transform;
  tile supertile;
  tile prototile;

  tile[] drawtile={};
  pen[] fillpen;
  pen[] drawpen;

  bool[] fillable;

  restricted int layers;

  string id;

  bool checkfillable(tile drawtile, int ind=0) {
    for(int i=0; i < drawtile.length; ++i)
      if(!cyclic(drawtile.boundary[i])) return false;
    return true;
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;
    this.drawtile.push(drawtile == nulltile ? this.prototile : drawtile);
    this.fillable.push(checkfillable(this.drawtile[0]));
    this.fillpen.push(fillpen);
    this.drawpen.push(drawpen);

    this.layers=1;
    this.id=id;
  }

  void operator init(transform transform=identity, tile supertile, tile prototile,
                     pair drawtile, pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile.push((path) drawtile);
    this.fillable.push(checkfillable((path) drawtile));
    this.fillpen.push(fillpen);
    this.drawpen.push(drawpen);


    this.layers=1;
    this.id=id;
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile[] drawtile, pen[] fillpen, pen[] drawpen, bool[] fillable, string id="") {
    int L=drawtile.length;
    assert(fillable.length == L && fillpen.length == L && drawpen.length == L);
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    this.fillpen=fillpen;
    this.drawpen=drawpen;

    int L=drawtile.length;
    for(int i=0; i < L; ++i) {
      this.fillable.push(checkfillable(drawtile[i]));
    }
    this.layers=L;
    this.fillable=fillable;
    this.id=id;
  }

  void addlayer(tile drawtile, pen fillpen, pen drawpen) {
    this.drawtile.push(drawtile);
    this.fillable.push(checkfillable(drawtile));
    this.fillpen.push(fillpen);
    this.drawpen.push(drawpen);
    this.layers+=1;
  }
  //remove
  void addlayer(tile drawtile=nulltile, pen p=nullpen) {
    this.drawtile.push(drawtile);
    bool fillable=checkfillable(drawtile);
    this.fillable.push(fillable);
    if(fillable) {
      this.fillpen.push(p);
      this.drawpen.push(nullpen);
    } else {
      this.fillpen.push(nullpen);
      this.drawpen.push(p);
    }
    layers+=1;
  }


  void setdrawtile(tile drawtile, int ind) {
    this.drawtile[ind]=drawtile;
    this.fillable[ind]=checkfillable(drawtile);
  }

  void setpen(pen fillpen, pen drawpen, int ind) {
    bool fpnull=fillpen == nullpen;
    bool dpnull=drawpen == nullpen;
    if(fillable[ind]) {
      if(!fpnull) this.fillpen[ind]=fillpen;
      if(!dpnull) this.drawpen[ind]=drawpen;
    } else {
      if(fpnull & !dpnull) {
        this.drawpen[ind]=drawpen;
      }
      else if(dpnull & !fpnull) {
        this.drawpen[ind]=fillpen;
      }
    }
  }

  void setpen(pen p, int ind) {
    if(fillable[ind]) this.fillpen[ind]=p;
    else this.drawpen[ind]=p;
  }
}

struct substitution {
  tile supertile;
  mtile[] patch;
  pen fillpen;
  pen drawpen;

  void operator init(explicit tile supertile, pen fillpen=invisible, pen drawpen=nullpen) {
    this.supertile=supertile;
    this.fillpen=fillpen;
    this.drawpen=drawpen;
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    mtile m;
    pen fp=fillpen == nullpen ? this.fillpen : fillpen;
    pen dp=drawpen == nullpen ? this.drawpen : drawpen;
    if(prototile == nulltile)
      m=mtile(transform,this.supertile,drawtile=drawtile,fp,dp,id);
    else
      m=mtile(transform,this.supertile,prototile,drawtile,fp,dp,id);
    this.patch.push(m);
  }
}

mtile copy(mtile T) {
  return mtile(T.transform, T.supertile, T.prototile, T.drawtile, T.fillpen, T.drawpen, T.fillable, T.id); // Do not do deep copy of drawtile, fillpen, or drawpen
  // don't copy tiles?
}

substitution copy(substitution T) {
  substitution T2=substitution(T.supertile);
  T2.patch=T.patch;
  return T2;
}

mtile operator *(mtile t1, mtile t2) {
  mtile t3=copy(t2);
  t3.transform=t1.transform*t2.transform;
  return t3;
}

mtile operator *(transform T, mtile t1) {
  mtile t2=copy(t1);
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

struct mosaic {
  mtile[] tiles={};
  tile supertile;
  int n=0;
  substitution[] rules;
  mtile[] patch;
  int layers;

  private void loop(mtile[] patch, mtile T, int n, int k, mtile[] tiles,
          real inflation=inflation) {
    if(k < n)
      for(int i; i < patch.length; ++i) {
        mtile patchi=patch[i];
        if(alias(patchi.supertile,T.prototile))
          loop(patch, T*patchi, n, k+1,tiles);
      }
    else
      tiles.push(scale(inflation)^n*T);
  }

  void substitute(int n, real inflation=inflation) {
    int L=this.patch.length;
    mtile[] patchcopy=new mtile[L];
    for(int i=0; i < L; ++i) {
      patchcopy[i]=copy(this.patch[i]);
    }
    mtile[] tiles;
    for(int i=0; i < L; ++i) {
      mtile T=patchcopy[i];
      if(T.prototile == nulltile) {
        T.prototile=this.supertile;
      }
      if(T.supertile == nulltile) {
        T.supertile=this.supertile;
      }
    }
    real deflation=1/inflation;
    for(int i=0; i < L; ++i) {
      // Inflate transforms (without changing user data).
      transform Ti=patchcopy[i].transform;
      patchcopy[i].transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
    }
    int sTL=this.tiles.length;
    if(sTL == 0)
      this.loop(patchcopy,mtile(this.supertile),n,0,tiles,inflation);
    else
      for(int i=0; i < sTL; ++i)
        this.loop(patchcopy,this.tiles[i],n,0,tiles,inflation);
    this.tiles=tiles;
    this.n+=n;
  }

  // addlayer() Adds a new layer with a drawtile, fillpen and drawpen.
  // If only 1 pen p is specified, addlayer() checks whether or not the drawtile is fillable. If it is, p is the fillpen, and if not p is the drawpen
  // The drawtile can be a pair, in which only the drawpen can be passed.
  void addlayer(tile drawtile, pen fillpen, pen drawpen) {
    int L=patch.length;
    for(int i=0; i < L; ++i) {
      patch[i].addlayer(drawtile,fillpen,drawpen);
    }
    layers+=1;
  }

  void addlayer(tile drawtile=nulltile, pen p=nullpen) {
    int L=patch.length;
    for(int i=0; i < L; ++i) {
      patch[i].addlayer(drawtile,p);
    }
    layers+=1;
  }

  void addlayer(pair drawtile, pen drawpen=nullpen) {
    this.addlayer((path) drawtile,invisible,drawpen);
  }

  void set(pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string[] id) {
    int ind=layer < 0 ? layers-1 : layer;
    int idlength=id.length;
    for(int i=0; i < patch.length; ++i) {
      for(int j=0; j < max(idlength,1); ++j) {
        if(idlength == 0 || patch[i].id == id[j]) {
          patch[i].setpen(fillpen,drawpen,ind);
          break;
        }
      }
    }
  }

  void set(tile drawtile, pen fillpen=nullpen, pen drawpen=nullpen,int layer=-1, string[] id) {
      int ind=layer < 0 ? layers-1 : layer;
      int idlength=id.length;
      for(int i=0; i < patch.length; ++i) {
        for(int j=0; j < max(idlength,1); ++j) {
          if(idlength == 0 || patch[i].id == id[j]) {
            patch[i].setdrawtile(drawtile,ind);
            patch[i].setpen(fillpen,drawpen,ind);
            break;
          }
        }
      }
    }

  void set(pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1 ...string[] id) {
    set(fillpen,drawpen,layer,id);
  }

  // Overloading set to take a string provides no new functionality except
  // one can now use the keyword "id=" when calling set(). I'm uncertain if
  // this is worth it or not.
  void set(pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string id) {
    string[] idarray={id};
    set(fillpen,drawpen,layer,idarray);
  }

  void set(tile drawtile, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1 ...string[] id) {
    set(drawtile, fillpen,drawpen,layer,id);
  }

  void set(tile drawtile, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string id) {
    string[] idarray={id};
    set(drawtile, fillpen, drawpen,layer,idarray);
  }

  void operator init(tile supertile=nulltile, int n=0, real inflation=inflation ...substitution[] rules) {
    // If supertile is not specified, use supertile from first specified rule.
    if(supertile == nulltile)
      this.supertile=rules[0].supertile;
    else
      this.supertile=supertile;
    this.rules=rules;
    int L=rules.length;
    for(int i=0; i < L; ++i) {
      this.patch.append(rules[i].patch);
    }
    assert(n > 0,"Mosaics must be initialized with a positive number of iterations n.");
    this.substitute(n,inflation);

    this.layers=1;
  }
}

mosaic copy(mosaic M) {
  mosaic M2;
  int Lt=M.tiles.length;
  mtile[] M2tiles=new mtile[Lt];
  for(int i=0; i < Lt; ++i) {
    M2tiles[i]=copy(M.tiles[i]);
  }
  M2.tiles=M2tiles;
  M2.supertile=copy(M.supertile);
  M2.n=M.n;
  int Lr=M.rules.length;
  substitution[] M2rules=new substitution[Lr];
  for(int i=0; i < Lr; ++i) {
    M2rules[i]=copy(M.rules[i]);
  }
  M2.rules=M2rules;
  int Lp=M.patch.length;
  mtile[] M2patch=new mtile[Lp];
  for(int i=0; i < Lp; ++i) {
    M2patch[i]=copy(M.patch[i]);
  }
  M2.layers=M.layers;
  return M2;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=copy(M);
  M2.tiles=T*M2.tiles;
  return M2;
}

void draw(picture pic=currentpicture, mtile T, pen p, real scaling, int l) {
  path[] Td=T.transform*T.drawtile[l].boundary;
  if(T.fillable[l]) fill(pic, Td, T.fillpen[l]);
  pen dpl=T.drawpen[l];
  if(dpl != nullpen)
    draw(pic,Td,dpl+scaling*linewidth(dpl));
  else
    draw(pic,Td,p+scaling*linewidth(p));
}

void draw(picture pic=currentpicture, substitution s, pen p=currentpen) {
  for(int k=0; k < s.patch.length; ++k) {
    draw(pic, s.patch[k], p, 1, 0);
  }
}

// Draw mosaic. Layers are drawn in increasing order.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, real inflation=inflation) {
  real scaling=scalelinewidth ? (inflation)^(1-max(M.n,1)) : 1;
  for(int l=0; l < M.layers; ++l)
    for(int k=0; k < M.tiles.length; ++k){
      draw(pic, M.tiles[k], p, scaling, l);
    }
}

// Draw layer l of mosaic.
void draw(picture pic=currentpicture, mosaic M, int l, pen p=currentpen,
          bool scalelinewidth=true, real inflation=inflation) {
  real scaling=scalelinewidth ? (inflation)^(1-max(M.n,1)) : 1;
  for(int k=0; k < M.tiles.length; ++k)
    draw(pic, M.tiles[k], p, scaling, l);
}
