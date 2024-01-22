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

tile duplicate(tile T) {
  return tile(copy(T.boundary),T.fillpen, T.drawpen);
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
  pen[] fillpen;
  pen[] drawpen;

  //bool[] fillable;

  restricted int layers;

  string id;

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    if(drawtile == nulltile) {
      this.drawtile.push(tile(prototile.boundary, fillpen, drawpen));
    } else {
      this.drawtile.push(tile(drawtile.boundary, fillpen, drawpen));
    }
    //this.drawtile.push(drawtile == nulltile ? this.prototile : drawtile);

    //this.drawtile[0].fillpen=fillpen;
    //this.drawtile[0].drawpen=drawpen;

    //this.fillpen.push(fillpen);
    //this.drawpen.push(drawpen);

    this.layers=1;
    this.id=id;
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile[] drawtile, pen[] fillpen, pen[] drawpen, string id="") {
    //int L=drawtile.length;
    //assert(fillpen.length == L && drawpen.length == L);
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    //this.fillpen=fillpen;
    //this.drawpen=drawpen;

    this.layers=drawtile.length;
    this.id=id;
  }

// TODO: what if the drawtiles comes with colours?
  void addlayer(tile drawtile, pen fillpen, pen drawpen) {
    this.drawtile.push(duplicate(drawtile));
    bool fpnull=fillpen == nullpen;
    bool dpnull=drawpen == nullpen;

    if(drawtile.fillable) {
      drawtile.fillpen=fillpen;
      drawtile.drawpen=drawpen;
    } else {
      if(fpnull & !dpnull) {
        drawtile.fillpen=nullpen;
        drawtile.drawpen=drawpen;
      }
      else if(dpnull & !fpnull) {
        drawtile.fillpen=nullpen;
        drawtile.drawpen=fillpen;
      }
    }
    this.layers+=1;
  }

  void setdrawtile(tile drawtile, int ind) {
    this.drawtile[ind]=drawtile;
  }

  void setpen(pen fillpen, pen drawpen, int ind) {
    bool fpnull=fillpen == nullpen;
    bool dpnull=drawpen == nullpen;
    write(ind);
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
    pen fp=fillpen == nullpen ? protile.fillpen : fillpen;
    pen dp=drawpen == nullpen ? protile.drawpen : drawpen;
    m=mtile(transform,this.supertile,protile,drawtile,fp,dp,id);
    this.patch.push(m);
  }
}

mtile duplicate(mtile T) {
  return mtile(T.transform, T.supertile, T.prototile, T.drawtile, T.fillpen, T.drawpen, T.id);
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
      for(int i=0; i < patch.length; ++i) {
        mtile patchi=patch[i];
        if(patchi.supertile == T.prototile)
          loop(patch, T*patchi, n, k+1,tiles,inflation);
      }
    else
      tiles.push(scale(inflation)^n*T);
  }

struct mosaic {
  mtile[] tiles={};
  tile supertile;
  int n=0;
  substitution[] rules;
  mtile[] patch;
  int layers;


  void substitute(int n, real inflation=inflation) {
    int L=this.patch.length;
    mtile[] patchcopy=new mtile[L];
    for(int i=0; i < L; ++i) {
      patchcopy[i]=duplicate(this.patch[i]);
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
    if(sTL == 0){
      loop(patchcopy,mtile(this.supertile),n,0,tiles,inflation);
    }
    else
      for(int i=0; i < sTL; ++i)
        loop(patchcopy,this.tiles[i],n,0,tiles,inflation);
    this.tiles=tiles;
    this.n+=n;
  }

  // addlayer() Adds a new layer with a drawtile, fillpen and drawpen.
  // If only 1 pen p is specified, addlayer() checks whether or not the drawtile is fillable. If it is, p is the fillpen, and if not p is the drawpen
  // The drawtile can be a pair, in which only the drawpen can be passed.
  void addlayer(tile drawtile=nulltile, pen fillpen=invisible, pen drawpen=nullpen) {
    int L=patch.length;
    for(int i=0; i < L; ++i) {
      patch[i].addlayer(drawtile,fillpen,drawpen);
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

  void operator init(tile supertile=nulltile, int n=0, real inflation=inflation ...substitution[] rules) {

    this.rules=rules;
    int L=rules.length;
    for(int i=0; i < L; ++i) {
      this.patch.append(rules[i].patch);
    }
    // If supertile is not specified, use supertile from first specified rule.
    if(supertile == nulltile) {
      this.supertile=rules[0].supertile;
    } else {
      for(int i=0; i < L; ++i) {
        if(supertile==rules[i].supertile) {
          this.supertile=supertile;
          break;
        }
      assert(i < L, "Supertile in mosaic does not match supertile in provided substitutions.");
      }
    }
    assert(n > 0,"Mosaics must be initialized with a positive number of iterations n.");
    this.substitute(n,inflation);

    this.layers=1;
  }
}

mosaic duplicate(mosaic M) {
  mosaic M2;
  int Lt=M.tiles.length;
  mtile[] M2tiles=new mtile[Lt];
  for(int i=0; i < Lt; ++i) {
    M2tiles[i]=duplicate(M.tiles[i]);
  }
  M2.tiles=M2tiles;
  M2.supertile=duplicate(M.supertile);
  M2.n=M.n;
  int Lr=M.rules.length;
  substitution[] M2rules=new substitution[Lr];
  for(int i=0; i < Lr; ++i) {
    M2rules[i]=duplicate(M.rules[i]);
  }
  M2.rules=M2rules;
  int Lp=M.patch.length;
  mtile[] M2patch=new mtile[Lp];
  for(int i=0; i < Lp; ++i) {
    M2patch[i]=duplicate(M.patch[i]);
  }
  M2.layers=M.layers;
  return M2;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=duplicate(M);
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
