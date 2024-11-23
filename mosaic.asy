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

  void addid(...string[] tag) {
    this.tag=stringunion(this.tag, tag);
  }

  void deleteid(int i, int j=i) {
    this.tag.delete(i,j);
  }

  void deleteid() {
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

struct tessera {
  transform transform;
  tile supertile;
  tile prototile;

  tile[] drawtile={};

  restricted int layers;
  string[] tag;
  restricted int[] index;
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

    dt.fillpen=fp;
    dt.drawpen=dp;
    dt.axialpena=axialpena;
    dt.axialpenb=axialpenb;
    dt.axiala=axiala;
    dt.axialb=axialb;
    dt.radialpena=radialpena;
    dt.radiala=radiala;
    dt.radialra=radialra;
    dt.radialpenb=radialpenb;
    dt.radialb=radialb;
    dt.radialrb=radialrb;
    this.drawtile.push(dt);
    //this.drawtile.push(tile(dt.path, fp, dp, axialpena, axiala,
    //                   axialpenb, axialb, radialpena, radiala, radialra,
    //                   radialpenb, radialb, radialrb));

    this.layers=1;
    this.tag=stringunion(this.prototile.tag, tag);
    this.index=new int[] {0,0};
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
                     tile prototile=nulltile, tile[] drawtile, int[] index, bool
                     iterate=true ...string[] tag) {
    this.transform=transform;
    this.supertile=supertile;
    this.prototile = prototile == nulltile ? supertile : prototile;

    this.drawtile=drawtile;
    this.index=index;
    this.layers=drawtile.length;

    this.tag=stringunion(this.prototile.tag, tag);
    this.iterate=iterate;
  }

  void addlayer() {
    this.drawtile.push(nulltile);
    this.layers+=1;
  }

  void updatelayer(tile drawtile, int layer) {
    if(drawtile != nulltile) this.drawtile[layer]=drawtile;
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

  void addid(...string[] tag) {
    this.tag=stringunion(this.tag, tag);
  }

  void deleteid(int i, int j=i) {
    this.tag.delete(i,j);
  }

  void deleteid() {
    this.tag.delete();
  }
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
    tessera m=tessera(transform, this.supertile, prototile, drawtile, fillpen, drawpen
                      ...stringunion(this.tag,tag));
    m.index[1]=tesserae.length;
    this.tesserae.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
               pen axialpena, pair axiala, pen axialpenb, pair axialb
               ...string[] tag) {
    tessera m=tessera(transform, this.supertile, prototile, drawtile, axialpena, axiala,
                      axialpenb, axialb ...stringunion(this.tag,tag));
    m.index[1]=tesserae.length;
    this.tesserae.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
               pen radialpena, pair radiala, real radialra, pen radialpenb,
               pair radialb, real radialrb ...string[] tag) {
    tessera m=tessera(transform, this.supertile, prototile, drawtile, radialpena, radiala,
                      radialra, radialpenb, radialb, radialrb
                      ...stringunion(this.tag,tag));
    m.index[1]=tesserae.length;
    this.tesserae.push(m);
  }

  void addtile(transform transform=identity, explicit tile prototile=nulltile, explicit tile drawtile=nulltile,
               pen axialpena, pair axiala, pen axialpenb, pair axialb,
               pen radialpena, pair radiala, real radialra, pen radialpenb,
               pair radialb, real radialrb, pen fillpen=nullpen,
               pen drawpen=nullpen ...string[] tag) {
    tessera m=tessera(transform, this.supertile, prototile, drawtile, fillpen, drawpen,
                      axialpena, axiala, axialpenb, axialb, radialpena, radiala,
                      radialra, radialpenb, radialb, radialrb
                      ...stringunion(this.tag,tag));
    m.index[1]=tesserae.length;
    this.tesserae.push(m);
  }

  void addtile(tessera tessera) {
    this.tesserae.push(tessera);
  }

  void updateindex0(int i) {
    for(int j=0; j < tesserae.length; ++j) {
      tesserae[j].index[0]=i;
    }
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
    return tessera(t.transform, super2, super2, dtcopy, copy(t.index),
                   t.iterate ...t.tag);
  } else
    return tessera(t.transform, copy(t.supertile), copy(t.prototile), dtcopy,
                   copy(t.index), t.iterate ...copy(t.tag));
}

// Create a deep copy of the substitution s1.
substitution copy(substitution s1) {
  substitution s2=substitution(copy(s1.supertile), s1.inflation);
  for(int i=0; i < s1.tesserae.length; ++i)
    s2.tesserae.push(copy(s1.tesserae[i]));
  return s2;
}

// Create a new tessera t2 from t1 with a shallow copy of the supertile,
// prototile, and  drawtile.
tessera duplicate(tessera t1) {
  tessera t2=tessera(t1.transform, t1.supertile, t1.prototile, t1.drawtile,
                      copy(t1.index), t1.iterate ...copy(t1.tag));
  return t2;
}

// Create a new substitution s2 from s1 with a shallow copy of the tesserae.
substitution duplicate(substitution s1) {
  substitution s2=substitution(s1.supertile);
  int n=s1.tesserae.length;
  s2.tesserae=new tessera[n];
  for(int j=0; j < n; ++j) {
    s2.tesserae[j]=duplicate(s1.tesserae[j]);
  }
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

// mosaic | Substitution tiling created from substiution rules. Contains the
// following attributes
//
// tessera[] tesserae; | collection of tessera that make up the mosaic.
//
// tile initialtile;| Initial tile for mosiac. When initializing,
// this tile must match one of the supertiles in the passed subsitution rules.
//
// int n=0; | total number of substitutions performed
//
// tessera[] tesserae; | Collection of tessera that define the substitution rules
//
// int layers=1; | Number of drawing layers in mosaic
//
// real inflation; | inflation factor for mosaic
//
//
// int[] tilecount; | int tilecount[k] is the number of tesserae in iteration k

struct mosaic {
  tessera[] tesserae;
  tile initialtile;
  int n=0;
  //tessera[] subpatch;
  substitution[] rules;
  int layers=1;
  real inflation;
  int[] tilecount;

  // Perform an iteration of a tessera T, and push the result onto the array
  // tesserae.
  private void iterate(tessera t, tessera[] tesserae) {
    for(int i=0; i < rules.length; ++i) {
      for(int j=0; j < rules[i].tesserae.length; ++j) {
        tessera p=rules[i].tesserae[j];
        if(p.supertile == t.prototile) {
          tesserae.push(scale(inflation)*t*p);
        }
      }
    }
    /*
    for(int i=0; i < subpatch.length; ++i) {
      tessera p=subpatch[i];
      if(p.supertile == t.prototile) {
        tesserae.push(scale(inflation)*t*p);
      }
    }
    */
  }

  // Apply substituion rules in the mosaic n times times (for a total of
  // this.n+n subsitutions). After each iteration, call the function
  // updatetesserae(tesseare, k), where tesserae is an array of tessera in the
  // mosaic after k total iterations. Add m to this.n.
  void substitute(int n, void updatetesserae(tessera[], int)) {
    for(int k=0; k < n; ++k) {
      tessera[] tesserae=new tessera[];
      for(int i=0; i < this.tesserae.length; ++i)
        if(this.tesserae[i].iterate)
          this.iterate(this.tesserae[i], tesserae);
        else
          tesserae.push(scale(inflation)*this.tesserae[i]);

      updatetesserae(tesserae, this.n+k+1);

      this.tesserae=tesserae;

      this.tilecount.push(tesserae.length);
    }
    this.n+=n;
  }

  // A version of subsitute without the updatetesserae function.
  void substitute(int n) {this.substitute(n, new void (tessera[], int){});}

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

    assert(rules.length > 0,"Mosaics must have at least one substitution.");
    this.inflation=rules[0].inflation;
    this.initialtile=rules[0].supertile;

    this.rules=new substitution[rules.length];
    this.rules[0]=duplicate(rules[0]);

    /*
    for(int j=0; j < rules[0].tesserae.length; ++j) {
      tessera t=duplicate(rules[0].tesserae[j]);
      t.updateindex(index);
      index+=1;
      this.subpatch.push(t);
    }
    */
    for(int i=1; i < rules.length; ++i) {
      assert(rules[i].inflation == this.inflation,"All substitutions in a mosaic
             must have the same inflation factor.");
      this.rules[i]=duplicate(rules[i]);
      this.rules[i].updateindex0(i);
      /*
      for(int j=0; j < rules[i].tesserae.length; ++j) {
        tessera t=duplicate(rules[i].tesserae[j]);
        t.updateindex(index);
        index+=1;
        this.subpatch.push(t);
      }
      */
    }

    transform D=scale(1/inflation);
    // Update each transform in subpatch to deflate.
    /*
    for(int j=0; j < this.subpatch.length; ++j) {
      this.subpatch[j].transform=D*this.subpatch[j].transform;
    }
    */
    for(int i=0; i < this.rules.length; ++i){
      for(int j=0; j < this.rules[i].tesserae.length; ++j) {
        this.rules[i].tesserae[j].transform=D*this.rules[i].tesserae[j].transform;
      }
    }
    this.tesserae.push(tessera(this.initialtile));
    this.tilecount.push(1);
    updatetesserae(this.tesserae,0);

    this.substitute(n, updatetesserae);
  }

  // Initialization of mosaic using a updatetesserae function.
  void operator init(int n=0, void updatetesserae(tessera[], int)
                     ...substitution[] rules) {
    this.initializer(n, updatetesserae, rules);
  }

  // Typical initialization of mosaic without updatetessserae function.
  void operator init(int n=0 ...substitution[] rules) {
    this.initializer(n, new void (tessera[], int){}, rules);
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

  // addlayer(int n=1) Adds n > 0 new layers to mosaic.
  void addlayer(int n=1) {
    assert(n >= 1, "Cannot add less than 1 layer.");
    for(int i=0; i < n; ++i) {
      for(int j=0; j < this.rules.length; ++j) {
        for(int k=0; k < this.rules[j].tesserae.length; ++k) {
          this.rules[j].tesserae[k].addlayer();
        }
      }
    }
    if(this.n == 0) tesserae[0].addlayer();
      this.layers+=1;
  }

  // Return true if start tile should be decorated
  private bool decorateinitialtile(string[] tag) {
    int idlength=tag.length;
    if(n != 0) return false;
    if(idlength == 0) return true;
    for(int j=0; j < idlength; ++j)
      for(int k=0; k < tesserae[0].tag.length; ++k)
        if(tesserae[0].tag[k] == tag[j])
          return true;
    return false;
  }

  // Return indices of subpatch for decoration
  private int[][] decorateIndices(string[] tag) {
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
          for(int k=0; k < this.rules[l].tesserae[i].tag.length; ++k) {
            if(this.rules[l].tesserae[i].tag[k] == tag[j]) {
              indices.push(new int[] {l,i});
              pushedi=true;
              break;
            }
          }
          if(pushedi) break;
        }
      }
    }
    return indices;
  }

  // Update with tile, fillpen, and drawpen
  //Update top layer
  void updatelayer(tile drawtile=nulltile, pen fillpen=nullpen,
                   pen drawpen=nullpen, int layer=this.layers-1
                   ...string[] tag) {
    checkLayerError(layer);

    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, layer);

    int[][] indices=decorateIndices(tag);
    for(int i=0; i < indices.length; ++i)
      this.rules[indices[i][0]].tesserae[indices[i][1]].updatelayer(drawtile, fillpen, drawpen, layer);
  }

  //Update layer 0
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

    int[][] indices=decorateIndices(tag);
    for(int i=0; i < indices.length; ++i)
      this.rules[indices[i][0]].tesserae[indices[i][1]].updatelayer(drawtile, axialpena, axiala, axialpenb,
                                       axialb, layer);
  }

  void update(tile drawtile=nulltile, pen axialpena=nullpen, pair axiala,
              pen axialpenb=nullpen, pair axialb ...string[] tag) {
    this.updatelayer(drawtile, axialpena, axiala, axialpenb, axialb, 0 ...tag);
  }

  // Update with radial shading
  void updatelayer(tile drawtile=nulltile, pen radialpena=nullpen, pair radiala,
                   real radialra, pen radialpenb=nullpen, pair radialb,
                   real radialrb,
                   int layer=this.layers-1 ...string[] tag) {

    checkLayerError(layer);

    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, radialpena, radiala,
                              radialra, radialpenb, radialb, radialrb, layer);

    int[][] indices=decorateIndices(tag);
    for(int i=0; i < indices.length; ++i)
      this.rules[indices[i][0]].tesserae[indices[i][1]].updatelayer(drawtile, radialpena,
                                       radiala, radialra, radialpenb, radialb,
                                       radialrb, layer);
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

    int[][] indices=decorateIndices(tag);
    if(decorateinitialtile(tag))
      tesserae[0].updatelayer(drawtile, fillpen, drawpen, axialpena, axiala,
                              axialpenb, axialb, radialpena, radiala, radialra,
                              radialpenb, radialb, radialrb, layer);

    for(int i=0; i < indices.length; ++i)
      this.rules[indices[i][0]].tesserae[indices[i][1]].updatelayer(drawtile, fillpen, drawpen, axialpena,
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





/*
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

  known_supertiles.push(M.subpatch[0].supertile);
  known_prototiles.push(M.subpatch[0].prototile);

  tessera subpatchj_copy;
  int is;
  int ip;
  // Create copy of jth tessera in subpatch.
  // Search known_supertiles for original supertile in jth tessera of
  // subpatch.
  // If supertile is found, set subpatchj_copy supertile to coresponding
  // supertile in Mcopy
  // Push original supertile in jth tessera of subpatch to known_supertiles.
  // Repeat for prototiles.
  for(int j=1; j < Lp; ++j) {
    subpatchj_copy=copy(M.subpatch[j]);

    is=searchtile(known_supertiles, M.subpatch[j].supertile);
    ip=searchtile(known_prototiles, M.subpatch[j].supertile);
    if(is != -1) {
      subpatchj_copy.supertile=Mcopy.subpatch[is].supertile;
    } else if (ip != -1) {
      subpatchj_copy.supertile=Mcopy.subpatch[ip].prototile;
    }

    known_supertiles.push(M.subpatch[j].supertile);

    is=searchtile(known_supertiles, M.subpatch[j].prototile);
    ip=searchtile(known_prototiles, M.subpatch[j].prototile);
    if(ip != -1) {
      subpatchj_copy.prototile=Mcopy.subpatch[ip].prototile;
    } else if (is != -1 && is != j) {
        // is == j when encountering new supertile and prototile == supertile
        subpatchj_copy.prototile=Mcopy.subpatch[is].supertile;
    }

    known_prototiles.push(M.subpatch[j].prototile);

    Mcopy.subpatch.push(subpatchj_copy);
  }
  // Set Mcopy.initialtile
  int j=searchtile(known_supertiles,M.initialtile);
  Mcopy.initialtile=Mcopy.subpatch[j].supertile;

  // Push onto new tessera correct supertiles, prototiles, and drawtiles.
  if(Lt > 1) {
    for(int i=0; i < Lt; ++i) {
      tessera t=M.tesserae[i];
      int j=t.index;
      tessera t2=tessera(t.transform, Mcopy.subpatch[j].supertile,
                         Mcopy.subpatch[j].prototile, Mcopy.subpatch[j].drawtile,
                        j, t.iterate ...Mcopy.subpatch[j].tag);
      Mcopy.tesserae.push(t2);
    }
  } else {
    tessera t=M.tesserae[0];
    tessera t2=tessera(t.transform, Mcopy.initialtile,
                         Mcopy.initialtile, new tile[] {Mcopy.initialtile},
                        0, t.iterate ...t.tag);
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
*/

private real inflationscaling(bool scalelinewidth, real inflation, int n) {
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
  if(t.fillable() || stroke) axialshade(pic, t.path, stroke=stroke, extenda=extenda,
                              extendb=extendb, t.axialpena, t.axiala,
                              t.axialpenb, t.axialb);
}

void radialshade(picture pic=currentpicture, explicit tile t, bool stroke=false,
                 bool extenda=true, bool extendb=true) {
  if(t.fillable() || stroke) radialshade(pic, t.path, stroke=stroke, extenda=extenda,
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
  fill(pic, T.transform*Tdl,p);
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
  for(int k=0; k < s.tesserae.length; ++k)
    draw(pic, s.tesserae[k], p);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void fill(picture pic=currentpicture, substitution s, pen p=invisible,
          bool drawboundary=false,
          pen boundarypen=boundarypen) {
  for(int k=0; k < s.tesserae.length; ++k)
    fill(pic, s.tesserae[k], p);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void filldraw(picture pic=currentpicture, substitution s, pen fillpen=invisible,
              pen drawpen=currentpen, bool drawboundary=false,
              pen boundarypen=boundarypen) {
  for(int k=0; k < s.tesserae.length; ++k)
    filldraw(pic, s.tesserae[k], fillpen, drawpen);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void axialshade(picture pic=currentpicture, substitution s, bool stroke=false,
                bool extenda=true, bool extendb=true, bool drawboundary=false,
                pen boundarypen=boundarypen)  {
  for(int k=0; k < s.tesserae.length; ++k)
    axialshade(pic, s.tesserae[k], stroke=stroke, extenda=extenda,
               extendb=extendb);
  if(drawboundary)
    draw(pic, scale(s.inflation)*s.supertile, boundarypen);
}

void radialshade(picture pic=currentpicture, substitution s, bool stroke=false,
                 bool extenda=true, bool extendb=true, bool drawboundary=false,
                 pen boundarypen=boundarypen)  {
  for(int k=0; k < s.tesserae.length; ++k)
    radialshade(pic, s.tesserae[k], stroke=stroke, extenda=extenda,
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

// Create a deep copy of the mosaic M.
// What to do about drawtiles
mosaic copy(mosaic M) {
  mosaic Mcopy;

  Mcopy.n=M.n;
  Mcopy.layers=M.layers;
  Mcopy.inflation=M.inflation;
  Mcopy.tilecount=M.tilecount;

  tile[] knowntiles;
  tile[] knowntiles_copy;

  int[] sup_index;
  int[] pro_index;
  int[][] dra_index;

  for(int i=0; i < M.rules.length; ++i) {
    substitution rulei=M.rules[i];
    int ks=searchtile(knowntiles,rulei.supertile);
    if(ks == -1) {
        knowntiles.push(rulei.supertile);
        knowntiles_copy.push(copy(rulei.supertile));
        sup_index.push(knowntiles.length-1);
    } else {
      sup_index.push(ks);
    }
    tessera[] tessi=rulei.tesserae;
    for(int j=0; j < tessi.length; ++j) {
      tessera tessij=tessi[j];
      int kp=searchtile(knowntiles,tessij.prototile);
      if(kp == -1) {
        knowntiles.push(tessij.prototile);
        knowntiles_copy.push(copy(tessij.prototile));
        pro_index.push(knowntiles.length-1);
      } else {
        pro_index.push(kp);
      }
      //dra_index.push(new int[tessij.drawtile.length]);
      int[] dra_index_j;
      for(int k=0; k < tessij.drawtile.length; ++k) {
        int kd=searchtile(knowntiles,tessij.drawtile[k]);
        if(kd == -1) {
          knowntiles.push(tessij.drawtile[k]);
          knowntiles_copy.push(copy(tessij.drawtile[k]));
          dra_index_j.push(knowntiles.length-1);
        } else {
          dra_index_j.push(kd);
        }
      }
      dra_index.push(dra_index_j);
    }
  }

  for(int i=0; i < M.rules.length; ++i) {
    substitution rulei=M.rules[i];
    substitution rulei_copy=duplicate(rulei);
    for(int j=0; j < rulei.tesserae.length; ++j) {
      rulei_copy.tesserae[j].supertile=knowntiles[sup_index[i]];
      rulei_copy.tesserae[j].prototile=knowntiles[pro_index[j]];
      for(int k=0; k < rulei.tesserae[j].drawtile.length; ++k) {
        rulei_copy.tesserae[j].drawtile[k]=knowntiles[dra_index[j][k]];
      }
    }
    Mcopy.rules.push(rulei_copy);
  }

  Mcopy.initialtile=Mcopy.rules[0].supertile;


  /*
  write();
  write(sup_index);
  write();
  write(pro_index);
  write();
  for(int i=0; i < dra_index.length; ++i)
    write(dra_index[i]);
  */

  if(M.tesserae.length > 1) {
    for(int l=0; l < M.tesserae.length; ++l) {
      tessera t=M.tesserae[l];
      int i=t.index[0];
      int j=t.index[1];

      tessera t2=tessera(t.transform, Mcopy.rules[i].supertile,
                         Mcopy.rules[i].tesserae[j].prototile, Mcopy.rules[i].tesserae[j].drawtile,
                        Mcopy.rules[i].tesserae[j].index, t.iterate ...Mcopy.rules[i].tesserae[j].tag);
      Mcopy.tesserae.push(t2);
    }
  } else {
    tessera t=M.tesserae[0];
    tessera t2=tessera(t.transform, Mcopy.initialtile,
                         Mcopy.initialtile, new tile[] {Mcopy.initialtile},
                        new int[] {0,0}, t.iterate ...copy(t.tag));
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
