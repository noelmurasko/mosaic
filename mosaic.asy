real inflation=1;
private real globalinflation() {return inflation;}

real newinflation=1;

// Return the square of the scaling applied by a transform T
// i.e. det(abs(M)), where M is the matrix (shiftless) part of T.
real scale2(transform T) {
  transform M=shiftless(T);
  return abs(M.xx*M.yy-M.xy*M.yx);
}

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

  void operator init(path[] boundary, pen fillpen=nullpen, pen drawpen=nullpen, real area=1) {
    this.boundary=boundary;
    this.fillable=checkfillable(boundary);
    this.fillpen=fillpen;
    this.drawpen=drawpen;
    this.length=boundary.length;
  }
}

tile operator cast(path[] p, pen fillpen=nullpen, pen drawpen=nullpen) {
  return tile(p,fillpen,drawpen);
}

tile operator cast(path[] p) {
  return tile(p);
}

tile operator cast(pair p, pen fillpen=nullpen, pen drawpen=nullpen) {
  return tile((path) p,fillpen,drawpen);
}

tile operator cast(pair p) {
  return tile((path) p);
}

tile operator cast(path p, pen fillpen=nullpen, pen drawpen=nullpen) {
  return tile(p,fillpen,drawpen);
}

tile operator cast(path p) {
  return tile(p);
}

tile operator cast(guide g, pen fillpen=nullpen, pen drawpen=nullpen) {
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

// Note that the fillpen and drawpen the new tile is the same as t1.
tile operator ^^(tile t1, tile t2) {
  return tile(t1.boundary^^t2.boundary, t1.fillpen, t1.drawpen);
}

// write tiles (just writes boundary)
void write(string s="", explicit tile t) {
  write(s,t.boundary);
}

tile nulltile=tile(nullpath);


real trianglearea(pair p1, pair p2, pair p3) {
  return abs(((p2.x*p3.y-p2.y*p3.x)-(p1.x*p3.y-p1.y*p3.x)+(p1.x*p2.y-p1.y*p2.x)))/2;
}

real trianglearea(tile t) {
  path p=t.boundary[0];
  assert(cyclic(p) && length(p) == 3);
  return trianglearea(point(p,0), point(p,1), point(p,2));
}

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
  int index; // Used to determine location of tile in a patch

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    pen fp=fillpen == nullpen ? dt.fillpen : fillpen;
    pen dp=drawpen == nullpen ? dt.drawpen : drawpen;

    this.drawtile.push(tile(dt.boundary, fp, dp));

    this.layers=1;
    this.id=id;
    this.index=0;
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

bool lessinflated(mtile t1, mtile t2) {
  return scale2(t1.transform) < scale2(t2.transform);
}

struct substitution {
  tile supertile;
  mtile[] patch;
  real inflation;

  void operator init(explicit tile supertile) {
    this.supertile=supertile;
    this.inflation=globalinflation();
  }

  void operator init(explicit tile supertile, real inflation) {
    this.supertile=supertile;
    this.inflation=inflation;
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    mtile m;
    m=mtile(transform,this.supertile,prototile,drawtile,fillpen,drawpen,id);
    this.patch.push(m);
  }
}

// Create a deep copy of the mtile mt.
mtile copy(mtile mt) {
  int L=mt.drawtile.length;
  tile[] dtcopy=new tile[L];
  for(int i; i < L; ++i)
    dtcopy[i]=copy(mt.drawtile[i]);
  // If supertile and prototile are the same, make only one copy
  if(mt.supertile == mt.prototile) {
    tile super2=copy(mt.supertile);
    return mtile(mt.transform, super2, super2, dtcopy, mt.index, mt.id);
  } else
    return mtile(mt.transform, copy(mt.supertile), copy(mt.prototile), dtcopy,
      mt.index, mt.id);
}

// Create a deep copy of the substitution s1.
substitution copy(substitution s1) {
  substitution s2=substitution(copy(s1.supertile),s1.inflation);
  for(int i=0; i < s1.patch.length; ++i)
    s2.patch.push(copy(s1.patch[i]));
  return s2;
}

// Create a new mtile mt2 from mt1 with a shallow copy of the supertile,
// prototile, and  drawtile.
mtile duplicate(mtile mt1) {
  mtile mt2=mtile(mt1.transform, mt1.supertile, mt1.prototile, mt1.drawtile, mt1.index, mt1.id);
  return mt2;
}

// Create a new substitution s2 from s1 with a shallow copy of the patch.
substitution duplicate(substitution s1) {
  substitution s2=substitution(s1.supertile);
  s2.patch=s1.patch;
  s2.inflation=s1.inflation;
  return s2;
}

mtile operator *(mtile mt1, mtile mt2) {
  mtile mt3=duplicate(mt2);
  mt3.transform=mt1.transform*mt2.transform;
  return mt3;
}

mtile operator *(transform T, mtile mt1) {
  mtile mt2=duplicate(mt1);
  mt2.transform=T*mt2.transform;
  return mt2;
}

mtile[] operator *(transform T, mtile[] mt1) {
  int L=mt1.length;
  mtile[] mt2=new mtile[L];
  for(int i=0; i < mt1.length; ++i)
    mt2[i]=T*mt1[i];
  return mt2;
}

struct mosaic {
  mtile[] tiles;
  tile supertile;
  int n=0;
  mtile[] patch;
  int layers;
  real inflation;

  // tilecount[k] is the number of tiles in iteration k
  int[] tilecount;

  // addlayer() Adds a new layer with a drawtile, fillpen and drawpen.
  // If only 1 pen p is specified, addlayer() checks whether or not the drawtile is fillable. If it is, p is the fillpen, and if not p is the drawpen
  void addlayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen) {
    pen fp;
    pen dp;
    bool fpnull=fillpen == nullpen;
    bool dpnull=drawpen == nullpen;
    bool tilehasfillpen=drawtile.fillpen != nullpen;
    bool tilehasdrawpen=drawtile.drawpen != nullpen;

    if(drawtile.fillable) {
      fp=tilehasfillpen ? drawtile.fillpen : fillpen;
      dp=tilehasdrawpen ? drawtile.drawpen : drawpen;
    } else {
      if(fpnull & !dpnull) {
        fp=nullpen;
        dp=tilehasdrawpen ? drawtile.drawpen : drawpen;
      }
      else if(dpnull & !fpnull) {
        fp=nullpen;
        dp=tilehasfillpen ? drawtile.fillpen : fillpen;
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

  private void iterate(mtile T, mtile[] tiles,
          real inflation=inflation) {
    mtile patchi;
    for(int i=0; i < patch.length; ++i) {
      patchi=patch[i];
      if(patchi.supertile == T.prototile) {
        tiles.push(scale(inflation)*T*patchi);
      }
    else
      tiles.push(scale(inflation)^n*T);
    }
  }

  private void loopMS(mtile T, mtile[] tiles, bool applytransform=true,
          real inflation=inflation) {
    //write(patch.length);
    mtile[] correctprototiles;
    if(applytransform) {
      for(int i=0; i < patch.length; ++i) {
        mtile patchi=patch[i];
        if(patchi.supertile == T.prototile) {
            tiles.push(scale(inflation)*T*patchi);
        }
      }
    } else {
      tiles.push(scale(inflation)*T);
      //correctprototiles.push(patchi);
    }
  }

  void substituteMS(real threshold=1, real inflation=inflation) {
    this.n+=1;
    mtile[] tiles=new mtile[];
    int sTL=this.tiles.length;
    if(sTL == 0) {
      this.tilecount.push(1);
      this.loopMS(mtile(this.supertile),tiles,inflation);
      this.tiles=tiles;
    }
    else {
      int[] indices;

      // rule can be either "biggest" or "threshold"
      string rule="threshold";
      for(int i=0; i< this.tiles.length; ++i) {
        //write(trianglearea(this.tiles[i].transform*this.tiles[i].prototile));
      }
      // Only iterate biggest (of same tile type)
      if(rule == "biggest") {
        indices.push(0);
        mtile[] sortedtiles={this.tiles[0]};
        for(int i=1; i < this.tiles.length; ++i) {
          mtile tilei=this.tiles[i];
          bool addon=true;
          //write();
          //write(trianglearea(tilei.transform*tilei.prototile));
          for(int j=0; j < indices.length; ++j) {
            mtile tilej=this.tiles[indices[j]];
            //write(trianglearea(tilej.transform*tilej.prototile));

            if(tilej.prototile == tilei.prototile) {
              //write(trianglearea(tilej.transform*tilej.prototile)-trianglearea(tilei.transform*tilei.prototile));
              //write(trianglearea(tilej.transform*tilej.prototile)==trianglearea(tilei.transform*tilei.prototile));
              //write();
              addon=false;
              if(abs(trianglearea(tilej.transform*tilej.prototile) - trianglearea(tilei.transform*tilei.prototile))<1e-12){
                //if(lessinflated(tilej,tilei)) {
                //write(scale2(tilei.transform),i);
                //write(scale2(tilej.transform));
                //write();
                addon=true;

              } else if(trianglearea(tilej.transform*tilej.prototile) < trianglearea(tilei.transform*tilei.prototile)) {
                indices[j]=i;
              }
            }
          //if(addon) sortedtiles.push(tilei);
          }
          if(addon) indices.push(i);
        }
      }

      // Iterate when bigger than threshold
      if(rule == "threshold") {
        mtile[] sortedtiles;
        for(int i=0; i < this.tiles.length; ++i) {
          //write(scale2(this.tiles[i].transform));
          //write(scale2(this.tiles[i].transform)*this.tiles[i].prototile.area*newinflation^(2*this.n));
          //write(newinflation^(2*(this.n-1))*trianglearea(this.tiles[i].transform*this.tiles[i].prototile));
          //write(newinflation^((this.n-1))*sqrt(scale2(this.tiles[i].transform))*trianglearea(this.tiles[i].prototile));
          //write();
          if(newinflation^(2*(this.n-1))*trianglearea(this.tiles[i].transform*this.tiles[i].prototile) >= threshold)
              indices.push(i);
        }
      }

      bool[] applytransform = array(this.tiles.length,false);
      for(int i=0; i < indices.length; ++i) {
        applytransform[indices[i]]=true;
      }

      for(int i=0; i < applytransform.length; ++i) {
        this.loopMS(this.tiles[i],tiles,applytransform[i],inflation);
      }
      this.tiles=tiles;
    }
    int tilesl=tiles.length;
    this.tilecount.push(tilesl);
  }

  void operator init(tile supertile=nulltile, int n=0, bool multiscale=false, real threshold=1 ...substitution[] rules) {
    int ind=0;
    int Lr=rules.length;
    assert(rules.length > 0,"Mosaics must have at least one substitution.");

    this.inflation=rules[0].inflation;
    substitution rulesi=rules[0];
    mtile[] rulesipatch=rulesi.patch;
    mtile rulesipatchj;
    for(int j=0; j < rulesipatch.length; ++j) {
      rulesipatchj=duplicate(rulesipatch[j]);
      rulesipatchj.index=ind;
      ind+=1;
      this.patch.push(rulesipatchj);
    }
    for(int i=1; i < Lr; ++i) {
      rulesi=rules[i];
      rulesipatch=rulesi.patch;
      assert(rulesi.inflation == this.inflation,"All substitutions in a mosaic must have the same inflation factor.");
      for(int j=0; j < rulesipatch.length; ++j) {
        rulesipatchj=duplicate(rulesipatch[j]);
        rulesipatchj.index=ind;
        ind+=1;
        this.patch.push(rulesipatchj);
      }
    }
    int Lp=this.patch.length;
    real deflation=1/inflation;
    mtile patchi;
    for(int i=0; i < Lp; ++i) {
      patchi=patch[i];
      if(patchi.prototile == nulltile) {
        patchi.prototile=this.supertile;
      }
      if(patchi.supertile == nulltile) {
        patchi.supertile=this.supertile;
      }
      transform Ti=patch[i].transform;
      patchi.transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
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
    if(n > 0) {
      if(multiscale) {
        //real threshold=0;
        //for(int i=4; i < patch.length; ++i) {
        //  real area=newinflation^2*trianglearea(this.patch[i].transform*this.patch[i].prototile);
        //  if(area > threshold) threshold = area;
        //}
        //write();
        //threshold-=1e-14;
        //this.substitute(1,inflation);
        for(int k=0; k < n; ++k) {
          this.substituteMS(threshold, inflation);
        }
      } else {
        for(int k=0; k < n; ++k) {
          mtile[] tiles=new mtile[];
          int sTL=this.tiles.length;
          if(sTL == 0) {
            this.tilecount.push(1);
            this.iterate(mtile(this.supertile),tiles,inflation);
          }
          else {
            for(int i=0; i < sTL; ++i)
              this.iterate(this.tiles[i],tiles,inflation);
          }
          this.tiles=tiles;
          int tilesl=tiles.length;
          this.tilecount.push(tilesl);
        }
        this.n+=n;
      }
    }
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

// Create a deep copy of the mosaic M.
mosaic copy(mosaic M) {
  mosaic M2;

  M2.n=M.n;
  M2.layers=M.layers;
  M2.inflation=M.inflation;

  M2.tilecount=M.tilecount;

  int Lt=M.tiles.length;
  int Lp=M.patch.length;

  tile[] Msupertiles;
  tile[] Mprototiles;

  M2.patch.push(copy(M.patch[0]));
  Msupertiles.push(M.patch[0].supertile);
  Mprototiles.push(M.patch[0].prototile);

  mtile patchj;
  for(int j=1; j < Lp; ++j) {
    patchj=copy(M.patch[j]);
    int is=searchtile(Msupertiles, M.patch[j].supertile);
    if(is != -1)
      patchj.supertile=M2.patch[is].supertile;
    Msupertiles.push(M.patch[j].supertile);

    int ip=searchtile(Mprototiles, M.patch[j].prototile);
    if(ip != -1)
      patchj.prototile=M2.patch[ip].prototile;

    Mprototiles.push(M.patch[j].supertile);

    M2.patch.push(patchj);
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

real inflationscaling(bool scalelinewidth, real inflation, int n) {
  return scalelinewidth ? (inflation)^(1-max(n,1)) : 1;
}

// draw tile t
void draw(picture pic=currentpicture, explicit tile t, pen p=currentpen) {
  if(t.drawpen != nullpen) draw(pic, t.boundary, t.drawpen);
  else  draw(pic, t.boundary, p);
}

void fill(picture pic=currentpicture, explicit tile t) {
  fill(pic, t.boundary, t.fillpen);
}

void filldraw(picture pic=currentpicture, explicit tile t, pen p=currentpen) {
  draw(pic, t.boundary, p);
  fill(pic, t.boundary, t.fillpen);
}

// Draw layer l of mtile.
void draw(picture pic=currentpicture, mtile T, pen p=currentpen, real scaling=1, int layer=0) {
  tile Tdl=T.drawtile[layer];
  path[] Td=T.transform*Tdl.boundary;
  pen dpl=Tdl.drawpen;
  if(dpl != nullpen)
    draw(pic,Td,dpl+scaling*linewidth(dpl));
  else
    draw(pic,Td,p+scaling*linewidth(p));
}

void fill(picture pic=currentpicture, mtile T, int layer=0) {
  tile Tdl=T.drawtile[layer];
  path[] Td=T.transform*Tdl.boundary;
  if(Tdl.fillable) fill(pic, Td, Tdl.fillpen);
}

void filldraw(picture pic=currentpicture, mtile T, pen p=currentpen, real scaling=1, int layer=0) {
  fill(pic,T,layer);
  draw(pic,T,p,scaling,layer);
}

// Draw substitution. If drawoutline == true, also draw the supertile with
// outlinepen, scaled by inflation.
void draw(picture pic=currentpicture, substitution s, pen p=currentpen,
              bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.patch.length; ++k)
    draw(pic, s.patch[k], p, 1, 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void fill(picture pic=currentpicture, substitution s,
          bool drawoutline=false,
          pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.patch.length; ++k)
    fill(pic, s.patch[k], 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void filldraw(picture pic=currentpicture, substitution s, pen p=currentpen,
              bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.patch.length; ++k)
    filldraw(pic, s.patch[k], p, 1, 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

// Draw mosaic. Layers are drawn in increasing order.
// If scalelinewidth == true, the linewidth of the pen is scaled by the
// inflation nscale times. The default value of nscale is the number of
// iterations in the mosaic. When drawing a mosaic several times one mosaic
// multiple times (with different iterations) nscale provides a convenient way
// to use the same linewidth each time.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int l=0; l < M.layers; ++l)
    for(int k=0; k < M.tiles.length; ++k)
      draw(pic, M.tiles[k], p, scaling, l);
}

void fill(picture pic=currentpicture, mosaic M) {
  for(int l=0; l < M.layers; ++l)
    for(int k=0; k < M.tiles.length; ++k)
      fill(pic, M.tiles[k], l);
}

void filldraw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int l=0; l < M.layers; ++l)
    for(int k=0; k < M.tiles.length; ++k)
      filldraw(pic, M.tiles[k], p, scaling, l);
}

// Draw layer of mosaic.
void draw(picture pic=currentpicture, mosaic M, int layer, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int k=0; k < M.tiles.length; ++k)
    draw(pic, M.tiles[k], p, scaling, layer);
}

void fill(picture pic=currentpicture, mosaic M, int layer) {
  for(int k=0; k < M.tiles.length; ++k)
    fill(pic, M.tiles[k], layer);
}

void filldraw(picture pic=currentpicture, mosaic M, int layer, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int k=0; k < M.tiles.length; ++k)
    filldraw(pic, M.tiles[k], p, scaling, layer);
}
