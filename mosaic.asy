real inflation=1;
private real globalinflation() {return inflation;}

struct tile {
  path[] path;

  pen fillpen;
  pen drawpen;

  pen axialpena;
  pen axialpenb;
  pair axiala;
  pair axialb;

  pen radialpena;
  pen radialpenb;
  pair radiala;
  pair radialb;
  real radialra;
  real radialrb;

  string id;

  private void initializer(path[] path, pen fillpen=nullpen,
                           pen drawpen=nullpen, pen axialpena=nullpen,
                           pair axiala=(0,0), pen axialpenb=nullpen,
                           pair axialb=(0,0), pen radialpena=nullpen,
                           pair radiala=(0,0), real radialra=0,
                           pen radialpenb=nullpen, pair radialb=(0,0),
                           real radialrb=0, string id="") {
    this.path=path;

    this.fillpen=fillpen;
    this.drawpen=drawpen;

    this.axialpena=axialpena;
    this.axialpenb=axialpenb;
    this.axiala=axiala;
    this.axialb=axialb;

    this.radialpena=radialpena;
    this.radialpenb=radialpenb;
    this.radiala=radiala;
    this.radialb=radialb;
    this.radialra=radialra;
    this.radialrb=radialrb;

    this.id=id;
  }

  void operator init(path[] path={}, pen fillpen=nullpen, pen drawpen=nullpen,
                     string id="") {
    this.initializer(path, fillpen, drawpen, id);
  }

  void operator init(path[] path={}, pen axialpena=nullpen, pair axiala,
                     pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen,
                     pen drawpen=nullpen, string id="") {
    this.initializer(path, fillpen, drawpen, axialpena, axiala, axialpenb,
                     axialb, id);
  }

  void operator init(path[] path={}, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb, pen fillpen=nullpen, pen drawpen=nullpen,
                     string id="") {
    this.initializer(path, fillpen, drawpen, radialpena, radiala, radialra,
                     radialpenb, radialb, radialrb, id);
  }

  void operator init(path[] path={},pen fillpen=nullpen, pen drawpen=nullpen,
                     pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen,
                     pair axialb, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb, string id="") {
    this.initializer(path, fillpen, drawpen, axialpena, axiala, axialpenb,
                     axialb, radialpena, radiala, radialra, radialpenb, radialb,
                     radialrb, id);
  }

  void operator init(pair path, pen fillpen=nullpen, pen drawpen=nullpen,
                     string id="") {
    this.initializer(new path[] {path}, fillpen=fillpen, drawpen=drawpen,id);
  }

  void operator init(pair path, pen axialpena=nullpen, pair axiala,
                     pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen,
                     pen drawpen=nullpen, string id="") {
    this.initializer(new path[] {path}, fillpen, drawpen, axialpena, axiala,
                     axialpenb, axialb, id);
  }

  void operator init(pair path, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb, pen fillpen=nullpen, pen drawpen=nullpen,
                     string id="") {
    this.initializer(new path[] {path}, fillpen, drawpen, radialpena, radiala,
                     radialra, radialpenb, radialb, radialrb, id);
  }

  void operator init(pair path,pen fillpen=nullpen, pen drawpen=nullpen,
                     pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen,
                     pair axialb, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb, string id="") {
    this.initializer(new path[] {path}, fillpen, drawpen, axialpena, axiala,
                     axialpenb, axialb, radialpena, radiala, radialra,
                     radialpenb, radialb, radialrb, id);
  }

  bool fillable() {
    for(int i=0; i < this.path.length; ++i)
      if(!cyclic(this.path[i])) return false;
    return true;
  }
}

tile operator cast(path[] p) {
  return tile(p);
}

tile operator cast(path p) {
  return tile(p);
}

tile operator cast(guide g) {
  return tile(g);
}

tile operator cast(pair p) {
  return tile(p);
}

tile copy(tile t) {
  return tile(copy(t.path), t.fillpen, t.drawpen, t.axialpena, t.axiala,
              t.axialpenb, t.axialb, t.radialpena, t.radiala, t.radialra,
              t.radialpenb, t.radialb, t.radialrb, t.id);
}

tile operator *(transform T, tile t1) {
  tile t2=copy(t1);
  t2.path=T*t1.path;
  t2.axiala=T*t1.axiala;
  t2.axialb=T*t1.axialb;
  t2.radiala=T*t1.radiala;
  t2.radialb=T*t1.radialb;
  return t2;
}

// Note that pens and shading settings of the new tile are the same as t1.
tile operator ^^(tile t1, tile t2) {
  tile t3=copy(t1);
  t3.path=t1.path^^t2.path;
  return t3;
}

tile nulltile=tile(nullpath);

struct tessera {
  transform transform;
  tile supertile;
  tile prototile;

  tile[] drawtile={};

  restricted int layers;
  string id;
  int index; // Used to determine location of tile in the mosaic subpatch
  bool iterate;

  private void initializer(transform transform, tile supertile, tile prototile,
                           tile drawtile, pen fillpen, pen drawpen,
                           pen axialpena, pair axiala, pen axialpenb,
                           pair axialb, pen radialpena, pair radiala,
                           real radialra, pen radialpenb, pair radialb,
                           real radialrb, string id="", bool iterate=true) {
    this.transform=transform;
    this.supertile=supertile;

    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    pen fp=fillpen == nullpen ? dt.fillpen : fillpen;
    pen dp=drawpen == nullpen ? dt.drawpen : drawpen;

    this.drawtile.push(tile(dt.path, fp, dp, axialpena, axiala,
                       axialpenb, axialb, radialpena, radiala, radialra,
                       radialpenb, radialb, radialrb));

    this.layers=1;
    this.id=length(id) == 0 ? this.prototile.id : id;
    this.index=0;
    this.iterate=iterate;
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="",
                     bool iterate=true) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, dt.axialpena, dt.axiala, dt.axialpenb, dt.axialb,
                     dt.radialpena, dt.radiala, dt.radialra, dt.radialpenb,
                     dt.radialb, dt.radialrb, id, iterate);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen axialpena, pair axiala, pen axialpenb, pair axialb,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="",
                     bool iterate=true) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen,axialpena, axiala, axialpenb, axialb,
                     dt.radialpena, dt.radiala, dt.radialra, dt.radialpenb,
                     dt.radialb, dt.radialrb, id, iterate);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen radialpena, pair radiala, real radialra,
                     pen radialpenb, pair radialb, real radialrb,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="",
                     bool iterate=true) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, dt.axialpena, dt.axiala, dt.axialpenb, dt.axialb,
                     radialpena, radiala, radialra, radialpenb, radialb,
                     radialrb, id, iterate);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, pen axialpena,
                     pair axiala, pen axialpenb, pair axialb, pen radialpena,
                     pair radiala, real radialra, pen radialpenb, pair radialb,
                     real radialrb, string id="",bool iterate=true) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, axialpena, axiala, axialpenb, axialb, radialpena,
                     radiala, radialra, radialpenb, radialb, radialrb, id, iterate);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile[] drawtile, int index,
                     string id="", bool iterate=true) {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    this.index=index;
    this.layers=drawtile.length;
    this.id=length(id) == 0 ? this.prototile.id : id;
    this.iterate=iterate;
  }

  void addlayer() {
    this.drawtile.push(tile());
    this.layers+=1;
  }

  void updatelayer(tile drawtile, int ind) {
    if(drawtile != nulltile) this.drawtile[ind]=copy(drawtile);
  }

  void updatelayer(pen fillpen, pen drawpen, int ind) {
    if(fillpen != nullpen) this.drawtile[ind].fillpen=fillpen;
    if(drawpen != nullpen) this.drawtile[ind].drawpen=drawpen;
  }

  void updatelayer(pen axialpena, pair axiala, pen axialpenb, pair axialb,
                   int ind) {
    if(axialpena != nullpen) this.drawtile[ind].axialpena=axialpena;
    if(axialpenb != nullpen) this.drawtile[ind].axialpenb=axialpenb;
    this.drawtile[ind].axiala=axiala;
    this.drawtile[ind].axialb=axialb;
  }

  void updatelayer(pen radialpena, pair radiala, real radialra, pen radialpenb,
                   pair radialb, real radialrb, int ind) {
    if(radialpena != nullpen) this.drawtile[ind].radialpena=radialpena;
    if(radialpenb != nullpen) this.drawtile[ind].radialpenb=radialpenb;
    this.drawtile[ind].radiala=radiala;
    this.drawtile[ind].radialb=radialb;
    this.drawtile[ind].radialra=radialra;
    this.drawtile[ind].radialrb=radialrb;
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen,int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen, drawpen, ind);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen axialpena,
                   pair axiala, pen axialpenb, pair axialb, int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen, drawpen, ind);
    this.updatelayer(axialpena, axiala, axialpenb, axialb, ind);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen radialpena, pair radiala, real radialra, pen radialpenb, pair radialb, real radialrb, int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen,drawpen,ind);
    this.updatelayer(radialpena,radiala,radialra,radialpenb,radialb,radialrb,ind);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen axialpena, pair axiala, pen axialpenb, pair axialb, pen radialpena, pair radiala, real radialra, pen radialpenb, pair radialb, real radialrb, int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen,drawpen,ind);
    this.updatelayer(axialpena,axiala,axialpenb,axialb,ind);
    this.updatelayer(radialpena,radiala,radialra,radialpenb,radialb,radialrb,ind);
  }
}

struct substitution {
  tile supertile;
  tessera[] subpatch;
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
    tessera m=tessera(transform,this.supertile,prototile,fillpen,drawpen,id);
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
                      pen axialpena, pair axiala, pen axialpenb, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    tessera m=tessera(transform,this.supertile,prototile,axialpena,axiala,axialpenb,axialb,fillpen,drawpen,id);
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, pen radialpena, pair radiala, real radialra, pen radialpenb, pair radialb, real radialrb,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    tessera m=tessera(transform,this.supertile,prototile,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,id);
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, pen axialpena, pair axiala, pen axialpenb, pair axialb, pen radialpena, pair radiala, real radialra, pen radialpenb, pair radialb, real radialrb,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    tessera m=tessera(transform,this.supertile,prototile,fillpen,drawpen,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,id);
    this.subpatch.push(m);
  }
}

// Create a deep copy of the tessera mt.
tessera copy(tessera mt) {
  int L=mt.drawtile.length;
  tile[] dtcopy=new tile[L];
  for(int i; i < L; ++i)
    dtcopy[i]=copy(mt.drawtile[i]);
  // If supertile and prototile are the same, make only one copy
  if(mt.supertile == mt.prototile) {
    tile super2=copy(mt.supertile);
    return tessera(mt.transform, super2, super2, dtcopy, mt.index, mt.id, mt.iterate);
  } else
    return tessera(mt.transform, copy(mt.supertile), copy(mt.prototile), dtcopy,
      mt.index, mt.id, mt.iterate);
}

// Create a deep copy of the substitution s1.
substitution copy(substitution s1) {
  substitution s2=substitution(copy(s1.supertile),s1.inflation);
  for(int i=0; i < s1.subpatch.length; ++i)
    s2.subpatch.push(copy(s1.subpatch[i]));
  return s2;
}

// Create a new tessera mt2 from mt1 with a shallow copy of the supertile,
// prototile, and  drawtile.
tessera duplicate(tessera mt1) {
  tessera mt2=tessera(mt1.transform, mt1.supertile, mt1.prototile, mt1.drawtile, mt1.index, mt1.id, mt1.iterate);
  return mt2;
}

// Create a new substitution s2 from s1 with a shallow copy of the subpatch.
substitution duplicate(substitution s1) {
  substitution s2=substitution(s1.supertile);
  s2.subpatch=s1.subpatch;
  s2.inflation=s1.inflation;
  return s2;
}

tessera operator *(tessera mt1, tessera mt2) {
  tessera mt3=duplicate(mt2);
  mt3.transform=mt1.transform*mt2.transform;
  return mt3;
}

tessera operator *(transform T, tessera mt1) {
  tessera mt2=duplicate(mt1);
  mt2.transform=T*mt2.transform;
  return mt2;
}

tessera[] operator *(transform T, tessera[] mt1) {
  int L=mt1.length;
  tessera[] mt2=new tessera[L];
  for(int i=0; i < mt1.length; ++i)
    mt2[i]=T*mt1[i];
  return mt2;
}

struct mosaic {
  tessera[] tesserae;
  tile initialtile;
  int n=0;
  tessera[] subpatch;
  int layers;
  real inflation;

  // tilecount[k] is the number of tesserae in iteration k
  int[] tilecount;

  private void iterate(tessera T, tessera[] tesserae,
          real inflation=inflation) {
    tessera patchi;
    for(int i=0; i < subpatch.length; ++i) {
      patchi=subpatch[i];
      if(patchi.supertile == T.prototile) {
        tesserae.push(scale(inflation)*T*patchi);
      }
    }
  }

  void substitute(int n, void updatetesserae(tessera[],int)) {
    if(n > 0) {
      for(int k=0; k < n; ++k) {
        tessera[] tesserae=new tessera[];
        int sTL=this.tesserae.length;
        for(int i=0; i < sTL; ++i)
          if(this.tesserae[i].iterate)
            this.iterate(this.tesserae[i],tesserae,inflation);
          else
            tesserae.push(this.tesserae[i]);
        updatetesserae(tesserae,this.n+k+1);
        this.tesserae=tesserae;
        int tesserael=tesserae.length;
        this.tilecount.push(tesserael);
      }
      this.n+=n;
    }
  }

  void substitute(int n) {this.substitute(n, new void (tessera[],int){});}

  private void initializer(tile initialtile=nulltile, int n, void updatetesserae(tessera[],int), substitution[] rules) {
    int ind=0;
    int Lr=rules.length;
    assert(rules.length > 0,"Mosaics must have at least one substitution.");

    this.inflation=rules[0].inflation;
    substitution rulesi=rules[0];
    tessera[] rulesipatch=rulesi.subpatch;
    tessera rulesipatchj;
    for(int j=0; j < rulesipatch.length; ++j) {
      rulesipatchj=duplicate(rulesipatch[j]);
      rulesipatchj.index=ind;
      ind+=1;
      this.subpatch.push(rulesipatchj);
    }
    for(int i=1; i < Lr; ++i) {
      rulesi=rules[i];
      rulesipatch=rulesi.subpatch;
      assert(rulesi.inflation == this.inflation,"All substitutions in a mosaic must have the same inflation factor.");
      for(int j=0; j < rulesipatch.length; ++j) {
        rulesipatchj=duplicate(rulesipatch[j]);
        rulesipatchj.index=ind;
        ind+=1;
        this.subpatch.push(rulesipatchj);
      }
    }
    int Lp=this.subpatch.length;
    real deflation=1/inflation;
    tessera patchi;
    for(int i=0; i < Lp; ++i) {
      patchi=subpatch[i];
      if(patchi.prototile == nulltile) {
        patchi.prototile=this.initialtile;
      }
      if(patchi.supertile == nulltile) {
        patchi.supertile=this.initialtile;
      }
      transform Ti=subpatch[i].transform;
      patchi.transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
    }
    // If initialtile is not specified, use supertile from first specified rule.
    if(initialtile == nulltile) {
      this.initialtile=rules[0].supertile;
    } else {
      int i=0;
      while(i < Lr) {
        if(initialtile==rules[i].supertile) {
          this.initialtile=initialtile;
          break;
        }
        ++i;
      }
      assert(i < Lr, "initialtile does not match supertile in provided substitutions.");
    }
    this.tesserae.push(tessera(this.initialtile));
    this.tilecount.push(1);
    updatetesserae(this.tesserae,0);
    this.substitute(n,updatetesserae);
    this.layers=1;

  }

  void operator init(tile initialtile=nulltile, int n, void updatetesserae(tessera[],int), substitution[] rules) {
    this.initializer(initialtile, n, updatetesserae, rules);
  }

  void operator init(tile initialtile=nulltile, int n, void updatetesserae(tessera[],int) ...substitution[] rules) {
    this.initializer(initialtile, n, updatetesserae, rules);
  }

  void operator init(tile initialtile=nulltile, int n, substitution[] rules) {
    this.initializer(initialtile, n, new void (tessera[],int){}, rules);
  }

  void operator init(tile initialtile=nulltile, int n ...substitution[] rules) {
    this.initializer(initialtile, n, new void (tessera[],int){}, rules);
  }

  // Assert that layer must be valid
  private void checkLayerError(int layer) {
    assert(0 <= layer && layer < layers, "Cannot access layer "+string(layer)+" in mosaic with "+string(layers)+" layers.");
  }

  // Return transformed drawtiles of layer
  tile[] tiles(int layer=0) {
    checkLayerError(layer);
    tile[] ttiles=new tile[this.tesserae.length];
    for(int i=0; i < this.tesserae.length; ++i) {
      tessera ti=this.tesserae[i];
      ttiles[i]=ti.transform*ti.drawtile[layer];
    }
    return ttiles;
  }

  // addlayer() Adds a new layer to mosaic
  void addlayer(int n=1) {
    assert(n >= 1, "Cannot add less than 1 layer.");
    for(int i=0; i < n; ++i) {
      for(int i=0; i < subpatch.length; ++i) {
        subpatch[i].addlayer();
      }
      if(this.n == 0) tesserae[0].addlayer();
      this.layers+=1;
    }
  }

  // Return true if start tile should be decorated
  private bool decorateinitialtile(string[] id) {
    int idlength=id.length;
    if(n != 0) return false;
    if(idlength == 0) return true;
    for(int j=0; j < idlength; ++j)
      if(tesserae[0].id == id[j])
        return true;
    return false;
  }

  // Return indices of subpatch for decoration
  private int[] decorateIndices(string[] id) {
    int[] indices={};
    int idlength=id.length;
    for(int i=0; i < subpatch.length; ++i) {
      for(int j=0; j < max(idlength,1); ++j) {
        if(idlength == 0 || subpatch[i].id == id[j]) {
          indices.push(i);
          break;
        }
      }
    }
    return indices;
  }

  // Update with tile, fillpen, and drawpen
  //Update layer
  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, int layer, string[] id) {

    checkLayerError(layer);

    if(decorateinitialtile(id)) tesserae[0].updatelayer(drawtile,fillpen,drawpen,layer);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,layer);
  }

  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, int layer ...string[] id) {
    this.updatelayer(drawtile, fillpen,drawpen,layer,id);
  }

  //Update top layer
  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
     this.updatelayer(drawtile, fillpen,drawpen,layers-1,id);
  }

  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
     this.updatelayer(drawtile, fillpen,drawpen,layers-1,id);
  }

  //Update layer 0
  void update(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile, fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen... string[] id) {
    this.update(drawtile, fillpen,drawpen,id);
  }

  // Update with axial shading
  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen, int layer, string[] id) {

    checkLayerError(layer);

    if(decorateinitialtile(id)) tesserae[0].updatelayer(drawtile,fillpen,drawpen,axialpena,axiala,axialpenb,axialb,layer);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,axialpena,axiala,axialpenb,axialb,layer);
  }

  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen, int layer ...string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,fillpen,drawpen,layer,id);
  }

  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,fillpen,drawpen,layers-1,id);
  }

  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,fillpen,drawpen,layers-1,id);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.update(drawtile,axialpena,axiala,axialpenb,axialb,fillpen,drawpen,id);
  }

  // Update with radial shading
  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, int layer, string[] id) {

    checkLayerError(layer);

    if(decorateinitialtile(id)) tesserae[0].updatelayer(drawtile,fillpen,drawpen,radialpena,radiala,radialra,radialpenb,radialb,radialrb,layer);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,radialpena,radiala,radialra,radialpenb,radialb,radialrb,layer);
  }

  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, int layer ...string[] id) {
    this.updatelayer(drawtile,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,layer,id);
  }

  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,layers-1,id);
  }

  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.updatelayer(drawtile,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,layers-1,id);
  }

  void update(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
      this.updatelayer(drawtile,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
      this.update(drawtile,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,id);
  }

  // Update everything
  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb,pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, int layer, string[] id) {

    checkLayerError(layer);

    int[] indices=decorateIndices(id);
    if(decorateinitialtile(id)) tesserae[0].updatelayer(drawtile,fillpen,drawpen,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,layer);

    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,layer);
  }

  void updatelayer(tile drawtile=nulltile,pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, int layer ...string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,layer,id);
  }

  void updatelayer(tile drawtile=nulltile,pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,layers-1,id);
  }

  void updatelayer(tile drawtile=nulltile,pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,layers-1,id);
  }

  void update(tile drawtile=nulltile,pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile,pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen, pair radiala, real radialra, pen radialpenb=nullpen, pair radialb, real radialrb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.update(drawtile,axialpena,axiala,axialpenb,axialb,radialpena,radiala,radialra,radialpenb,radialb,radialrb,fillpen,drawpen,id);
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

  int Lt=M.tesserae.length;
  int Lp=M.subpatch.length;

  tile[] Msupertiles;
  tile[] Mprototiles;

  M2.subpatch.push(copy(M.subpatch[0]));
  Msupertiles.push(M.subpatch[0].supertile);
  Mprototiles.push(M.subpatch[0].prototile);

  tessera patchj;
  for(int j=1; j < Lp; ++j) {
    patchj=copy(M.subpatch[j]);
    int is=searchtile(Msupertiles, M.subpatch[j].supertile);
    if(is != -1)
      patchj.supertile=M2.subpatch[is].supertile;
    Msupertiles.push(M.subpatch[j].supertile);

    int ip=searchtile(Mprototiles, M.subpatch[j].prototile);
    if(ip != -1)
      patchj.prototile=M2.subpatch[ip].prototile;

    Mprototiles.push(M.subpatch[j].supertile);

    M2.subpatch.push(patchj);
  }

  for(int j=0; j < Lp; ++j) {
    if(M.initialtile == Msupertiles[j]); {
      M2.initialtile=M2.subpatch[j].supertile;
      break;
    }
  }

  for(int i=0; i < Lt; ++i) {
    tessera t=M.tesserae[i];
    int j=t.index;
    tessera t2=tessera(t.transform, M2.subpatch[j].supertile, M2.subpatch[j].prototile, M2.subpatch[j].drawtile, j, M2.subpatch[j].id);
    M2.tesserae.push(t2);
  }
  return M2;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=copy(M);
  M2.tesserae=T*M2.tesserae;
  return M2;
}

real inflationscaling(bool scalelinewidth, real inflation, int n) {
  return scalelinewidth ? (inflation)^(1-max(n,1)) : 1;
}

// draw tile t
void draw(picture pic=currentpicture, explicit tile t, pen p=currentpen) {
  if(t.drawpen != nullpen) draw(pic, t.path, t.drawpen);
  else  draw(pic, t.path, p);
}

// NOTE: default value of p is invisible. Not currentpen.
void fill(picture pic=currentpicture, explicit tile t, pen p=invisible) {
  if(t.fillable())
    if(t.fillpen != nullpen)
      fill(pic, t.path, t.fillpen);
    else
      fill(pic, t.path, p);
}

void filldraw(picture pic=currentpicture, explicit tile t, pen fillpen=invisible, pen drawpen=currentpen) {
  draw(pic, t, drawpen);
  fill(pic, t, fillpen);
}

void axialshade(picture pic=currentpicture, explicit tile t, bool stroke=false, bool extenda=true, bool extendb=true) {
  if(t.fillable()) axialshade(pic, t.path, stroke=stroke, extenda=extenda, extendb=extendb, t.axialpena
    ,t.axiala,t.axialpenb,t.axialb);
}

void radialshade(picture pic=currentpicture, explicit tile t, bool stroke=false, bool extenda=true, bool extendb=true) {
  if(t.fillable()) radialshade(pic, t.path, stroke=stroke, extenda=extenda, extendb=extendb, t.radialpena
    ,t.radiala,t.radialra, t.radialpenb,t.radialb,t.radialrb);
}

// Draw layer l of tessera.
void draw(picture pic=currentpicture, tessera T, pen p=currentpen, real scaling=1, int layer=0) {
  tile Tdl=T.transform*T.drawtile[layer];
  pen dpl=Tdl.drawpen;
  if(dpl != nullpen) {
    Tdl.drawpen=dpl+scaling*linewidth(dpl);
    draw(pic,Tdl);
  } else {
    draw(pic,Tdl,p+scaling*linewidth(p));
  }
}

void fill(picture pic=currentpicture, tessera T, pen p=invisible, int layer=0) {
  tile Tdl=T.drawtile[layer];
  fill(pic, T.transform*Tdl);
}

void filldraw(picture pic=currentpicture, tessera T, pen fillpen=invisible, pen drawpen=currentpen, real scaling=1, int layer=0) {
  fill(pic,T,fillpen,layer);
  draw(pic,T,drawpen,scaling,layer);
}

void axialshade(picture pic=currentpicture, tessera T, int layer=0, bool stroke=false, bool extenda=true, bool extendb=true) {
  tile Tdl=T.drawtile[layer];
  axialshade(pic, T.transform*Tdl, stroke=stroke, extenda=extenda, extendb=extendb);
}

void radialshade(picture pic=currentpicture, tessera T, int layer=0, bool stroke=false, bool extenda=true, bool extendb=true) {
  tile Tdl=T.drawtile[layer];
  radialshade(pic, T.transform*Tdl, stroke=stroke, extenda=extenda, extendb=extendb);
}

// Draw substitution. If drawoutline == true, also draw the supertile with
// outlinepen, scaled by inflation.
void draw(picture pic=currentpicture, substitution s, pen p=currentpen,
              bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.subpatch.length; ++k)
    draw(pic, s.subpatch[k], p, 1, 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void fill(picture pic=currentpicture, substitution s, pen p=invisible,
          bool drawoutline=false,
          pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.subpatch.length; ++k)
    fill(pic, s.subpatch[k], p, 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void filldraw(picture pic=currentpicture, substitution s, pen fillpen=invisible, pen drawpen=currentpen,
              bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.subpatch.length; ++k)
    filldraw(pic, s.subpatch[k], fillpen, drawpen, 1, 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void axialshade(picture pic=currentpicture, substitution s, bool stroke=false, bool extenda=true, bool extendb=true, bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5)  {
  for(int k=0; k < s.subpatch.length; ++k)
    axialshade(pic, s.subpatch[k], stroke=stroke, extenda=extenda, extendb=extendb);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void radialshade(picture pic=currentpicture, substitution s, bool stroke=false, bool extenda=true, bool extendb=true, bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5)  {
  for(int k=0; k < s.subpatch.length; ++k)
    radialshade(pic, s.subpatch[k], stroke=stroke, extenda=extenda, extendb=extendb);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

// Draw layer of mosaic.
// If scalelinewidth == true, the linewidth of the pen is scaled by the
// inflation nscale times. The default value of nscale is the number of
// iterations in the mosaic. When drawing a mosaic several times one mosaic
// multiple times (with different iterations) nscale provides a convenient way
// to use the same linewidth each time.
void draw(picture pic=currentpicture, mosaic M, int layer, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int k=0; k < M.tesserae.length; ++k)
    draw(pic, M.tesserae[k], p, scaling, layer);
}

void fill(picture pic=currentpicture, mosaic M, pen p=invisible,int layer) {
  for(int k=0; k < M.tesserae.length; ++k)
    fill(pic, M.tesserae[k], p, layer);
}

void filldraw(picture pic=currentpicture, mosaic M, int layer, pen fillpen=invisible, pen drawpen=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int k=0; k < M.tesserae.length; ++k)
    filldraw(pic, M.tesserae[k], fillpen, drawpen, scaling, layer);
}

void axialshade(picture pic=currentpicture, mosaic M, int layer, bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int k=0; k < M.tesserae.length; ++k)
    axialshade(pic, M.tesserae[k],layer,stroke,extenda,extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, int layer, bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int k=0; k < M.tesserae.length; ++k)
    radialshade(pic, M.tesserae[k],layer,stroke,extenda,extendb);
}

// Draw all layers of mosaic. Layers are drawn in increasing order.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  for(int layer=0; layer < M.layers; ++layer)
    draw(pic,M,layer,p,scalelinewidth,nscale);
}

void fill(picture pic=currentpicture, mosaic M, pen p=invisible) {
  for(int layer=0; layer < M.layers; ++layer)
    fill(pic,M,p,layer);
}

void filldraw(picture pic=currentpicture, mosaic M, pen fillpen=invisible, pen drawpen=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int layer=0; layer < M.layers; ++layer) {
    fill(pic,M,fillpen,layer);
    draw(pic,M,layer,drawpen,scalelinewidth,nscale);
  }
}

void axialshade(picture pic=currentpicture, mosaic M, bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int layer=0; layer < M.layers; ++layer)
    axialshade(pic,M,layer,stroke,extenda,extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int layer=0; layer < M.layers; ++layer)
    radialshade(pic,M,layer,stroke,extenda,extendb);
}
