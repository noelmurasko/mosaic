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
    if(Blen == 0) {
      return new string[] {};
    }
    AB=new string[] {B[0]};
    C=B[1:];
  } else {
    AB=new string[] {A[0]};
    C=concat(A[1:],B);
  }
  for(int i=0; i < C.length; ++i) {
    bool pushCi=true;
    for(int j=0; j < AB.length; ++j) {
      if(AB[j] == C[i]) {
        pushCi=false;
        break;
      }
    }
    if(pushCi) {
      AB.push(C[i]);
    }
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

  restricted string[] id;

  private void initializer(path[] path, pen fillpen=nullpen,
                           pen drawpen=nullpen, pen axialpena=nullpen,
                           pair axiala=(0,0), pen axialpenb=nullpen,
                           pair axialb=(0,0), pen radialpena=nullpen,
                           pair radiala=(0,0), real radialra=0,
                           pen radialpenb=nullpen, pair radialb=(0,0),
                           real radialrb=0, string[] id) {
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

    this.id=stringunion(new string[0],id);
  }

  void operator init(path[] path={}, pen fillpen=nullpen, pen drawpen=nullpen
                     ...string[] id) {
    this.initializer(path, fillpen, drawpen, id);
  }

  void operator init(path[] path={}, pen axialpena=nullpen, pair axiala,
                     pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen,
                     pen drawpen=nullpen ...string[] id) {
    this.initializer(path, fillpen, drawpen, axialpena=axialpena, axiala=axiala,
                     axialpenb=axialpenb, axialb=axialb, id);
  }

  void operator init(path[] path={}, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb, pen fillpen=nullpen, pen drawpen=nullpen
                     ...string[] id) {
    this.initializer(path, fillpen, drawpen, radialpena=radialpena,
                     radiala=radiala, radialra=radialra, radialpenb=radialpenb,
                     radialb=radialb, radialrb=radialrb, id);
  }

  void operator init(path[] path={}, pen fillpen=nullpen, pen drawpen=nullpen,
                     pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen,
                     pair axialb, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb ...string[] id) {
    this.initializer(path, fillpen, drawpen, axialpena=axialpena, axiala=axiala,
                     axialpenb=axialpenb, axialb=axialb, radialpena=radialpena,
                     radiala=radiala, radialra=radialra, radialpenb=radialpenb,
                     radialb=radialb, radialrb=radialrb, id);
  }

  void operator init(pair path, pen fillpen=nullpen, pen drawpen=nullpen
                     ...string[] id) {
    this.initializer(new path[] {path}, fillpen=fillpen, drawpen=drawpen, id);
  }

  void operator init(pair path, pen axialpena=nullpen, pair axiala,
                     pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen,
                     pen drawpen=nullpen ...string[] id) {
    this.initializer(new path[] {path}, fillpen, drawpen, axialpena=axialpena,
                     axiala=axiala, axialpenb=axialpenb, axialb=axialb, id);
  }

  void operator init(pair path, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb, pen fillpen=nullpen, pen drawpen=nullpen
                     ...string[] id) {
    this.initializer(new path[] {path}, fillpen, drawpen, radialpena=radialpena,
                     radiala=radiala, radialra=radialra, radialpenb=radialpenb,
                     radialb=radialb, radialrb=radialrb, id);
  }

  void operator init(pair path, pen fillpen=nullpen, pen drawpen=nullpen,
                     pen axialpena=nullpen, pair axiala, pen axialpenb=nullpen,
                     pair axialb, pen radialpena=nullpen, pair radiala,
                     real radialra, pen radialpenb=nullpen, pair radialb,
                     real radialrb ...string[] id) {
    this.initializer(new path[] {path}, fillpen, drawpen, axialpena=axialpena,
                     axiala=axiala, axialpenb=axialpenb, axialb=axialb,
                     radialpena=radialpena, radiala=radiala, radialra=radialra,
                     radialpenb=radialpenb, radialb=radialb, radialrb=radialrb,
                     id);
  }

  bool fillable() {
    for(int i=0; i < this.path.length; ++i)
      if(!cyclic(this.path[i])) return false;
    return true;
  }

  void addid(...string[] id) {
    this.id=stringunion(this.id, id);
  }

  void deleteid(int i, int j=i) {
    this.id.delete(i,j);
  }

  void deleteid() {
    this.id.delete();
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
              t.radialpenb, t.radialb, t.radialrb ...copy(t.id));
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

restricted tile nulltile=tile(nullpath);

struct tessera {
  transform transform;
  tile supertile;
  tile prototile;

  tile[] drawtile={};

  restricted int layers;
  string[] id;
  // Used to determine location of tile in the mosaic subpatch
  restricted int index;
  bool iterate;

  private void initializer(transform transform, tile supertile, tile prototile,
                           tile drawtile, pen fillpen, pen drawpen,
                           pen axialpena, pair axiala, pen axialpenb,
                           pair axialb, pen radialpena, pair radiala,
                           real radialra, pen radialpenb, pair radialb,
                           real radialrb, bool iterate=true, string[] id) {
    this.transform=transform;
    this.supertile=supertile;

    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    pen fp=fillpen == nullpen ? dt.fillpen : fillpen;
    pen dp=drawpen == nullpen ? dt.drawpen : drawpen;

    this.drawtile.push(tile(dt.path, fp, dp, axialpena, axiala,
                       axialpenb, axialb, radialpena, radiala, radialra,
                       radialpenb, radialb, radialrb));

    this.layers=1;
    this.id=stringunion(this.prototile.id, id);
    this.index=0;
    this.iterate=iterate;
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen,
                     bool iterate=true ...string[] id) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, dt.axialpena, dt.axiala, dt.axialpenb, dt.axialb,
                     dt.radialpena, dt.radiala, dt.radialra, dt.radialpenb,
                     dt.radialb, dt.radialrb, iterate, id);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen axialpena, pair axiala, pen axialpenb, pair axialb,
                     pen fillpen=nullpen, pen drawpen=nullpen, bool iterate=true
                     ...string[] id) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, axialpena, axiala, axialpenb, axialb,
                     dt.radialpena, dt.radiala, dt.radialra, dt.radialpenb,
                     dt.radialb, dt.radialrb, iterate, id);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen radialpena, pair radiala, real radialra,
                     pen radialpenb, pair radialb, real radialrb,
                     pen fillpen=nullpen, pen drawpen=nullpen, bool iterate=true
                     ...string[] id) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, dt.axialpena, dt.axiala, dt.axialpenb, dt.axialb,
                     radialpena, radiala, radialra, radialpenb, radialb,
                     radialrb, iterate, id);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen, pen axialpena,
                     pair axiala, pen axialpenb, pair axialb, pen radialpena,
                     pair radiala, real radialra, pen radialpenb, pair radialb,
                     real radialrb, bool iterate=true ...string[] id) {
    this.prototile = prototile == nulltile ? supertile : prototile;
    tile dt=drawtile == nulltile ? this.prototile : drawtile;
    this.initializer(transform, supertile, prototile, drawtile, fillpen,
                     drawpen, axialpena, axiala, axialpenb, axialb, radialpena,
                     radiala, radialra, radialpenb, radialb, radialrb, iterate,
                     id);
  }

  void operator init(transform transform=identity, tile supertile,
                     tile prototile=nulltile, tile[] drawtile, int index, bool
                     iterate=true ...string[] id) {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    this.index=index;
    this.layers=drawtile.length;

    this.id=stringunion(this.prototile.id, id);
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

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen axialpena,
                   pair axiala, pen axialpenb, pair axialb, int layer) {
    this.updatelayer(drawtile, layer);
    this.updatelayer(fillpen, drawpen, layer);
    this.updatelayer(axialpena, axiala, axialpenb, axialb, layer);
  }

  void updatelayer(tile drawtile, pen fillpen, pen drawpen, pen radialpena,
                   pair radiala, real radialra, pen radialpenb, pair radialb,
                   real radialrb, int layer) {
    this.updatelayer(drawtile, layer);
    this.updatelayer(fillpen, drawpen, layer);
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

  void addid(...string[] id) {
    this.id=stringunion(this.id, id);
  }

  void deleteid(int i, int j=i) {
    this.id.delete(i,j);
  }

  void deleteid() {
    this.id.delete();
  }

  // Change index to n
  void updateindex(int n) {
    this.index=n;
  }
}

struct substitution {
  tile supertile;
  tessera[] subpatch;
  real inflation;
  string[] id;

  void operator init(explicit tile supertile ...string[] id) {
    this.supertile=supertile;
    this.inflation=globalinflation();
    assert(this.inflation > 0, "Cannot set inflation to "+string(this.inflation)
           +". Inflation factor must be a strictly positive number.");
    this.id=id;
  }

  void operator init(explicit tile supertile, real inflation) {
    this.supertile=supertile;
    this.inflation=inflation;
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               explicit tile drawtile=nulltile,
                     pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    tessera m=tessera(transform, this.supertile, prototile, fillpen, drawpen
                      ...stringunion(this.id,id));
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               pen axialpena, pair axiala, pen axialpenb, pair axialb,
               pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    tessera m=tessera(transform, this.supertile, prototile, axialpena, axiala,
                      axialpenb, axialb, fillpen, drawpen
                      ...stringunion(this.id,id));
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               pen radialpena, pair radiala, real radialra, pen radialpenb,
               pair radialb, real radialrb,
                     pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    tessera m=tessera(transform, this.supertile, prototile, radialpena, radiala,
                      radialra, radialpenb, radialb, radialrb, fillpen, drawpen
                      ...stringunion(this.id,id));
    this.subpatch.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile,
               pen axialpena, pair axiala, pen axialpenb, pair axialb,
               pen radialpena, pair radiala, real radialra, pen radialpenb,
               pair radialb, real radialrb,
                     pen fillpen=nullpen, pen drawpen=nullpen ...string[] id) {
    tessera m=tessera(transform, this.supertile, prototile, fillpen, drawpen,
                      axialpena, axiala, axialpenb, axialb, radialpena, radiala,
                      radialra, radialpenb, radialb, radialrb
                      ...stringunion(this.id,id));
    this.subpatch.push(m);
  }
}

// Create a deep copy of the tessera t.
tessera copy(tessera t) {
  int L=t.drawtile.length;
  tile[] dtcopy=new tile[L];
  for(int i; i < L; ++i)
    dtcopy[i]=copy(t.drawtile[i]);
  // If supertile and prototile are the same, make only one copy
  if(t.supertile == t.prototile) {
    tile super2=copy(t.supertile);
    return tessera(t.transform, super2, super2, dtcopy, t.index,
                   t.iterate ...t.id);
  } else
    return tessera(t.transform, copy(t.supertile), copy(t.prototile), dtcopy,
                   t.index, t.iterate ...copy(t.id));
}

// Create a deep copy of the substitution s1.
substitution copy(substitution s1) {
  substitution s2=substitution(copy(s1.supertile), s1.inflation);
  for(int i=0; i < s1.subpatch.length; ++i)
    s2.subpatch.push(copy(s1.subpatch[i]));
  return s2;
}

// Create a new tessera t2 from t1 with a shallow copy of the supertile,
// prototile, and  drawtile.
tessera duplicate(tessera t1) {
  tessera t2=tessera(t1.transform, t1.supertile, t1.prototile, t1.drawtile,
                      t1.index, t1.iterate ...copy(t1.id));
  return t2;
}

// Create a new substitution s2 from s1 with a shallow copy of the subpatch.
substitution duplicate(substitution s1) {
  substitution s2=substitution(s1.supertile);
  s2.subpatch=s1.subpatch;
  s2.inflation=s1.inflation;
  return s2;
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

// Important: Mulitplying a tessera by a transform does result
// in a deep copy of the supertile, prototile, and drawtile.
tessera operator *(transform T, tessera t1) {
  tessera t2=duplicate(t1);
  t2.transform=T*t2.transform;
  return t2;
}

struct mosaic {
  // Collection of tessera that make up the mosaic.
  tessera[] tesserae;

  // Initial tile for mosiac. When initializing, this tile must match one of
  // the supertiles in the passed subsitution rules.
  tile initialtile;

  // Total number of substitutions performed
  int n=0;

  // Collection of tessera that define the substitution rules
  tessera[] subpatch;

  // Number of drawing layers in mosaic
  int layers=1;

  // Inflation factor for mosaic
  real inflation;

  // tilecount[k] is the number of tesserae in iteration k
  int[] tilecount;

  // Perform an iteration of a tessera T, and push the result onto the array
  // tesserae.
  private void iterate(tessera t, tessera[] tesserae) {
    // Loop over each tessera p in subpatch. If p.supertile is the same as
    // t.prototile, compute t*p. Note that t*p results in a tessera that is a
    // duplicate of p, except the transform is given by t.transform*p.transform.
    // Then scale t*p by inflation, and push onto tesserae.
    for(int i=0; i < subpatch.length; ++i) {
      tessera p=subpatch[i];
      if(p.supertile == t.prototile) {
        tesserae.push(scale(inflation)*t*p);
      }
    }
  }

  // Apply substituion rules in the mosaic n times times (for a total of
  // this.n+n subsitutions). After each iteration, call the function
  // updatetesserae(tesseare, k), where tesserae is an array of tessera in the
  // mosaic after k total iterations. Add m to this.n.
  void substitute(int n, void updatetesserae(tessera[], int)) {
    // Perform m iterations.
    for(int k=0; k < n; ++k) {
      // Create new tessera array for this iteration.
      tessera[] tesserae=new tessera[];

      // Loop over each tessera from previous iteration. If this.n is 0,
      // this array contains a tessera with this.initialtile as both the
      // supertile and prototile.
      for(int i=0; i < this.tesserae.length; ++i)
        // Call iterate() if iterate flag is true. Otherwise push the old
        // tessera onto the new array. The iterate flag is always true, unless
        // it set to false by updatetesserae.
        if(this.tesserae[i].iterate)
          this.iterate(this.tesserae[i], tesserae);
        else
          tesserae.push(scale(inflation)*this.tesserae[i]);

      // Apply updatetesserae()
      updatetesserae(tesserae, this.n+k+1);

      // Set this.tesserae to the new tessera array for this iteration.
      this.tesserae=tesserae;

      // Update tilecount
      this.tilecount.push(tesserae.length);
    }
    // Increase this.n to reflect total iterations.
    this.n+=n;
  }

  // A version of subsitute without the updatetesserae function.
  void substitute(int n) {this.substitute(n, new void (tessera[], int){});}

  // Common inititalization code.
  // Mosaics are initialized with an initialtile, and perform n substitutions
  // using the provided rules. If initialtile isn't specified or is equal to
  // nulltile, then supertile from the first specified rule is used as the
  // initial tile.
  // Advanced users may also provide a function updatetesserae(). After the
  // kth substitution (where k=0,...n), updatetesserae(this.tesserae, k) is
  // called where this.tesserae is the array of tesserae after k substitutions
  // have been applied. In regular usage, updatetesserae() does nothing.
  private void initializer(tile initialtile=nulltile, int n,
                           void updatetesserae(tessera[], int),
                           substitution[] rules) {
    // Set index to zero. This index tracks the position of each tessera in the
    // provided rules.
    int index=0;

    assert(rules.length > 0,"Mosaics must have at least one substitution.");

    // Set the mosaic inflation to the inflation factor in the first provided
    // rule
    this.inflation=rules[0].inflation;

    // Push duplicates of each tessera in the first rule onto this.subpatch,
    // updating the index of each.
    for(int j=0; j < rules[0].subpatch.length; ++j) {
      tessera t=duplicate(rules[0].subpatch[j]);
      t.updateindex(index);
      index+=1;
      this.subpatch.push(t);
    }

    // Check that each addtional rule has a matching inflation factor. Then
    // push duplicates of each tessera in the rule onto this.subpatch,
    // updating the index of each.
    for(int i=1; i < rules.length; ++i) {
      assert(rules[i].inflation == this.inflation,"All substitutions in a mosaic
             must have the same inflation factor.");
      for(int j=0; j < rules[i].subpatch.length; ++j) {
        tessera t=duplicate(rules[i].subpatch[j]);
        t.updateindex(index);
        index+=1;
        this.subpatch.push(t);
      }
    }

    // If initialtile is not specified, use supertile from first specified rule.
    if(initialtile == nulltile) {
      this.initialtile=rules[0].supertile;
    } else {
      int i=0;
      while(i < rules.length) {
        if(initialtile==rules[i].supertile) {
          this.initialtile=initialtile;
          break;
        }
        ++i;
      }
      assert(i < rules.length, "initialtile does not match any supertile in provided
            substitutions.");
    }

    real deflation=1/inflation;
    // Update each transform in subpatch to deflate.
    for(int i=0; i < this.subpatch.length; ++i) {
      transform Ti=subpatch[i].transform;
      subpatch[i].transform=(shiftless(Ti)+scale(deflation)*shift(Ti))*
                        scale(deflation);
    }

    // Create tessera from initialtile and push onto tesserae (corresponding
    // to n=0), push 1 to tilecount, and call updatetessera().
    this.tesserae.push(tessera(this.initialtile));
    this.tilecount.push(1);
    updatetesserae(this.tesserae,0);

    // Call substitute to perform n substitutions.
    this.substitute(n, updatetesserae);
  }

  // Initialization of mosaic using a updatetesserae function.
  void operator init(tile initialtile=nulltile, int n=0,
                     void updatetesserae(tessera[], int)
                     ...substitution[] rules) {
    this.initializer(initialtile, n, updatetesserae, rules);
  }

  // Typical initialization of mosaic.
  void operator init(tile initialtile=nulltile, int n=0 ...substitution[] rules) {
    this.initializer(initialtile, n, new void (tessera[], int){}, rules);
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
      for(int k=0; k < tesserae[0].id.length; ++k)
        if(tesserae[0].id[k] == id[j])
          return true;
    return false;
  }

  // Return indices of subpatch for decoration
  private int[] decorateIndices(string[] id) {
    int[] indices={};
    int idlength=id.length;
    for(int i=0; i < subpatch.length; ++i) {
      if(idlength == 0) {
        indices.push(i);
        continue;
      }
      bool pushedi=false;
      for(int j=0; j < max(idlength,1); ++j) {
        for(int k=0; k < subpatch[i].id.length; ++k) {
          if(subpatch[i].id[k] == id[j]) {
            indices.push(i);
            pushedi=true;
            break;
          }
        }
        if(pushedi) break;
      }
    }
    return indices;
  }

  // Update with tile, fillpen, and drawpen
  //Update top layer
  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen,
                   pen drawpen=nullpen, int layer=this.layers-1
                   ...string[] id) {
    checkLayerError(layer);

    if(decorateinitialtile(id))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, layer);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile, fillpen, drawpen, layer);
  }

  //Update layer 0
  void update(tile drawtile=nulltile, pen fillpen=nullpen, pen drawpen=nullpen
              ...string[] id) {
    this.updatelayer(drawtile, fillpen, drawpen, 0 ...id);
  }

  // Update with axial shading
  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
                   pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen,
                   pen drawpen=nullpen, int layer=this.layers-1
                   ...string[] id) {
    checkLayerError(layer);

    if(decorateinitialtile(id))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, axialpena, axiala,
                              axialpenb, axialb, layer);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile, fillpen, drawpen, axialpena,
                                       axiala, axialpenb, axialb, layer);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
              pen axialpenb=nullpen, pair axialb, pen fillpen=nullpen,
              pen drawpen=nullpen ...string[] id) {
    this.updatelayer(drawtile, axialpena, axiala, axialpenb, axialb, fillpen,
                     drawpen, 0 ...id);
  }

  // Update with radial shading
  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala,
                   real radialra, pen radialpenb=nullpen, pair radialb,
                   real radialrb, pen fillpen=nullpen, pen drawpen=nullpen,
                   int layer=this.layers-1 ...string[] id) {

    checkLayerError(layer);

    if(decorateinitialtile(id))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, radialpena, radiala,
                              radialra, radialpenb, radialb, radialrb, layer);

    int[] indices=decorateIndices(id);
    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile, fillpen, drawpen, radialpena,
                                       radiala, radialra, radialpenb, radialb,
                                       radialrb, layer);
  }

  void update(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala,
              real radialra, pen radialpenb=nullpen, pair radialb,
              real radialrb, pen fillpen=nullpen, pen drawpen=nullpen
              ...string[] id) {
      this.updatelayer(drawtile, radialpena, radiala, radialra, radialpenb,
                       radialb, radialrb, fillpen, drawpen, 0 ...id);
  }

  // Update everything
  void updatelayer(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
                   pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen,
                   pair radiala, real radialra, pen radialpenb=nullpen,
                   pair radialb, real radialrb, pen fillpen=nullpen,
                   pen drawpen=nullpen, int layer=this.layers-1
                   ...string[] id) {
    checkLayerError(layer);

    int[] indices=decorateIndices(id);
    if(decorateinitialtile(id))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, axialpena, axiala,
                              axialpenb, axialb, radialpena, radiala, radialra,
                              radialpenb, radialb, radialrb, layer);

    for(int i=0; i < indices.length; ++i)
      subpatch[indices[i]].updatelayer(drawtile, fillpen, drawpen, axialpena,
                                       axiala, axialpenb, axialb, radialpena,
                                       radiala, radialra, radialpenb, radialb,
                                       radialrb, layer);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
              pen axialpenb=nullpen, pair axialb, pen radialpena=nullpen,
              pair radiala, real radialra, pen radialpenb=nullpen, pair radialb,
              real radialrb, pen fillpen=nullpen, pen drawpen=nullpen
              ...string[] id) {
    this.updatelayer(drawtile, axialpena, axiala, axialpenb, axialb, radialpena,
                     radiala, radialra, radialpenb, radialb, radialrb, fillpen,
                     drawpen, 0 ...id);
  }
}

// Searches an array of tiles ts for tile t. If ts contains t,
// return the first index of ts cooresponding to t. If ts does
// not contain t, return -1.
private int searchtile(tile[] ts, tile t) {
  for(int i; i < ts.length; ++i) {
    if(ts[i] == t) {
      return i;
    }
  }
  return -1;
}

// Create a deep copy of the mosaic M.
mosaic copy(mosaic M) {
  mosaic Mcopy;

  Mcopy.n=M.n;
  Mcopy.layers=M.layers;
  Mcopy.inflation=M.inflation;
  Mcopy.tilecount=M.tilecount;

  // Each tessera in M.tesserae needs to be idetified with it's corresponding
  // patch.
  int Lt=M.tesserae.length;
  int Lp=M.subpatch.length;

  tile[] known_supertiles;
  tile[] known_prototiles;

  Mcopy.subpatch.push(copy(M.subpatch[0]));

  // Collect supertiles and prototiles from first tessera in original subpatch.
  known_supertiles.push(M.subpatch[0].supertile);
  known_prototiles.push(M.subpatch[0].prototile);

  tessera subpatchj_copy;
  for(int j=1; j < Lp; ++j) {
    // Create copy of jth tessera in subpatch.
    subpatchj_copy=copy(M.subpatch[j]);

    // Search known_supertiles for original supertile in jth tessera of
    // subpatch.
    int is=searchtile(known_supertiles, M.subpatch[j].supertile);

    // If supertile is found, set subpatchj_copy supertile to coresponding
    // supertile in Mcopy
    if(is != -1)
      subpatchj_copy.supertile=Mcopy.subpatch[is].supertile;

    // Push original supertile in jth tessera of subpatch to known_supertiles.
    known_supertiles.push(M.subpatch[j].supertile);

    // Search known_prototiles for original supertile in jth tessera of
    // subpatch.
    int ip=searchtile(known_prototiles, M.subpatch[j].prototile);

    // If prototile is found, set subpatchj_copy supertile to coresponding
    // prototile in Mcopy
    if(ip != -1)
      subpatchj_copy.prototile=Mcopy.subpatch[ip].prototile;

    // Push original prototile in jth tessera of subpatch to known_supertiles.
    known_prototiles.push(M.subpatch[j].supertile);

    // Push patch copy to Mcopy.
    Mcopy.subpatch.push(subpatchj_copy);
  }

  // Set Mcopy.initialtile
  int j=searchtile(known_supertiles,M.initialtile);
  Mcopy.initialtile=Mcopy.subpatch[j].supertile;

  // Push new tessera correct supertiles, prototiles, and drawtiles.
  for(int i=0; i < Lt; ++i) {
    tessera t=M.tesserae[i];
    int j=t.index;
    tessera t2=tessera(t.transform, Mcopy.subpatch[j].supertile,
                       Mcopy.subpatch[j].prototile, Mcopy.subpatch[j].drawtile,
                      j, t.iterate ...Mcopy.subpatch[j].id);
    Mcopy.tesserae.push(t2);
  }
  return Mcopy;
}

mosaic operator *(transform T, mosaic M) {
  mosaic M2=copy(M);
  int L=M2.tesserae.length;
  for(int i=0; i < L; ++i)
    M2.tesserae[i]=T*M2.tesserae[i];
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

void filldraw(picture pic=currentpicture, explicit tile t,
              pen fillpen=invisible, pen drawpen=currentpen) {
  fill(pic, t, fillpen);
  draw(pic, t, drawpen);
}

void axialshade(picture pic=currentpicture, explicit tile t, bool stroke=false,
                bool extenda=true, bool extendb=true) {
  if(t.fillable()) axialshade(pic, t.path, stroke=stroke, extenda=extenda,
                              extendb=extendb, t.axialpena, t.axiala,
                              t.axialpenb, t.axialb);
}

void radialshade(picture pic=currentpicture, explicit tile t, bool stroke=false,
                 bool extenda=true, bool extendb=true) {
  if(t.fillable()) radialshade(pic, t.path, stroke=stroke, extenda=extenda,
                               extendb=extendb, t.radialpena
    , t.radiala, t.radialra, t.radialpenb, t.radialb, t.radialrb);
}

// Draw layer l of tessera.
void draw(picture pic=currentpicture, tessera T, int layer=0, pen p=currentpen,
          real scaling=1) {
  tile Tdl=T.transform*T.drawtile[layer];
  pen dpl=Tdl.drawpen;
  if(dpl != nullpen) {
    Tdl.drawpen=dpl+scaling*linewidth(dpl);
    draw(pic, Tdl);
  } else {
    draw(pic, Tdl, p+scaling*linewidth(p));
  }
}

void fill(picture pic=currentpicture, tessera T, int layer=0, pen p=invisible) {
  tile Tdl=T.drawtile[layer];
  fill(pic, T.transform*Tdl);
}

void filldraw(picture pic=currentpicture, tessera T, int layer=0,
              pen fillpen=invisible, pen drawpen=currentpen, real scaling=1) {
  fill(pic, T, layer, fillpen);
  draw(pic, T, layer, drawpen, scaling);
}

void axialshade(picture pic=currentpicture, tessera T, int layer=0,
                bool stroke=false, bool extenda=true, bool extendb=true) {
  tile Tdl=T.drawtile[layer];
  axialshade(pic, T.transform*Tdl, stroke=stroke, extenda=extenda,
             extendb=extendb);
}

void radialshade(picture pic=currentpicture, tessera T, int layer=0,
                 bool stroke=false, bool extenda=true, bool extendb=true) {
  tile Tdl=T.drawtile[layer];
  radialshade(pic, T.transform*Tdl, stroke=stroke, extenda=extenda,
              extendb=extendb);
}

// Draw substitution. If drawboundary == true, also draw the supertile with
// boundarypen, scaled by inflation.
void draw(picture pic=currentpicture, substitution s, pen p=currentpen,
              bool drawboundary=false,
              pen boundarypen=boundarypen) {
  for(int k=0; k < s.subpatch.length; ++k)
    draw(pic, s.subpatch[k], p);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void fill(picture pic=currentpicture, substitution s, pen p=invisible,
          bool drawboundary=false,
          pen boundarypen=boundarypen) {
  for(int k=0; k < s.subpatch.length; ++k)
    fill(pic, s.subpatch[k], p);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void filldraw(picture pic=currentpicture, substitution s, pen fillpen=invisible,
              pen drawpen=currentpen, bool drawboundary=false,
              pen boundarypen=boundarypen) {
  for(int k=0; k < s.subpatch.length; ++k)
    filldraw(pic, s.subpatch[k], fillpen, drawpen);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void axialshade(picture pic=currentpicture, substitution s, bool stroke=false,
                bool extenda=true, bool extendb=true, bool drawboundary=false,
                pen boundarypen=boundarypen)  {
  for(int k=0; k < s.subpatch.length; ++k)
    axialshade(pic, s.subpatch[k], stroke=stroke, extenda=extenda,
               extendb=extendb);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void radialshade(picture pic=currentpicture, substitution s, bool stroke=false,
                 bool extenda=true, bool extendb=true, bool drawboundary=false,
                 pen boundarypen=boundarypen)  {
  for(int k=0; k < s.subpatch.length; ++k)
    radialshade(pic, s.subpatch[k], stroke=stroke, extenda=extenda,
                extendb=extendb);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

// Draw layer of mosaic.
// If scalelinewidth == true, the linewidth of the pen is scaled by the
// inflation nscale times. The default value of nscale is the number of
// iterations in the mosaic. When drawing a mosaic several times one mosaic
// multiple times (with different iterations) nscale provides a convenient way
// to use the same linewidth each time.
void draw(picture pic=currentpicture, mosaic M, int layer, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth, M.inflation, nscale);
  for(int k=0; k < M.tesserae.length; ++k)
    draw(pic, M.tesserae[k], layer, p, scaling);
}

void fill(picture pic=currentpicture, mosaic M, int layer, pen p=invisible) {
  for(int k=0; k < M.tesserae.length; ++k)
    fill(pic, M.tesserae[k], layer, p);
}

void filldraw(picture pic=currentpicture, mosaic M, int layer,
              pen fillpen=invisible, pen drawpen=currentpen,
              bool scalelinewidth=true, int nscale=M.n) {
  real scaling=inflationscaling(scalelinewidth, M.inflation, nscale);
  for(int k=0; k < M.tesserae.length; ++k)
    filldraw(pic, M.tesserae[k], layer, fillpen, drawpen, scaling);
}

void axialshade(picture pic=currentpicture, mosaic M, int layer,
                bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int k=0; k < M.tesserae.length; ++k)
    axialshade(pic, M.tesserae[k], layer, stroke, extenda, extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, int layer,
                 bool stroke=false, bool extenda=true, bool extendb=true) {
  for(int k=0; k < M.tesserae.length; ++k)
    radialshade(pic, M.tesserae[k], layer, stroke, extenda, extendb);
}

// Draw all layers of mosaic. Layers are drawn in increasing order.
void draw(picture pic=currentpicture, mosaic M, pen p=currentpen,
          bool scalelinewidth=true, int nscale=M.n) {
  for(int layer=0; layer < M.layers; ++layer)
    draw(pic, M, layer, p, scalelinewidth, nscale);
}

void fill(picture pic=currentpicture, mosaic M, pen p=invisible) {
  for(int layer=0; layer < M.layers; ++layer)
    fill(pic, M, layer, p);
}

void filldraw(picture pic=currentpicture, mosaic M, pen fillpen=invisible,
              pen drawpen=currentpen, bool scalelinewidth=true,
              int nscale=M.n) {
  for(int layer=0; layer < M.layers; ++layer) {
    filldraw(pic, M, layer, fillpen, drawpen, scalelinewidth, nscale);
  }
}

void axialshade(picture pic=currentpicture, mosaic M, bool stroke=false,
                bool extenda=true, bool extendb=true) {
  for(int layer=0; layer < M.layers; ++layer)
    axialshade(pic, M, layer, stroke, extenda, extendb);
}

void radialshade(picture pic=currentpicture, mosaic M, bool stroke=false,
                 bool extenda=true, bool extendb=true) {
  for(int layer=0; layer < M.layers; ++layer)
    radialshade(pic, M, layer, stroke, extenda, extendb);
}
