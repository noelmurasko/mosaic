real inflation=1;
private real globalinflation() {return inflation;}

struct tile {
  path[] boundary;

  pen fillpen;
  pen drawpen;

  pen aspena;
  pen aspenb;
  pair aspointa;
  pair aspointb;

  pen rspena;
  pen rspenb;
  pair rspointa;
  pair rspointb;
  real rsradiusa;
  real rsradiusb;

  string id;

  private void initializer(path[] boundary, pen fillpen=nullpen, pen drawpen=nullpen, pen aspena=nullpen, pair aspointa=(0,0), pen aspenb=nullpen, pair aspointb=(0,0), pen rspena=nullpen, pair rspointa=(0,0), real rsradiusa=0, pen rspenb=nullpen, pair rspointb=(0,0),real rsradiusb=0, string id="") {
    this.boundary=boundary;

    this.fillpen=fillpen;
    this.drawpen=drawpen;

    this.aspena=aspena;
    this.aspenb=aspenb;
    this.aspointa=aspointa;
    this.aspointb=aspointb;

    this.rspena=rspena;
    this.rspenb=rspenb;
    this.rspointa=rspointa;
    this.rspointb=rspointb;
    this.rsradiusa=rsradiusa;
    this.rsradiusb=rsradiusb;

    this.id=id;
  }

  void operator init(path[] boundary={}, frame frame=newframe, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.initializer(boundary, fillpen=fillpen, drawpen=drawpen,id);
  }

  void operator init(path[] boundary={}, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.initializer(boundary, fillpen=fillpen, drawpen=drawpen, aspena=aspena, aspointa=aspointa, aspenb=aspenb, aspointb=aspointb,id);
  }

  void operator init(path[] boundary={}, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb,real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.initializer(boundary, fillpen=fillpen, drawpen=drawpen, rspena=rspena, rspointa=rspointa, rsradiusa=rsradiusa, rspenb=rspenb, rspointb=rspointb, rsradiusb=rsradiusb,id);
  }

  void operator init(path[] boundary={}, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb,real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.initializer(boundary, fillpen=fillpen, drawpen=drawpen, aspena=aspena, aspointa=aspointa, aspenb=aspenb, aspointb=aspointb, rspena=rspena, rspointa=rspointa, rsradiusa=rsradiusa, rspenb=rspenb, rspointb=rspointb, rsradiusb=rsradiusb,id);
  }

  void operator init(pair boundary, pen drawpen=nullpen,string id="") {
    this.initializer((path) boundary, drawpen=drawpen,id);
  }

  bool fillable() {
    for(int i=0; i < this.boundary.length; ++i)
      if(!cyclic(this.boundary[i])) return false;
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
  return tile(copy(t.boundary),fillpen=t.fillpen,drawpen=t.drawpen,aspena=t.aspena,aspointa=t.aspointa,aspenb=t.aspenb,aspointb=t.aspointb,rspena=t.rspena,rspointa=t.rspointa,rsradiusa=t.rsradiusa,rspenb=t.rspenb,rspointb=t.rspointb,rsradiusb=t.rsradiusb,id=t.id);
}

tile operator *(transform T, tile t1) {
  tile t2=copy(t1);
  t2.boundary=T*t1.boundary;
  t2.aspointa=T*t1.aspointa;
  t2.aspointb=T*t1.aspointb;
  t2.rspointa=T*t1.rspointa;
  t2.rspointb=T*t1.rspointb;
  return t2;
}

// Note that pens and shading settings of the new tile are the same as t1.
tile operator ^^(tile t1, tile t2) {
  tile t3=copy(t1);
  t3.boundary=t1.boundary^^t2.boundary;
  return t3;
}

// write tiles (just writes boundary)
void write(string s="", explicit tile t) {
  write(s,t.boundary);
}

tile nulltile=tile(nullpath);

//bool fillcheckable(tile drawtile, int ind=0) {
//  for(int i=0; i < drawtile.length; ++i)
//    if(!cyclic(drawtile.boundary[i])) return false;
//  return true;
//}

struct tiledata {
  transform transform;
  tile supertile;
  tile prototile;

  tile[] drawtile={};

  restricted int layers;
  string id;
  int index; // Used to determine location of tile in the mosaic subpatch

  private void initializer(transform transform, tile supertile, tile prototile,
                     tile drawtile, pen fillpen, pen drawpen, pen aspena, pair aspointa, pen aspenb, pair aspointb, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb, string id="") {
    this.transform=transform;
    this.supertile=supertile;

    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    pen fp=fillpen == nullpen ? dt.fillpen : fillpen;
    pen dp=drawpen == nullpen ? dt.drawpen : drawpen;

    this.drawtile.push(tile(dt.boundary,fillpen=fp,drawpen=dp,aspena, aspointa, aspenb, aspointb,rspena, rspointa,rsradiusa,rspenb,rspointb,rsradiusb));

    this.layers=1;
    if(length(id) == 0)
      this.id=this.prototile.id;
    else
      this.id=id;
    this.index=0;
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform,supertile,prototile,drawtile,fillpen,drawpen,dt.aspena, dt.aspointa,dt.aspenb,dt.aspointb,dt.rspena,dt.rspointa,dt.rsradiusa,dt.rspenb,dt.rspointb,dt.rsradiusb,id);
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen aspena, pair aspointa, pen aspenb, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform,supertile,prototile,drawtile,fillpen,drawpen,aspena, aspointa, aspenb, aspointb,dt.rspena,dt.rspointa,dt.rsradiusa,dt.rspenb,dt.rspointb,dt.rsradiusb,id);
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform,supertile,prototile,drawtile,fillpen,drawpen,dt.aspena, dt.aspointa, dt.aspenb, dt.aspointb, rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,id);
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile drawtile=nulltile, pen aspena, pair aspointa, pen aspenb, pair aspointb, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform,supertile,prototile,drawtile,fillpen,drawpen, aspena, aspointa, aspenb, aspointb, rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,id);
  }

  void operator init(transform transform=identity, tile supertile, tile prototile=nulltile,
                     tile[] drawtile, int index, string id="") {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    this.index=index;
    this.layers=drawtile.length;
    this.id=id == "" ? this.prototile.id : id;
  }

  void addlayer() {
    this.drawtile.push(nulltile);
    this.layers+=1;
  }

  void updatelayer(tile drawtile, int ind) {
    if(drawtile != nulltile) this.drawtile[ind]=drawtile;
  }

  void updatelayer(pen fillpen, pen drawpen, int ind) {
    if(fillpen != nullpen) this.drawtile[ind].fillpen=fillpen;
    if(drawpen != nullpen) this.drawtile[ind].drawpen=drawpen;
  }

  void updatelayer(pen aspena, pair aspointa, pen aspenb, pair aspointb, int ind) {
    if(aspena != nullpen) this.drawtile[ind].aspena=aspena;
    if(aspenb != nullpen) this.drawtile[ind].aspenb=aspenb;
    this.drawtile[ind].aspointa=aspointa;
    this.drawtile[ind].aspointb=aspointb;
  }

  void updatelayer(pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb, int ind) {
    if(rspena != nullpen) this.drawtile[ind].rspena=rspena;
    if(rspenb != nullpen) this.drawtile[ind].rspenb=rspenb;
    this.drawtile[ind].rspointa=rspointa;
    this.drawtile[ind].rspointb=rspointb;
    this.drawtile[ind].rsradiusa=rsradiusa;
    this.drawtile[ind].rsradiusb=rsradiusb;
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen,int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen,drawpen,ind);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen aspena, pair aspointa, pen aspenb, pair aspointb, int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen,drawpen,ind);
    this.updatelayer(aspena,aspointa,aspenb,aspointb,ind);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb, int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen,drawpen,ind);
    this.updatelayer(rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,ind);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen aspena, pair aspointa, pen aspenb, pair aspointb, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb, int ind) {
    this.updatelayer(drawtile,ind);
    this.updatelayer(fillpen,drawpen,ind);
    this.updatelayer(aspena,aspointa,aspenb,aspointb,ind);
    this.updatelayer(rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,ind);
  }
}

struct substitution {
  tile supertile;
  tiledata[] subpatch;
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
    tiledata m;
    m=tiledata(transform,this.supertile,prototile,drawtile,fillpen,drawpen,id);
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
                      pen aspena, pair aspointa, pen aspenb, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    tiledata m;
    m=tiledata(transform,this.supertile,prototile,drawtile,aspena,aspointa,aspenb,aspointb,fillpen,drawpen,id);
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    tiledata m;
    m=tiledata(transform,this.supertile,prototile,drawtile,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,id);
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile, pen aspena, pair aspointa, pen aspenb, pair aspointb, pen rspena, pair rspointa, real rsradiusa, pen rspenb, pair rspointb, real rsradiusb,
                     pen fillpen=nullpen, pen drawpen=nullpen, string id="") {
    tiledata m;
    m=tiledata(transform,this.supertile,prototile,drawtile,aspena,aspointa,aspenb,aspointb,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,id);
    this.subpatch.push(m);
  }
}

// Create a deep copy of the tiledata mt.
tiledata copy(tiledata mt) {
  int L=mt.drawtile.length;
  tile[] dtcopy=new tile[L];
  for(int i; i < L; ++i)
    dtcopy[i]=copy(mt.drawtile[i]);
  // If supertile and prototile are the same, make only one copy
  if(mt.supertile == mt.prototile) {
    tile super2=copy(mt.supertile);
    return tiledata(mt.transform, super2, super2, dtcopy, mt.index, mt.id);
  } else
    return tiledata(mt.transform, copy(mt.supertile), copy(mt.prototile), dtcopy,
      mt.index, mt.id);
}

// Create a deep copy of the substitution s1.
substitution copy(substitution s1) {
  substitution s2=substitution(copy(s1.supertile),s1.inflation);
  for(int i=0; i < s1.subpatch.length; ++i)
    s2.subpatch.push(copy(s1.subpatch[i]));
  return s2;
}

// Create a new tiledata mt2 from mt1 with a shallow copy of the supertile,
// prototile, and  drawtile.
tiledata duplicate(tiledata mt1) {
  tiledata mt2=tiledata(mt1.transform, mt1.supertile, mt1.prototile, mt1.drawtile, mt1.index, mt1.id);
  return mt2;
}

// Create a new substitution s2 from s1 with a shallow copy of the subpatch.
substitution duplicate(substitution s1) {
  substitution s2=substitution(s1.supertile);
  s2.subpatch=s1.subpatch;
  s2.inflation=s1.inflation;
  return s2;
}

tiledata operator *(tiledata mt1, tiledata mt2) {
  tiledata mt3=duplicate(mt2);
  mt3.transform=mt1.transform*mt2.transform;
  return mt3;
}

tiledata operator *(transform T, tiledata mt1) {
  tiledata mt2=duplicate(mt1);
  mt2.transform=T*mt2.transform;
  return mt2;
}

tiledata[] operator *(transform T, tiledata[] mt1) {
  int L=mt1.length;
  tiledata[] mt2=new tiledata[L];
  for(int i=0; i < mt1.length; ++i)
    mt2[i]=T*mt1[i];
  return mt2;
}

struct mosaic {
  tiledata[] tiles;
  tile starttile;
  int n=0;
  tiledata[] subpatch;
  int layers;
  real inflation;

  // tilecount[k] is the number of tiles in iteration k
  int[] tilecount;

  // addlayer() Adds a new layer to mosaic

  private void iterate(tiledata T, tiledata[] tiles,
          real inflation=inflation) {
    tiledata patchi;
    for(int i=0; i < subpatch.length; ++i) {
      patchi=subpatch[i];
      if(patchi.supertile == T.prototile) {
        tiles.push(T*patchi);
      }
    }
  }

  void substitute(int n) {
    if(n > 0) {
      for(int k=0; k < n; ++k) {
        tiledata[] tiles=new tiledata[];
        int sTL=this.tiles.length;
        if(sTL == 0) {
          this.tilecount.push(1);
          this.iterate(tiledata(this.starttile),tiles,inflation);
        }
        else {
          for(int i=0; i < sTL; ++i)
            this.iterate(this.tiles[i],tiles,inflation);
        }
        this.tiles=tiles;
        int tilesl=tiles.length;
        this.tilecount.push(tilesl);
      }
      for(int i=0; i < this.tiles.length; ++i)
        this.tiles[i]=scale(inflation^n)*this.tiles[i];
      this.n+=n;
    } else {
      if(this.tiles.length == 0) this.tiles.push(tiledata(this.starttile));
    }
  }

  void operator init(tile starttile=nulltile, int n ...substitution[] rules) {
    int ind=0;
    int Lr=rules.length;
    assert(rules.length > 0,"Mosaics must have at least one substitution.");

    this.inflation=rules[0].inflation;
    substitution rulesi=rules[0];
    tiledata[] rulesipatch=rulesi.subpatch;
    tiledata rulesipatchj;
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
    tiledata patchi;
    for(int i=0; i < Lp; ++i) {
      patchi=subpatch[i];
      if(patchi.prototile == nulltile) {
        patchi.prototile=this.starttile;
      }
      if(patchi.supertile == nulltile) {
        patchi.supertile=this.starttile;
      }
      transform Ti=subpatch[i].transform;
      patchi.transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*scale(deflation);
    }
    // If starttile is not specified, use supertile from first specified rule.
    if(starttile == nulltile) {
      this.starttile=rules[0].supertile;
    } else {
      for(int i=0; i < Lr; ++i) {
        if(starttile==rules[i].supertile) {
          this.starttile=starttile;
          break;
        }
      assert(i < Lr, "starttile does not match supertile in provided substitutions.");
      }
    }
    this.substitute(n);
    this.layers=1;
  }

  void addlayer() {
    for(int i=0; i < subpatch.length; ++i) {
      subpatch[i].addlayer();
    }
    if(n == 0) tiles[0].addlayer();
    this.layers+=1;
  }

  // Return true if start tile should be decorated
  private bool decorateStartTile(string[] id) {
    int idlength=id.length;
    if(n != 0) return false;
    if(idlength == 0) return true;
    for(int j=0; j < idlength; ++j)
      if(tiles[0].id == id[j])
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
  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string[] id) {

    int ind=layer < 0 ? layers-1 : layer;

    if(decorateStartTile(id)) tiles[0].updatelayer(drawtile,fillpen,drawpen,ind);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,ind);
  }

  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1 ...string[] id) {
    this.updatelayer(drawtile, fillpen,drawpen,layer,id);
  }


  void update(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile, fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen... string[] id) {
    this.update(drawtile, fillpen,drawpen,id);
  }

  // Update with axial shading
  void updatelayer(tile drawtile=nulltile, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string[] id) {

    int ind=layer < 0 ? layers-1 : layer;

    if(decorateStartTile(id)) tiles[0].updatelayer(drawtile,fillpen,drawpen,aspena,aspointa,aspenb,aspointb,ind);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,aspena,aspointa,aspenb,aspointb,ind);
  }

  void updatelayer(tile drawtile=nulltile, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1 ...string[] id) {
    this.updatelayer(drawtile,aspena,aspointa,aspenb,aspointb,fillpen,drawpen,layer,id);
  }

  void update(tile drawtile=nulltile, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile,aspena,aspointa,aspenb,aspointb,fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.update(drawtile,aspena,aspointa,aspenb,aspointb,fillpen,drawpen,id);
  }

  // Update with radial shading
  void updatelayer(tile drawtile=nulltile, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string[] id) {

    int ind=layer < 0 ? layers-1 : layer;

    if(decorateStartTile(id)) tiles[0].updatelayer(drawtile,fillpen,drawpen,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,ind);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,ind);
  }

  void updatelayer(tile drawtile=nulltile, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1 ...string[] id) {
    this.updatelayer(drawtile,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,layer,id);
  }

  void update(tile drawtile=nulltile, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
      this.updatelayer(drawtile,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
      this.update(drawtile,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,id);
  }

  // Update everything
  void updatelayer(tile drawtile=nulltile, pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb,pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1, string[] id) {

    int ind=layer < 0 ? layers-1 : layer;

    int[] indices=decorateIndices(id);
    if(decorateStartTile(id)) tiles[0].updatelayer(drawtile,fillpen,drawpen,aspena,aspointa,aspenb,aspointb,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,ind);

    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile,fillpen,drawpen,aspena,aspointa,aspenb,aspointb,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,ind);
  }

  void updatelayer(tile drawtile=nulltile,pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, int layer=-1 ...string[] id) {
    this.updatelayer(drawtile,aspena,aspointa,aspenb,aspointb,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,layer,id);
  }

  void update(tile drawtile=nulltile,pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen, string[] id) {
    this.updatelayer(drawtile,aspena,aspointa,aspenb,aspointb,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,0,id);
  }

  void update(tile drawtile=nulltile,pen aspena=nullpen, pair aspointa, pen aspenb=nullpen, pair aspointb, pen rspena=nullpen, pair rspointa, real rsradiusa, pen rspenb=nullpen, pair rspointb, real rsradiusb, pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    this.update(drawtile,aspena,aspointa,aspenb,aspointb,rspena,rspointa,rsradiusa,rspenb,rspointb,rsradiusb,fillpen,drawpen,id);
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
  int Lp=M.subpatch.length;

  tile[] Msupertiles;
  tile[] Mprototiles;

  M2.subpatch.push(copy(M.subpatch[0]));
  Msupertiles.push(M.subpatch[0].supertile);
  Mprototiles.push(M.subpatch[0].prototile);

  tiledata patchj;
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
    if(M.starttile == Msupertiles[j]); {
      M2.starttile=M2.subpatch[j].supertile;
      break;
    }
  }

  for(int i=0; i < Lt; ++i) {
    tiledata t=M.tiles[i];
    int j=t.index;
    tiledata t2=tiledata(t.transform, M2.subpatch[j].supertile, M2.subpatch[j].prototile, M2.subpatch[j].drawtile, j, M2.subpatch[j].id);
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
  if(t.fillable()) fill(pic, t.boundary, t.fillpen);
}

void filldraw(picture pic=currentpicture, explicit tile t, pen p=currentpen) {
  draw(pic, t.boundary, p);
  fill(pic, t.boundary, t.fillpen);
}

void axialshade(picture pic=currentpicture, explicit tile t, bool stroke=false, bool extenda=true, bool extendb=true) {
  if(t.fillable()) axialshade(pic, t.boundary, stroke=stroke, extenda=extenda, extendb=extendb, t.aspena
    ,t.aspointa,t.aspenb,t.aspointb);
}

void radialshade(picture pic=currentpicture, explicit tile t, bool stroke=false, bool extenda=true, bool extendb=true) {
  if(t.fillable()) radialshade(pic, t.boundary, stroke=stroke, extenda=extenda, extendb=extendb, t.rspena
    ,t.rspointa,t.rsradiusa, t.rspenb,t.rspointb,t.rsradiusb);
}

// Draw layer l of tiledata.
void draw(picture pic=currentpicture, tiledata T, pen p=currentpen, real scaling=1, int layer=0) {
  tile Tdl=T.transform*T.drawtile[layer];
  pen dpl=Tdl.drawpen;
  if(dpl != nullpen) {
    Tdl.drawpen=dpl+scaling*linewidth(dpl);
    draw(pic,Tdl);
  } else {
    draw(pic,Tdl,p+scaling*linewidth(p));
  }
}

void fill(picture pic=currentpicture, tiledata T, int layer=0) {
  tile Tdl=T.drawtile[layer];
  fill(pic, T.transform*Tdl);
}

void filldraw(picture pic=currentpicture, tiledata T, pen p=currentpen, real scaling=1, int layer=0) {
  fill(pic,T,layer);
  draw(pic,T,p,scaling,layer);
}

void axialshade(picture pic=currentpicture, tiledata T, int layer=0, bool stroke=false, bool extenda=true, bool extendb=true) {
  tile Tdl=T.drawtile[layer];
  axialshade(pic, T.transform*Tdl, stroke=stroke, extenda=extenda, extendb=extendb);
}

void radialshade(picture pic=currentpicture, tiledata T, int layer=0, bool stroke=false, bool extenda=true, bool extendb=true) {
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

void fill(picture pic=currentpicture, substitution s,
          bool drawoutline=false,
          pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.subpatch.length; ++k)
    fill(pic, s.subpatch[k], 0);
  if(drawoutline)
    draw(pic, scale(s.inflation)*s.supertile, outlinepen);
}

void filldraw(picture pic=currentpicture, substitution s, pen p=currentpen,
              bool drawoutline=false,
              pen outlinepen=linetype(new real[] {4,2})+1.5) {
  for(int k=0; k < s.subpatch.length; ++k)
    filldraw(pic, s.subpatch[k], p, 1, 0);
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

void axialshade(picture pic=currentpicture, mosaic M, int layer, bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int k=0; k < M.tiles.length; ++k)
    axialshade(pic, M.tiles[k],layer,stroke,extenda,extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, int layer, bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int k=0; k < M.tiles.length; ++k)
    radialshade(pic, M.tiles[k],layer,stroke,extenda,extendb);
}

// Draw all layers of mosaic. Layers are drawn in increasing order.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  for(int layer=0; layer < M.layers; ++layer)
    draw(pic,M,layer,p,scalelinewidth,nscale);
}

void fill(picture pic=currentpicture, mosaic M) {
  for(int layer=0; layer < M.layers; ++layer)
    fill(pic,M,layer);
}

void filldraw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth,M.inflation,nscale);
  for(int layer=0; layer < M.layers; ++layer) {
    fill(pic,M,layer);
    draw(pic,M,layer,p,scalelinewidth,nscale);
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
