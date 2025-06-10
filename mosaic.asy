// mosaic.asy
// A module for creating and visulaizing substitution tilings.
// Authors: Noel Murasko and Emily Rose Korfanty

// Global inflation factor
real inflation=1;
private real globalinflation() {return inflation;}

// Default pen for drawing outlines of substitution.
pen boundarypen=linetype(new real[] {4,2})+1.5;

// Return an array of all distinct strings in A and B
private string[] stringunion(string[] A, string[] B) {
  int Alen=A.length;
  int Blen=B.length;
  string[] AB;
  string[] C;
  if(Alen == 0) {
    if(Blen == 0) return new string[] {};
    AB=new string[] {B[0]};
    C=B[1:];
  } else {
    AB=new string[] {A[0]};
    C=concat(A[1:],B);
  }
  for(string next : C) {
    bool pushnext=true;
    for(string prev : AB) {
      if(prev == next) {
        pushnext=false;
        break;
      }
    }
    if(pushnext) AB.push(next);
  }
  return AB;
}

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

  restricted string[] tag;

  private void initializer(path[] path, pen fillpen=nullpen,
                           pen drawpen=nullpen, pen axialpena=nullpen,
                           pair axiala=(0,0), pen axialpenb=nullpen,
                           pair axialb=(0,0), pen radialpena=nullpen,
                           pair radiala=(0,0), real radialra=0,
                           pen radialpenb=nullpen, pair radialb=(0,0),
                           real radialrb=0, string[] tag) {
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

    this.tag=stringunion(new string[0],tag);
  }

  void operator init(path[] path={}, pen fillpen=nullpen, pen drawpen=nullpen
                     ...string[] tag) {
    this.initializer(path, fillpen, drawpen, tag);
  }

  void operator init(path[] path={}, pen axialpena=nullpen, pair axiala,
                     pen axialpenb=nullpen, pair axialb ...string[] tag) {
    this.initializer(path, fillpen, drawpen, axialpena=axialpena, axiala=axiala,
                     axialpenb=axialpenb, axialb=axialb, tag);
  }

  void operator init(path[] path={}, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb ...string[] tag) {
    this.initializer(path, fillpen, drawpen, radialpena=radialpena,
                     radiala=radiala, radialra=radialra, radialpenb=radialpenb,
                     radialb=radialb, radialrb=radialrb, tag);
  }

  void operator init(path[] path={}, pen fillpen=nullpen, pen drawpen=nullpen,
                     pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen,
                     pair axialb, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb ...string[] tag) {
    this.initializer(path, fillpen, drawpen, axialpena=axialpena, axiala=axiala,
                     axialpenb=axialpenb, axialb=axialb, radialpena=radialpena,
                     radiala=radiala, radialra=radialra, radialpenb=radialpenb,
                     radialb=radialb, radialrb=radialrb, tag);
  }

  void operator init(pair path, pen fillpen=nullpen, pen drawpen=nullpen
                     ...string[] tag) {
    this.initializer(new path[] {path}, fillpen=fillpen, drawpen=drawpen, tag);
  }

  void operator init(pair path, pen axialpena=nullpen, pair axiala,
                     pen axialpenb=nullpen, pair axialb ...string[] tag) {
    this.initializer(new path[] {path}, fillpen, drawpen, axialpena=axialpena,
                     axiala=axiala, axialpenb=axialpenb, axialb=axialb, tag);
  }

  void operator init(pair path, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb ...string[] tag) {
    this.initializer(new path[] {path}, fillpen, drawpen, radialpena=radialpena,
                     radiala=radiala, radialra=radialra, radialpenb=radialpenb,
                     radialb=radialb, radialrb=radialrb, tag);
  }

  void operator init(pair path, pen fillpen=nullpen, pen drawpen=nullpen,
                     pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen,
                     pair axialb, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb ...string[] tag) {
    this.initializer(new path[] {path}, fillpen, drawpen, axialpena=axialpena,
                     axiala=axiala, axialpenb=axialpenb, axialb=axialb,
                     radialpena=radialpena, radiala=radiala, radialra=radialra,
                     radialpenb=radialpenb, radialb=radialb, radialrb=radialrb,
                     tag);
  }

  bool fillable() {
    for(int i=0; i < this.path.length; ++i)
      if(!cyclic(this.path[i])) return false;
    return true;
  }

  void addtag(...string[] tag) {
    this.tag=stringunion(this.tag, tag);
  }

  void deletetag(int i, int j=i) {
    this.tag.delete(i,j);
  }

  void deletetag() {
    this.tag.delete();
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
              t.radialpenb, t.radialb, t.radialrb ...copy(t.tag));
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

// Note that pens and shading settings of the new tile are the same as t2.
tile operator ^^(tile t1, tile t2) {
  tile t3=copy(t2);
  t3.path=t1.path^^t2.path;
  return t3;
}

restricted tile nulltile=tile(nullpath);

// Searches an array of tiles ts for tile t. If ts contains t,
// return the first index of ts cooresponding to t. If ts does
// not contain t, return -1.
private int searchtile(tile[] ts, tile t) {
  for(int i=0; i < ts.length; ++i)
    if(ts[i] == t)
      return i;
  return -1;
}

struct tessera {
  transform transform;
  tile supertile;
  tile prototile;
  tile[] drawtile={};

  restricted int layers;
  string[] tag;
  int ruleindex;
  int tessindex;
  int iterindex;
  bool iterate;

  private void initializer(transform transform, tile supertile, tile prototile,
                           tile drawtile, pen fillpen, pen drawpen,
                           pen axialpena, pair axiala, pen axialpenb,
                           pair axialb, pen radialpena, pair radiala,
                           real radialra, pen radialpenb, pair radialb,
                           real radialrb, bool iterate=true, string[] tag) {
    this.transform=transform;
    this.supertile=supertile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;

    pen fp=fillpen == nullpen ? dt.fillpen : fillpen;
    pen dp=drawpen == nullpen ? dt.drawpen : drawpen;

    this.drawtile.push(tile(dt.path, fp, dp, axialpena, axiala,
                       axialpenb, axialb, radialpena, radiala, radialra,
                       radialpenb, radialb, radialrb));

    this.layers=1;
    this.tag=stringunion(this.prototile.tag, tag);
    this.ruleindex=-1;
    this.tessindex=-1;
    this.iterindex=-1;
    this.iterate=iterate;
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen,
                     bool iterate=true ...string[] tag) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, dt.axialpena, dt.axiala, dt.axialpenb, dt.axialb,
                     dt.radialpena, dt.radiala, dt.radialra, dt.radialpenb,
                     dt.radialb, dt.radialrb, iterate, tag);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen axialpena, pair axiala, pen axialpenb, pair axialb,
                     bool iterate=true ...string[] tag) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, nullpen,
                     nullpen, axialpena, axiala, axialpenb, axialb,
                     dt.radialpena, dt.radiala, dt.radialra, dt.radialpenb,
                     dt.radialb, dt.radialrb, iterate, tag);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen radialpena, pair radiala, real radialra,
                     pen radialpenb, pair radialb, real radialrb,
                     bool iterate=true ...string[] tag) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, nullpen,
                     nullpen, dt.axialpena, dt.axiala, dt.axialpenb, dt.axialb,
                     radialpena, radiala, radialra, radialpenb, radialb,
                     radialrb, iterate, tag);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, pen axialpena,
                     pair axiala, pen axialpenb, pair axialb, pen radialpena,
                     pair radiala, real radialra, pen radialpenb, pair radialb,
                     real radialrb, bool iterate=true ...string[] tag) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, axialpena, axiala, axialpenb, axialb, radialpena,
                     radiala, radialra, radialpenb, radialb, radialrb, iterate,
                     tag);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile[] drawtile, int ruleindex,
                     int tessindex, int iterindex, bool iterate=true
                     ...string[] tag) {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    this.ruleindex=ruleindex;
    this.tessindex=tessindex;
    this.iterindex=iterindex;
    this.layers=drawtile.length;

    this.tag=stringunion(this.prototile.tag,tag);
    this.iterate=iterate;
  }

  void addlayer() {
    this.drawtile.push(tile());
    this.layers+=1;
  }

  void updatelayer(tile drawtile, int layer) {
    if(drawtile != nulltile) this.drawtile[layer]=copy(drawtile);
  }

  void updatelayer(pen fillpen, pen drawpen, int layer) {
    if(fillpen != nullpen) this.drawtile[layer].fillpen=fillpen;
    if(drawpen != nullpen) this.drawtile[layer].drawpen=drawpen;
  }

  void updatelayer(pen axialpena, pair axiala, pen axialpenb, pair axialb,
                   int layer) {
    if(axialpena != nullpen) this.drawtile[layer].axialpena=axialpena;
    if(axialpenb != nullpen) this.drawtile[layer].axialpenb=axialpenb;
    this.drawtile[layer].axiala=axiala;
    this.drawtile[layer].axialb=axialb;
  }

  void updatelayer(pen radialpena, pair radiala, real radialra, pen radialpenb,
                   pair radialb, real radialrb, int layer) {
    if(radialpena != nullpen) this.drawtile[layer].radialpena=radialpena;
    if(radialpenb != nullpen) this.drawtile[layer].radialpenb=radialpenb;
    this.drawtile[layer].radiala=radiala;
    this.drawtile[layer].radialb=radialb;
    this.drawtile[layer].radialra=radialra;
    this.drawtile[layer].radialrb=radialrb;
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, int layer) {
    this.updatelayer(drawtile, layer);
    this.updatelayer(fillpen, drawpen, layer);
  }

  void updatelayer(tile drawtile, pen axialpena, pair axiala, pen axialpenb,
                   pair axialb, int layer) {
    this.updatelayer(drawtile, layer);
    this.updatelayer(axialpena, axiala, axialpenb, axialb, layer);
  }

  void updatelayer(tile drawtile, pen radialpena, pair radiala, real radialra,
                   pen radialpenb, pair radialb, real radialrb, int layer) {
    this.updatelayer(drawtile, layer);
    this.updatelayer(radialpena, radiala, radialra, radialpenb, radialb,
                     radialrb, layer);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen axialpena,
                   pair axiala, pen axialpenb, pair axialb, pen radialpena,
                   pair radiala, real radialra, pen radialpenb, pair radialb,
                   real radialrb, int layer) {
    this.updatelayer(drawtile, layer);
    this.updatelayer(fillpen, drawpen, layer);
    this.updatelayer(axialpena, axiala, axialpenb, axialb, layer);
    this.updatelayer(radialpena, radiala, radialra, radialpenb, radialb,
                     radialrb, layer);
  }

  void addtag(...string[] tag) {
    this.tag=stringunion(this.tag, tag);
  }

  void deletetag(int i, int j=i) {
    this.tag.delete(i,j);
  }

  void deletetag() {
    this.tag.delete();
  }
}

// Create a deep copy of the tessera t.
tessera copy(tessera t) {
  int L=t.drawtile.length;
  tile[] dtcopy;
  for(tile dt : t.drawtile)
    dtcopy.push(copy(dt));
  // If supertile and prototile are the same, make only one copy
  if(t.supertile == t.prototile) {
    tile super2=copy(t.supertile);
    return tessera(t.transform, super2, super2, dtcopy, t.ruleindex,
                   t.tessindex, t.iterindex, t.iterate ...t.tag);
  } else
    return tessera(t.transform, copy(t.supertile), copy(t.prototile), dtcopy,
                   t.ruleindex, t.tessindex, t.iterindex, t.iterate
                   ...copy(t.tag));
}

// Create a new tessera t2 from t1 with a shallow copy of the supertile,
// prototile, and  drawtile.
tessera duplicate(tessera t1) {
  tessera t2=tessera(t1.transform, t1.supertile, t1.prototile, t1.drawtile,
                     t1.ruleindex, t1.tessindex, t1.iterindex, t1.iterate
                     ...copy(t1.tag));
  return t2;
}

// Important: Mulitplying a t1 and t2 results in
// tessera t3 with t3.transform=t1.transform*t2.transform.
// The supertile, prototile, and drawtile of t3 are shallow
// copies of t2.
tessera operator *(tessera t1, tessera t2) {
  tessera t3=duplicate(t2);
  t3.transform=t1.transform*t2.transform;
  return t3;
}

// Important: Mulitplying a tessera by a transform does not result
// in a deep copy of the supertile, prototile, and drawtile.
tessera operator *(transform T, tessera t1) {
  tessera t2=duplicate(t1);
  t2.transform=T*t2.transform;
  return t2;
}

tessera operator *(tessera t1, transform T) {
  tessera t2=duplicate(t1);
  t2.transform=t2.transform*T;
  return t2;
}

struct substitution {
  tile supertile;
  tessera[] tesserae;
  real inflation;
  string[] tag;

  void operator init(explicit tile supertile ...string[] tag) {
    this.supertile=supertile;
    this.inflation=globalinflation();
    assert(this.inflation > 0, "Cannot set inflation to "+string(this.inflation)
           +". Inflation factor must be a strictly positive number.");
    this.tag=tag;
  }

  void operator init(explicit tile supertile, real inflation) {
    this.supertile=supertile;
    this.inflation=inflation;
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               explicit tile drawtile=nulltile, pen fillpen=nullpen,
               pen drawpen=nullpen ...string[] tag) {
    tessera t=tessera(transform, this.supertile, prototile, drawtile, fillpen,
                      drawpen ...stringunion(this.tag,tag));
    t.tessindex=tesserae.length;
    this.tesserae.push(t);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               explicit tile drawtile=nulltile, pen axialpena, pair axiala,
               pen axialpenb, pair axialb ...string[] tag) {
    tessera t=tessera(transform, this.supertile, prototile, drawtile, axialpena,
                      axiala, axialpenb, axialb ...stringunion(this.tag,tag));
    t.tessindex=tesserae.length;
    this.tesserae.push(t);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               explicit tile drawtile=nulltile, pen radialpena, pair radiala,
               real radialra, pen radialpenb, pair radialb, real radialrb
               ...string[] tag) {
    tessera t=tessera(transform, this.supertile, prototile, drawtile,
                      radialpena, radiala, radialra, radialpenb, radialb,
                      radialrb ...stringunion(this.tag,tag));
    t.tessindex=tesserae.length;
    this.tesserae.push(t);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               explicit tile drawtile=nulltile, pen axialpena, pair axiala,
               pen axialpenb, pair axialb, pen radialpena, pair radiala,
               real radialra, pen radialpenb, pair radialb, real radialrb,
               pen fillpen=nullpen, pen drawpen=nullpen ...string[] tag) {
    tessera t=tessera(transform, this.supertile, prototile, drawtile, fillpen,
                      drawpen, axialpena, axiala, axialpenb, axialb, radialpena,
                      radiala, radialra, radialpenb, radialb, radialrb
                      ...stringunion(this.tag,tag));
    t.tessindex=tesserae.length;
    this.tesserae.push(t);
  }

  // Update supertile in all tessera in tesserae
  void updatesupertile(tile supertile) {
    for(tessera t : tesserae)
        t.supertile=supertile;
  }

  void set_ruleindex(int i) {
    for(tessera t : tesserae)
      t.ruleindex=i;
  }
}


// Create a new substitution s2 from s1 with a shallow copy of the tesserae.
substitution duplicate(substitution s1) {
  substitution s2=substitution(s1.supertile);
  for(tessera t : s1.tesserae)
    s2.tesserae.push(duplicate(t));
  s2.inflation=s1.inflation;
  return s2;
}

private substitution[] rulecopy(substitution[] rules) {
  substitution[] rules_copy;

  tile[] knowntiles;
  tile[] knowntiles_copy;

  for(substitution rule : rules) {
    knowntiles.push(rule.supertile);
    knowntiles_copy.push(copy(rule.supertile));
  }

  int[] sup_index=sequence(knowntiles.length);
  int[] pro_index;

  for(substitution rule : rules) {
    for(tessera t : rule.tesserae) {
      if(t.iterindex != -1) {
        // If this tessera already corresponds to a known supertile,
        // we can use that.
        pro_index.push(t.iterindex);
      } else {
        // This case occurs during initialization or if a prototile doesn't
        // have it's own rule.
        int kp=searchtile(knowntiles,t.prototile);
        if(kp == -1) {
          knowntiles.push(t.prototile);
          knowntiles_copy.push(copy(t.prototile));
          pro_index.push(knowntiles.length-1);
        } else {
          pro_index.push(kp);
        }
      }
    }
  }

  int L=0;
  for(int i=0; i < rules.length; ++i) {
    substitution rulei=rules[i];
    substitution rulei_copy=substitution(knowntiles_copy[sup_index[i]],
                                         rulei.inflation);
    for(int j=0; j < rulei.tesserae.length; ++j) {
      tessera tj=copy(rulei.tesserae[j]);
      tj.supertile=knowntiles_copy[sup_index[i]];
      tj.prototile=knowntiles_copy[pro_index[L+j]];
      for(int k=0; k < rulei.tesserae[j].drawtile.length; ++k) {
        // We copy all drawtiles as they don't affect the substitution rules
        tj.drawtile[k]=copy(rulei.tesserae[j].drawtile[k]);
      }
      rulei_copy.tesserae.push(tj);
    }
    L=L+rules[i].tesserae.length;
    rules_copy.push(rulei_copy);
  }
  return rules_copy;
}

// Copy a mosaic tessera to a new new mosaic with new rules.
// Used by the copy(mosaic) function.
private tessera[] copy_mosaic_tesserae(tessera[] tesserae,
                                       substitution[] rules) {
  tessera[] tesserae_copy;
  if(tesserae.length > 1) {
    for(tessera t : tesserae) {
      int i=t.ruleindex;
      int j=t.tessindex;

      tessera t2=tessera(t.transform, rules[i].supertile,
                         rules[i].tesserae[j].prototile,
                         rules[i].tesserae[j].drawtile,
                         rules[i].tesserae[j].ruleindex,
                         rules[i].tesserae[j].tessindex,
                         rules[i].tesserae[j].iterindex, t.iterate
                         ...copy(rules[i].tesserae[j].tag));
      tesserae_copy.push(t2);
    }
  } else {
    tessera t=tesserae[0];
    tessera t2=tessera(t.transform, rules[0].supertile,
                         rules[0].supertile, new tile[] {rules[0].supertile},
                         0, 0, 0, t.iterate ...copy(t.tag));
    tesserae_copy.push(t2);
  }
  return tesserae_copy;
}


// mosaic | Substitution tiling created from substiution rules. Contains the
// following attributes
//
// tessera[] tesserae; | collection of tessera that make up the mosaic.
//
// substituion[] rules; | array of substituion rules for mosaic.
//
// tile initialtile;| Initial tile for mosiac. Always the first supertile of the
// first rule passed in initialization.
//
// int n; | total number of substitutions performed
//
// tessera[] tesserae; | Collection of tessera that define the substitution
// rules
//
// int layers=1; | Number of drawing layers in mosaic
//
// real inflation; | inflation factor for mosaic
//
// int[] tilecount; | int tilecount[k] is the number of tesserae in iteration k
struct mosaic {
  restricted tessera[] tesserae;
  restricted tile initialtile;
  restricted int n;
  restricted substitution[] rules;
  restricted int layers=1;
  restricted real inflation;
  restricted int[] tilecount;

  // Perform an iteration of a tessera t, and push the result onto the array
  // tesserae.
  private void iterate(tessera t, tessera[] tesserae) {
    tessera rescaled_t=scale(inflation)*t*scale(1/inflation);
    for(tessera rule_t : rules[t.iterindex].tesserae)
      tesserae.push(rescaled_t*rule_t);
  }

  // Apply substituion rules in the mosaic n times times (for a total of
  // this.n+n subsitutions). After each iteration, call the function
  // updatetesserae(tesseare, k), where tesserae is an array of tessera in the
  // mosaic after k total iterations. Add m to this.n.
  void substitute(int n, void updatetesserae(tessera[], int)) {
    for(int k=0; k < n; ++k) {
      tessera[] tesserae;
      for(tessera t : this.tesserae)
        if(t.iterate)
          this.iterate(t, tesserae);
        else
          tesserae.push(scale(inflation)*t);
      updatetesserae(tesserae, this.n+k+1);
      this.tesserae=tesserae;
      this.tilecount.push(tesserae.length);
    }
    this.n+=n;
  }

  // A version of subsitute without the updatetesserae function.
  void substitute(int n) {this.substitute(n, new void (tessera[], int){});}

  private void checkRulesError(substitution[] rules) {
    assert(rules.length > 0,"Mosaics must have at least one substitution.");
    tile[] supertiles={rules[0].supertile};
    real inflation=rules[0].inflation;
    for(int i=1; i < rules.length; ++i) {
      assert(rules[i].inflation == inflation,"All substitutions in a mosaic
             must have the same inflation factor.");
      int k=searchtile(supertiles, rules[i].supertile);
      assert(k == -1, "Each substitution must correspond to a unique supertile:
             supertile for substitution "+string(k)+" and substitution "+
             string(i)+" have same supertile.");
      supertiles.push(rules[i].supertile);
    }
  }

  // Sets the ruleindex and iterindex in this.rules
  // If prototile doesn't correspond to supertile, set iterate=0.
  private void set_index() {
    for(int i=0; i < this.rules.length; ++i)
      this.rules[i].set_ruleindex(i);

    tile[] supertiles;
    for(substitution rule : rules)
      supertiles.push(rule.supertile);

    for(substitution rule : rules) {
      for(tessera t : rule.tesserae) {
        int k=searchtile(supertiles, t.prototile);
        if(k == -1) {
          t.iterate=false;
        } else {
          t.iterindex=k;
        }
      }
    }
  }

  // Intialize tesserae in mosaic with initialtile (n=0).
  private void intialize_tesserae(void updatetesserae(tessera[], int)) {
    this.tesserae.push(tessera(this.initialtile));
    this.tesserae[0].iterindex=0;
    this.tilecount.push(1);
    updatetesserae(this.tesserae,0);
  }

  // Common inititalization code.
  // Mosaics are initialized with the supertile from the first specified rule.
  // Starting forom this initial tile, n substitution iterations are performed
  // using the provided rules. If initialtile isn't specified or is equal to
  // nulltile, then
  // Advanced users may also provide a function updatetesserae(). After the
  // kth substitution (where k=0,...n), updatetesserae(this.tesserae, k) is
  // called where this.tesserae is the array of tesserae after k substitutions
  // have been applied. In regular usage, updatetesserae() does nothing.
  private void initializer(int n, void updatetesserae(tessera[], int),
                           substitution[] rules) {
    this.checkRulesError(rules);
    this.rules=rulecopy(rules);

    this.inflation=this.rules[0].inflation;
    this.initialtile=this.rules[0].supertile;

    this.set_index();

    this.intialize_tesserae(updatetesserae);
    this.substitute(n,updatetesserae);
  }

  // Initialization of mosaic using a updatetesserae function.
  void operator init(int n=0, void updatetesserae(tessera[], int)
                     ...substitution[] rules) {
    this.initializer(n,updatetesserae,rules);
  }

  // Typical initialization of mosaic without updatetessserae function.
  void operator init(int n=0 ...substitution[] rules) {
    this.initializer(n, new void (tessera[], int){}, rules);
  }

  // Initialization of mosaic by specifying its attributes
  void operator init(substitution[] rules, tessera[] tesserae, int[] tilecount) {
    this.rules=rulecopy(rules);
    checkRulesError(rules);
    this.tesserae=copy_mosaic_tesserae(tesserae, rules);
    this.tilecount=copy(tilecount);
    this.initialtile=this.rules[0].supertile;
    this.inflation=this.rules[0].inflation;
    this.layers=this.tesserae[0].layers;
    this.n=this.tilecount.length-1;
  }

  // Assert that layer must be valid
  private void checkLayerError(int layer) {
    assert(0 <= layer && layer < layers, "Cannot access layer "+string(layer)+
           " in mosaic with "+string(layers)+" layers.");
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

  // addlayer(int n=1) adds n > 0 new layers to mosaic.
  void addlayer(int n=1) {
    assert(n >= 1, "Cannot add less than 1 layer.");
    for(int i=0; i < n; ++i) {
      for(int j=0; j < this.rules.length; ++j) {
        for(int k=0; k < this.rules[j].tesserae.length; ++k) {
          this.rules[j].tesserae[k].addlayer();
        }
      }
    }
    if(this.n == 0)
      tesserae[0].addlayer();
    this.layers+=1;
  }

  // Return true if initial tile should be decorated
  private bool decorateinitialtile(string[] tag) {
    if(n != 0) return false;
    if(tag.length == 0) return true;
    for(string s : tag)
      for(string initial_s : tesserae[0].tag)
        if(initial_s == s)
          return true;
    return false;
  }

  // Return indices of subpatch for decoration
  private int[][] decorateindices(string[] tag) {
    int[][] indices={};
    int idlength=tag.length;

    for(int l=0; l < this.rules.length; ++l) {
      for(int i=0; i < this.rules[l].tesserae.length; ++i) {
        if(idlength == 0) {
          indices.push(new int[] {l,i});
          continue;
        }
        bool pushedi=false;
        for(int j=0; j < max(idlength,1); ++j) {
          for(int k=0; k < this.rules[l].tesserae[i].tag.length; ++k)
            if(this.rules[l].tesserae[i].tag[k] == tag[j]) {
              indices.push(new int[] {l,i});
              pushedi=true;
              break;
            }
          if(pushedi) break;
        }
      }
    }
    return indices;
  }

  // Update with tile, fillpen, and drawpen
  // Update top layer
  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen,
                   pen drawpen=nullpen, int layer=this.layers-1
                   ...string[] tag) {
    checkLayerError(layer);

    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, layer);

    int[][] indices=decorateindices(tag);
    for(int i=0; i < indices.length; ++i)
      this.rules[indices[i][0]].tesserae[indices[i][1]].updatelayer(drawtile,
                                       fillpen, drawpen, layer);
  }

  // Update layer 0
  void update(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen
              ...string[] tag) {
    this.updatelayer(drawtile, fillpen, drawpen, 0 ...tag);
  }

  // Update with axial shading
  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
                   pen axialpenb=nullpen, pair axialb, int layer=this.layers-1
                   ...string[] tag) {
    checkLayerError(layer);

    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, axialpena, axiala,
                              axialpenb, axialb, layer);

    int[][] indices=decorateindices(tag);
    for(int[] index : indices)
      this.rules[index[0]].tesserae[index[1]].updatelayer(drawtile, axialpena,
                                       axiala, axialpenb, axialb, layer);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
              pen axialpenb=nullpen, pair axialb ...string[] tag) {
    this.updatelayer(drawtile, axialpena, axiala, axialpenb, axialb, 0 ...tag);
  }

  // Update with radial shading
  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala,
                   real radialra, pen radialpenb=nullpen, pair radialb,
                   real radialrb, int layer=this.layers-1 ...string[] tag) {
    checkLayerError(layer);

    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, radialpena, radiala,
                              radialra, radialpenb, radialb, radialrb, layer);

    int[][] indices=decorateindices(tag);
    for(int[] index : indices)
      this.rules[index[0]].tesserae[index[1]].updatelayer(drawtile,
                                       radialpena, radiala, radialra,
                                       radialpenb, radialb, radialrb, layer);
  }

  void update(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala,
              real radialra, pen radialpenb=nullpen, pair radialb,
              real radialrb ...string[] tag) {
      this.updatelayer(drawtile, radialpena, radiala, radialra, radialpenb,
                       radialb, radialrb, 0 ...tag);
  }

  // Update everything
  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
                   pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen,
                   pair radiala, real radialra, pen radialpenb=nullpen,
                   pair radialb, real radialrb, pen fillpen=nullpen,
                   pen drawpen=nullpen, int layer=this.layers-1
                   ...string[] tag) {
    checkLayerError(layer);

    int[][] indices=decorateindices(tag);
    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, axialpena, axiala,
                              axialpenb, axialb, radialpena, radiala, radialra,
                              radialpenb, radialb, radialrb, layer);

    for(int[] index : indices)
      this.rules[index[0]].tesserae[index[1]].updatelayer(drawtile,
                                       fillpen, drawpen, axialpena,
                                       axiala, axialpenb, axialb, radialpena,
                                       radiala, radialra, radialpenb, radialb,
                                       radialrb, layer);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
              pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen,
              pair radiala, real radialra, pen radialpenb=nullpen, pair radialb,
              real radialrb, pen fillpen=nullpen, pen drawpen=nullpen
              ...string[] tag) {
    this.updatelayer(drawtile, axialpena, axiala, axialpenb, axialb, radialpena,
                     radiala, radialra, radialpenb, radialb, radialrb, fillpen,
                     drawpen, 0 ...tag);
  }
}


// Create a deep copy of the mosaic M.
mosaic copy(mosaic M) {
  mosaic Mcopy=mosaic(M.rules, M.tesserae, M.tilecount);
  return Mcopy;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=copy(M);
  int L=M2.tesserae.length;
  for(int i=0; i < L; ++i)
    M2.tesserae[i]=T*M2.tesserae[i];
  return M2;
}

private real inflationscaling(bool scalelinewidth, real inflation, int n) {
  return scalelinewidth ? (inflation)^(1-max(n,1)) : 1;
}

// draw tile t
void draw(picture pic=currentpicture, explicit tile t, pen p=currentpen) {
  if(t.drawpen != nullpen) draw(pic, t.path, t.drawpen);
  else draw(pic,t.path,p);
}

// NOTE: default value of p is invisible. Not currentpen.
void fill(picture pic=currentpicture, explicit tile t, pen p=invisible) {
  if(t.fillable())
    if(t.fillpen != nullpen)
      fill(pic,t.path,t.fillpen);
    else
      fill(pic,t.path,p);
}

void filldraw(picture pic=currentpicture, explicit tile t,
              pen fillpen=invisible, pen drawpen=currentpen) {
  fill(pic,t,fillpen);
  draw(pic,t,drawpen);
}

void axialshade(picture pic=currentpicture, explicit tile t, bool stroke=false,
                bool extenda=true, bool extendb=true) {
  if(t.fillable() || stroke) axialshade(pic, t.path, stroke=stroke,
                              extenda=extenda, extendb=extendb, t.axialpena,
                              t.axiala, t.axialpenb, t.axialb);
}

void radialshade(picture pic=currentpicture, explicit tile t, bool stroke=false,
                 bool extenda=true, bool extendb=true) {
  if(t.fillable() || stroke) radialshade(pic, t.path, stroke=stroke,
                               extenda=extenda, extendb=extendb,
                               t.radialpena, t.radiala, t.radialra,
                               t.radialpenb, t.radialb, t.radialrb);
}

// Draw layer l of tessera.
void draw(picture pic=currentpicture, tessera t, int layer=0, pen p=currentpen,
          real scaling=1) {
  tile tdl=t.transform*t.drawtile[layer];
  pen dpl=tdl.drawpen;
  if(dpl != nullpen) {
    tdl.drawpen=dpl+scaling*linewidth(dpl);
    draw(pic, tdl);
  } else {
    draw(pic, tdl, p+scaling*linewidth(p));
  }
}

void fill(picture pic=currentpicture, tessera t, int layer=0, pen p=invisible) {
  tile tdl=t.drawtile[layer];
  fill(pic, t.transform*tdl,p);
}

void filldraw(picture pic=currentpicture, tessera t, int layer=0,
              pen fillpen=invisible, pen drawpen=currentpen, real scaling=1) {
  fill(pic, t, layer, fillpen);
  draw(pic, t, layer, drawpen, scaling);
}

void axialshade(picture pic=currentpicture, tessera t, int layer=0,
                bool stroke=false, bool extenda=true, bool extendb=true) {
  tile tdl=t.drawtile[layer];
  axialshade(pic, t.transform*tdl, stroke=stroke, extenda=extenda,
             extendb=extendb);
}

void radialshade(picture pic=currentpicture, tessera t, int layer=0,
                 bool stroke=false, bool extenda=true, bool extendb=true) {
  tile tdl=t.drawtile[layer];
  radialshade(pic, t.transform*tdl, stroke=stroke, extenda=extenda,
              extendb=extendb);
}

// Draw substitution. If drawboundary == true, also draw the supertile with
// boundarypen, scaled by inflation.
void draw(picture pic=currentpicture, substitution rule, pen p=currentpen,
              bool drawboundary=false,
              pen boundarypen=boundarypen) {
  for(tessera t : rule.tesserae)
    draw(pic,t,p);
  if(drawboundary)
    draw(pic,scale(rule.inflation)*rule.supertile,boundarypen);
}

void fill(picture pic=currentpicture, substitution rule, pen p=invisible,
          bool drawboundary=false,
          pen boundarypen=boundarypen) {
  for(tessera t : rule.tesserae)
    fill(pic,t,p);
  if(drawboundary)
    draw(pic,scale(rule.inflation)*rule.supertile,boundarypen);
}

void filldraw(picture pic=currentpicture, substitution rule,
              pen fillpen=invisible, pen drawpen=currentpen,
              bool drawboundary=false, pen boundarypen=boundarypen) {
  for(tessera t : rule.tesserae)
    filldraw(pic,t,fillpen,drawpen);
  if(drawboundary)
    draw(pic,scale(rule.inflation)*rule.supertile,boundarypen);
}

void axialshade(picture pic=currentpicture, substitution rule, bool stroke=false,
                bool extenda=true, bool extendb=true, bool drawboundary=false,
                pen boundarypen=boundarypen)  {
  for(tessera t : rule.tesserae)
    axialshade(pic,t,stroke=stroke,extenda=extenda,extendb=extendb);
  if(drawboundary)
    draw(pic,scale(rule.inflation)*rule.supertile,boundarypen);
}

void radialshade(picture pic=currentpicture, substitution rule,
                 bool stroke=false, bool extenda=true, bool extendb=true,
                 bool drawboundary=false, pen boundarypen=boundarypen)  {
  for(tessera t : rule.tesserae)
    radialshade(pic,t,stroke=stroke,extenda=extenda,extendb=extendb);
  if(drawboundary)
    draw(pic,scale(rule.inflation)*rule.supertile,boundarypen);
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
  for(tessera t : M.tesserae)
    draw(pic,t,layer,p,scaling);
}

void fill(picture pic=currentpicture, mosaic M, int layer, pen p=invisible) {
  for(tessera t : M.tesserae)
    fill(pic,t,layer,p);
}

void filldraw(picture pic=currentpicture, mosaic M, int layer,
              pen fillpen=invisible, pen drawpen=currentpen,
              bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth, M.inflation, nscale);
  for(tessera t : M.tesserae)
    filldraw(pic,t,layer,fillpen,drawpen,scaling);
}

void axialshade(picture pic=currentpicture, mosaic M, int layer,
                bool stroke=false, bool extenda=true, bool extendb=true) {
  for(tessera t : M.tesserae)
    axialshade(pic,t,layer,stroke,extenda,extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, int layer,
                 bool stroke=false, bool extenda=true, bool extendb=true) {
  for(tessera t : M.tesserae)
    radialshade(pic,t,layer,stroke,extenda,extendb);
}

// Draw all layers of mosaic. Layers are drawn in increasing order.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  for(int layer=0; layer < M.layers; ++layer)
    draw(pic,M,layer,p,scalelinewidth,nscale);
}

void fill(picture pic=currentpicture, mosaic M, pen p=invisible) {
  for(int layer=0; layer < M.layers; ++layer)
    fill(pic,M,layer,p);
}

void filldraw(picture pic=currentpicture, mosaic M, pen fillpen=invisible,
              pen drawpen=currentpen, bool scalelinewidth=true,
              int nscale=M.n) {
  for(int layer=0; layer < M.layers; ++layer)
    filldraw(pic,M,layer,fillpen,drawpen,scalelinewidth,nscale);
}

void axialshade(picture pic=currentpicture, mosaic M, bool stroke=false,
                bool extenda=true, bool extendb=true) {
  for(int layer=0; layer < M.layers; ++layer)
    axialshade(pic,M,layer,stroke,extenda,extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, bool stroke=false,
                 bool extenda=true, bool extendb=true) {
  for(int layer=0; layer < M.layers; ++layer)
    radialshade(pic,M,layer,stroke,extenda,extendb);
}
