real inflation=1;

bool checkfillable(path[] drawtile, int ind=0) {
  for(int i=0; i < drawtile.length; ++i)
    if(!cyclic(drawtile[i])) return false;
  return true;
}

struct tile {
  restricted path[] boundary;
  restricted int length; //Remove
  restricted bool fillable;
  pen fillpen;
  pen drawpen;

  void operator init(path[] boundary, pen fillpen=invisible, pen drawpen=nullpen) {
    this.boundary=boundary;
    this.fillable=checkfillable(boundary);
    this.fillpen=fillpen;
    this.drawpen=drawpen;
    this.length=boundary.length;
  }
}

tile operator cast(path[] p, pen fillpen=invisible, pen drawpen=nullpen) {
  return tile(p,fillpen,drawpen);
}

tile operator cast(path[] p) {
  return tile(p);
}

tile operator cast(pair p, pen fillpen=invisible, pen drawpen=nullpen) {
  return tile((path) p,fillpen,drawpen);
}

tile operator cast(pair p) {
  return tile((path) p);
}

tile operator cast(path p, pen fillpen=invisible, pen drawpen=nullpen) {
  return tile(p,fillpen,drawpen);
}

tile operator cast(path p) {
  return tile(p);
}

tile operator cast(guide g, pen fillpen=invisible, pen drawpen=nullpen) {
  return tile(g,fillpen,drawpen);
}

tile operator cast(guide g) {
  return tile(g);
}

tile copy(tile t) {
  return tile(copy(t.boundary),t.fillpen, t.drawpen);
}

tile operator *(transform T, tile t) {
  return tile(T*t.boundary, t.fillpen, t.drawpen);
}

bool operator ==(tile T1, tile T2) {
  return alias(T1,T2);
}

// write tiles (just writes boundary)
void write(string s="", explicit tile t) {
  write(s,t.boundary);
}

tile nulltile=tile(nullpath);

bool checkfillable(tile drawtile, int ind=0) {
  for(int i=0; i < drawtile.length; ++i)
    if(!cyclic(drawtile.boundary[i])) return false;
  return true;
}

struct mtile {
  transform transform;
  tile supertile;
  tile prototile;

  tile[] drawtile={};

  restricted int layers;
  string id;
  int index;

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    pen fp=dt.fillpen == nullpen ? fillpen : dt.fillpen;
    pen dp=dt.drawpen == nullpen ? drawpen : dt.drawpen;
    this.drawtile.push(tile(dt.boundary, fp, dp));

    this.layers=1;
    this.id=id;
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile[] drawtile, int index, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;


    this.drawtile=drawtile;

    this.index=index;
    this.layers=drawtile.length;
    this.id=id;
  }

  void addlayer(tile drawtile, pen fillpen, pen drawpen) {
    this.drawtile.push(tile(drawtile.boundary, fillpen, drawpen));
    this.layers+=1;
  }

  void setdrawtile(tile drawtile, int ind) {
    this.drawtile[ind]=drawtile;
  }

  void setpen(pen fillpen, pen drawpen, int ind) {
    bool fpnull=fillpen == nullpen;
    bool dpnull=drawpen == nullpen;
    if(drawtile[ind].fillable) {
      if(!fpnull) drawtile[ind].fillpen=fillpen;
      if(!dpnull) drawtile[ind].drawpen=drawpen;
    } else {
      if(fpnull & !dpnull) {
        drawtile[ind].drawpen=drawpen;
      }
      else if(dpnull & !fpnull) {
        drawtile[ind].drawpen=fillpen;
      }
    }
  }
}

struct substitution {
  tile supertile;
  mtile[] patch;

  void operator init(explicit tile supertile) {
    this.supertile=supertile;
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    mtile m;
    tile protile=prototile == nulltile ? this.supertile : prototile;
    //pen fp=fillpen == nullpen ? protile.fillpen : fillpen;
    //pen dp=drawpen == nullpen ? protile.drawpen : drawpen;
    m=mtile(transform,this.supertile,prototile,drawtile,fillpen,drawpen,id);
    this.patch.push(m);
  }
}

mtile duplicate(mtile T) {
  return mtile(T.transform, T.supertile, T.prototile, T.drawtile, T.index, T.id);
}

mtile copy(mtile T) {
  int L=T.drawtile.length;
  tile[] dtcopy=new tile[L];
  for(int i; i < L; ++i)
    dtcopy[i]=copy(T.drawtile[i]);
  // If supertile and prototile are the same, make only one copy
  if(T.supertile == T.prototile) {
    tile super2=copy(T.supertile);
    return mtile(T.transform, super2, super2, dtcopy, T.index,T.id);
  } else
    return mtile(T.transform, copy(T.supertile), copy(T.prototile), dtcopy, T.index,T.id);
}

substitution duplicate(substitution T) {
  substitution T2=substitution(T.supertile);
  T2.patch=T.patch;
  return T2;
}

mtile operator *(mtile t1, mtile t2) {
  mtile t3=duplicate(t2);
  t3.transform=t1.transform*t2.transform;
  return t3;
}

mtile operator *(transform T, mtile t1) {
  mtile t2=duplicate(t1);
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

struct mosaic {
  mtile[] tiles;
  tile supertile;
  int n=0;

  mtile[] patch;
  int layers;

  // addlayer() Adds a new layer with a drawtile, fillpen and drawpen.
  // If only 1 pen p is specified, addlayer() checks whether or not the drawtile is fillable. If it is, p is the fillpen, and if not p is the drawpen
  // The drawtile can be a pair, in which only the drawpen can be passed.
  // TODO: what if the drawtiles comes with colours?
  void addlayer(tile drawtile=nulltile, pen fillpen=invisible, pen drawpen=nullpen) {
    pen fp;
    pen dp;
    bool fpnull=fillpen == nullpen;
    bool dpnull=drawpen == nullpen;

    if(drawtile.fillable) {
      fp=fillpen;
      dp=drawpen;
    } else {
      if(fpnull & !dpnull) {
        fp=nullpen;
        dp=drawpen;
      }
      else if(dpnull & !fpnull) {
        fp=nullpen;
        dp=fillpen;
      }
    }

    int L=patch.length;
    for(int i=0; i < L; ++i) {
      patch[i].addlayer(drawtile,fp,dp);
    }
    layers+=1;
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

  private void loop(mtile T, int n, int k, mtile[] tiles,
          real inflation=inflation) {
    if(k < n)
      for(int i=0; i < patch.length; ++i) {
        mtile patchi=patch[i];
        //write(patchi.supertile == T.prototile);
        if(patchi.supertile == T.prototile) {
          loop(T*patchi, n, k+1,tiles,inflation);
        }
      }
    else
      tiles.push(scale(inflation)^n*T);
  }

  void substitute(int n, real inflation=inflation) {
    mtile[] tiles=new mtile[];
    int sTL=this.tiles.length;
    if(sTL == 0) {
      this.loop(mtile(this.supertile),n,0,tiles,inflation);
    }
    else {
      for(int i=0; i < sTL; ++i)
        this.loop(this.tiles[i],n,0,tiles,inflation);
    }
    this.tiles=tiles;
    this.n+=n;
  }

  void operator init(tile supertile=nulltile, int n=0, real inflation=inflation ...substitution[] rules) {

    //this.rules=rules;
    int ind=0;
    int Lr=rules.length;
    for(int i=0; i < Lr; ++i) {
      mtile[] rpi=rules[i].patch;
      for(int j=0; j < rpi.length; ++j) {
        mtile pj=duplicate(rules[i].patch[j]);
        pj.index=ind;
        ind+=1;
        this.patch.push(pj); // Needs duplicate
      }
    }
    int Lp=this.patch.length;
    real deflation=1/inflation;
    for(int i=0; i < Lp; ++i) {
      mtile T=patch[i];
      if(T.prototile == nulltile) {
        T.prototile=this.supertile;
      }
      if(T.supertile == nulltile) {
        T.supertile=this.supertile;
      }
      transform Ti=patch[i].transform;
      patch[i].transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
    }
    // If supertile is not specified, use supertile from first specified rule.
    if(supertile == nulltile) {
      this.supertile=rules[0].supertile;
    } else {
      for(int i=0; i < Lr; ++i) {
        if(supertile==rules[i].supertile) {
          this.supertile=supertile;
          break;
        }
      assert(i < Lr, "Supertile in mosaic does not match supertile in provided substitutions.");
      }
    }
    if(n > 0) this.substitute(n,inflation);
    else this.tiles.push(mtile(this.supertile));
    this.layers=1;
  }
}

int searchtile(tile[] ts, tile t) {
  for(int i; i < ts.length; ++i) {
    if(ts[i] == t) {
      return i;
    }
  }
  return -1;
}

mosaic copy(mosaic M) {
  mosaic M2;

  M2.n=M.n;
  M2.layers=M.layers;

  int Lt=M.tiles.length;
  int Lp=M.patch.length;

  tile[] Msupertiles;
  tile[] Mprototiles;

  M2.patch.push(copy(M.patch[0]));
  Msupertiles.push(M.patch[0].supertile);
  Mprototiles.push(M.patch[0].prototile);

  for(int j=1; j < Lp; ++j) {
    mtile pj=copy(M.patch[j]);
    int is=searchtile(Msupertiles, M.patch[j].supertile);
    if(is != -1)
      pj.supertile=M2.patch[is].supertile;
    Msupertiles.push(M.patch[j].supertile);

    int ip=searchtile(Mprototiles, M.patch[j].prototile);
    if(ip != -1)
      pj.prototile=M2.patch[is].prototile;
    Mprototiles.push(M.patch[j].supertile);

    M2.patch.push(pj);
  }

  for(int j=0; j < Lp; ++j) {
    if(M.supertile == Msupertiles[j]); {
      M2.supertile=M2.patch[j].supertile;
      break;
    }
  }

  for(int i=0; i < Lt; ++i) {
    mtile t=M.tiles[i];
    int j=t.index;
    mtile t2=mtile(t.transform, M2.patch[j].supertile, M2.patch[j].prototile, M2.patch[j].drawtile, j, M2.patch[j].id);
    M2.tiles.push(t2);
  }

  return M2;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=copy(M);
  M2.tiles=T*M2.tiles;
  return M2;
}

// draw tile T
void draw(picture pic=currentpicture, explicit tile T, pen p=currentpen) {
  draw(pic, T.boundary, p);
}

// Draw layer l of mtile.
void draw(picture pic=currentpicture, mtile T, pen p=currentpen, real scaling=1, int l=0) {
  tile Tdl=T.drawtile[l];
  path[] Td=T.transform*Tdl.boundary;
  if(Tdl.fillable) fill(pic, Td, Tdl.fillpen);
  pen dpl=Tdl.drawpen;
  if(dpl != nullpen)
    draw(pic,Td,dpl+scaling*linewidth(dpl));
  else
    draw(pic,Td,p+scaling*linewidth(p));
}

// Draw substitution.
void draw(picture pic=currentpicture, substitution s, pen p=currentpen) {
  for(int k=0; k < s.patch.length; ++k) {
    draw(pic, s.patch[k], p, 1, 0);
  }
}

// Draw mosaic. Layers are drawn in increasing order.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, real inflation=inflation) {
  real scaling=scalelinewidth ? (inflation)^(1-max(M.n,1)) : 1;
  for(int l=0; l < M.layers; ++l) {
    for(int k=0; k < M.tiles.length; ++k){
      draw(pic, M.tiles[k], p, scaling, l);
    }
  }
}

// Draw layer l of mosaic.
void draw(picture pic=currentpicture, mosaic M, int l, pen p=currentpen,
          bool scalelinewidth=true, real inflation=inflation) {
  real scaling=scalelinewidth ? (inflation)^(1-max(M.n,1)) : 1;
  for(int k=0; k < M.tiles.length; ++k)
    draw(pic, M.tiles[k], p, scaling, l);
}
