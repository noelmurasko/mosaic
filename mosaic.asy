real inflation=1;

struct mtile {
  transform transform;
  path[] supertile;
  path[] prototile;

  path[][] drawtile={};
  pen[] fillpen;
  pen[] drawpen;

  bool[] fillable;

  restricted int layers;

  string id;

  bool checkfillable(path[] drawtile, int ind=0) {
    for(int i=0; i < drawtile.length; ++i)
      if(!cyclic(drawtile[i])) return false;
    return true;
  }

  void operator init(transform transform=identity, path[] supertile, path[] prototile={},
                     path[] drawtile={}, pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile.length == 0 ? supertile : prototile;

    this.drawtile.push(drawtile.length == 0 ? this.prototile : drawtile);
    this.fillable.push(checkfillable(drawtile));
    this.fillpen.push(fillpen);
    this.drawpen.push(drawpen);

    this.layers=1;
    this.id=id;
  }

  void operator init(transform transform=identity, path[] supertile, path[] prototile={},
                     pair drawtile, pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile.length == 0 ? supertile : prototile;

    this.drawtile.push((path) drawtile);
    this.fillable.push(checkfillable((path) drawtile));
    this.fillpen.push(fillpen);
    this.drawpen.push(drawpen);


    this.layers=1;
    this.id=id;
  }

  void operator init(transform transform=identity, path[] supertile, path[] prototile={},
                     path[][] drawtile={}, pen[] fillpen, pen[] drawpen, string id="") {
    int L=drawtile.length;
    assert(fillpen.length == L && drawpen.length == L);
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile.length == 0 ? supertile : prototile;

    this.drawtile=drawtile;
    this.fillpen=fillpen;
    this.drawpen=drawpen;

    int L=drawtile.length;
    for(int i=0; i < L; ++i) {
      this.fillable.push(checkfillable(drawtile[i]));
    }
    this.layers=L;

    this.id=id;
  }

  void addlayer(path[] drawtile, pen fillpen, pen drawpen) {
    this.drawtile.push(drawtile);
    this.fillable.push(checkfillable(drawtile));
    this.fillpen.push(fillpen);
    this.drawpen.push(drawpen);
    this.layers+=1;
  }

  void addlayer(path[] drawtile={}, pen p=nullpen) {
    this.drawtile.push(drawtile);
    bool fillable=checkfillable(drawtile);
    if(fillable) {
      this.fillpen.push(p);
      this.drawpen.push(nullpen);
    } else {
      this.fillpen.push(nullpen);
      this.drawpen.push(p);
    }
    layers+=1;
  }

  void setdrawtile(path[] drawtile, int ind) {
    this.drawtile[ind]=drawtile;
    this.fillable[ind]=checkfillable(drawtile);
  }

  void setfillpen(pen fillpen, int ind) {
    this.fillpen[ind]=fillpen;
  }

  void setdrawpen(pen drawpen, int ind) {
    this.drawpen[ind]=drawpen;
  }
}

struct substitution {
  path[] supertile;
  mtile[] patch;

  void operator init(path[] supertile={}) {
    this.supertile=supertile;
  }

  void addtile(transform transform=identity, path[] prototile={}, path[] drawtile={},
                     pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    mtile m;
    if(prototile.length == 0)
      m=mtile(transform,this.supertile,drawtile=drawtile,fillpen,drawpen,id);
    else
      m=mtile(transform,this.supertile,prototile,drawtile,fillpen,drawpen,id);
    this.patch.push(m);
  }

  void addtile(transform transform=identity, path[] prototile={}, pair drawtile,
    pen fillpen=invisible, pen drawpen=nullpen, string id="") {
    mtile m;
    if(prototile.length == 0)
      m=mtile(transform,this.supertile,drawtile=drawtile,fillpen,drawpen,id);
    else
      m=mtile(transform,this.supertile,prototile,drawtile,fillpen,drawpen,id);
    this.patch.push(m);
  }
}

mtile copy(mtile T) {
  return mtile(T.transform, copy(T.supertile), copy(T.prototile), T.drawtile, T.fillpen, T.drawpen, T.id); // Do not do deep copy of drawtile, fillpen, or drawpen
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
  path[] supertile;
  int n;
  substitution[] rules;
  mtile[] patch;
  int layers;

  private void loop(mtile[] patch, mtile T, int n, int k, mtile[] tiles,
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

  void substitute(int n, real inflation=inflation) {
    int L=this.patch.length;
    mtile[] patchcopy=new mtile[L];
    for(int i=0; i < L; ++i) {
      patchcopy[i]=copy(this.patch[i]);
    }
    mtile[] tiles;
    for(int i=0; i < L; ++i) {
      mtile T=patchcopy[i];
      if(T.prototile.length == 0) {
        T.prototile=this.supertile;
      }
      if(T.supertile.length == 0) {
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
  }

  // addlayer() Adds a new layer with a drawtile, fillpen and drawpen.
  // If only 1 pen p is specified, addlayer() checks whether or not the drawtile is fillable. If it is, p is the fillpen, and if not p is the drawpen
  // The drawtile can be a pair, in which only the drawpen can be passed.

  void addlayer(path[] drawtile, pen fillpen, pen drawpen) {
    int L=patch.length;
    for(int i=0; i < L; ++i) {
      patch[i].addlayer(drawtile,fillpen,drawpen);
    }
    layers+=1;
  }

  void addlayer(path[] drawtile={}, pen p=nullpen) {
    int L=patch.length;
    for(int i=0; i < L; ++i) {
      patch[i].addlayer(drawtile,p);
    }
    layers+=1;
  }

  void addlayer(pair drawtile, pen drawpen=nullpen) {
    this.addlayer((path) drawtile,invisible,drawpen);
  }

  // set() sets the drawtile, fillpen, and/or drawpen for a layer l and tiles that have id in ids.
  void set(path[] drawtile, int l=-1, string[] ids) {

    int ind=l < 0 ? layers-1 : l;
    if(ids.length == 0)
      for(int i=0; i < patch.length; ++i) {
        patch[i].setdrawtile(drawtile,ind);
      }
    else
      for(int i=0; i < tiles.length; ++i) {
        for(int j=0; j < ids.length; ++j) {
          if(patch[i].id == ids[j]) {
            patch[i].setdrawtile(drawtile,ind);
            break;
          }
        }
      }
  }

  void set(path[] drawtile, int l=-1 ...string[] ids) {
    set(drawtile, l, ids);
  }

  void set(pair drawtile, int l=-1, string[] ids) {
    set((path[]) (path) drawtile, l,ids);
  }

  void set(pair drawtile, int l=-1 ...string[] ids) {
    set((path[]) (path) drawtile, l,ids);
  }

  void set(pen fillpen, pen drawpen, int l=-1, string[] ids={}) {
    int ind=l < 0 ? layers-1 : l;
    if(ids.length == 0)
      for(int i=0; i < patch.length; ++i) {
        if(fillpen != nullpen) patch[i].setfillpen(fillpen,ind);
        if(drawpen != nullpen) patch[i].setdrawpen(drawpen,ind);
      }
    else
      for(int i=0; i < patch.length; ++i) {
        for(int j=0; j < ids.length; ++j) {
          if(patch[i].id == ids[j]) {
            // why not nullpen?
            if(fillpen != nullpen) patch[i].setfillpen(fillpen,ind);
            if(drawpen != nullpen) patch[i].setdrawpen(drawpen,ind);
            break;
          }
        }
      }
  }

  void set(pen fillpen, pen drawpen, int l=-1 ...string[] ids) {
    set(fillpen,drawpen,l,ids);
  }

  void set(pen p, int l=-1, string[] ids) {
    int ind=l < 0 ? layers-1 : l;
    if(ids.length == 0)
      for(int i=0; i < patch.length; ++i) {
        bool fillable=true;
        for(int n=0; n < patch[i].drawtile[ind].length; ++n) {
          if(cyclic(patch[i].drawtile[ind][n]) == false) fillable=false;
          break;
        }
        if(fillable) {
          patch[i].setfillpen(p,ind);
        } else {
          patch[i].setdrawpen(p,ind);
        }
      }
    else
      for(int i=0; i < patch.length; ++i) {
        for(int j=0; j < ids.length; ++j) {
          if(patch[i].id == ids[j]) {
            bool fillable=true;
            for(int n=0; n < patch[i].drawtile[ind].length; ++n) {
              if(cyclic(patch[i].drawtile[ind][n]) == false) fillable=false;
              break;
            }
            if(fillable) {
              patch[i].setfillpen(p,ind);
            } else {
              patch[i].setfillpen(p,ind);
            }
            break;
          }
        }
      }
  }

  void set(pen p, int l=-1 ...string[] id) {
    set(p, l, id);
  }

  void set(path[] drawtile, pen fillpen, pen drawpen, int l=-1 ...string[] id) {
    set(drawtile,l,id);
    set(fillpen,drawpen,l,id);
  }

  void set(path[] drawtile, pen p, int l=-1 ...string[] id) {
    set(drawtile,l,id);
    set(p,l,id);
  }

  void set(pair drawtile, pen p, int l=-1 ...string[] id) {
    set(drawtile,l,id);
    set(p,l,id);
  }
  void operator init(path[] supertile={}, int n=0, real inflation=inflation ...substitution[] rules) {
    // If supertile is not specified, use supertile from first specified rule.
    if(supertile.length == 0)
      this.supertile=rules[0].supertile;
    else
      this.supertile=supertile;

    assert(n > 0); // Fix me
    this.n=n;
    this.rules=rules;
    int L=rules.length;
    for(int i=0; i < L; ++i) {
      this.patch.append(rules[i].patch);
    }
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
  path[] Td=T.transform*T.drawtile[l];
  for(int j=0; j < Td.length; ++j) {
    if(cyclic(Td[j]) == true) fill(pic, Td[j], T.fillpen[l]);
  }
  pen dpl=T.drawpen[l];
  if(dpl != nullpen)
    draw(pic,Td,dpl+scaling*linewidth(dpl));
  else
    draw(pic,Td,p+scaling*linewidth(p));
}


void draw(picture pic=currentpicture, substitution s, pen p=currentpen) {
  for(int k=0; k < s.patch.length; ++k)
    draw(pic, s.patch[k], p, 1, 0);
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
