// Run all positive checks with: asy -noV regressions.asy
// run-tests.zsh also verifies the expected failures in separate processes.
import mosaic;

// -u selects a test; Asymptote appends a semicolon to this setting.
bool test(string name) {
  return settings.user == "" || find(settings.user,name+";") == 0;
}

// Copying must preserve single-tile substitutions and accept empty mosaics.
if(test("copy-mosaic")) {
  tile a=unitsquare;
  tile b=(0,0)--(2,0)--(0,2)--cycle;
  substitution sa=substitution(a);
  sa.addtile(shift(3,0),b,fillpen=red);
  substitution sb=substitution(b);
  sb.addtile();
  sb.addtile(shift(1,0));
  mosaic m=mosaic(1,sa,sb);
  mosaic c=copy(m);
  assert(c.n == m.n && c.tilecount.length == m.tilecount.length);
  assert(c.tesserae[0].transform == m.tesserae[0].transform);
  assert(c.tesserae[0].iterindex == 1);
  assert(c.tesserae[0].drawtile[0].fillpen == red);
  m.substitute(1);
  c.substitute(1);
  assert(m.tesserae.length == c.tesserae.length);

  substitution empty=substitution(a);
  assert(copy(mosaic(1,empty)).tesserae.length == 0);
  mosaic initial=copy(mosaic(0,sa,sb));
  assert(initial.n == 0);
  initial.substitute(1);
  assert(initial.tesserae[0].iterindex == 1);
  write("Single-tile copies follow the same rule; empty and initial copies work.");
}

// Copies retain independent decorations and sharing without aliasing the source.
if(test("copy-state")) {
  tile a=unitsquare;
  substitution s=substitution(a);
  s.addtile(blue);
  s.addtile(shift(1,0),blue);
  s.addtile(shift(2,0),blue);
  void customize(tessera[] ts,int k) {
    if(k == 1) {
      ts[0].drawtile=new tile[] {copy(ts[0].drawtile[0])};
      ts[0].drawtile[0].fillpen=red;
      ts[0].addtag("custom");
      ts[1].drawtile=ts[0].drawtile;
    }
  }
  mosaic m=mosaic(1,customize,s);
  mosaic c=copy(m);
  assert(c.tesserae[0].drawtile[0].fillpen == red);
  assert(c.tesserae[0].tag[0] == "custom");
  assert(alias(c.tesserae[0].drawtile,c.tesserae[1].drawtile));
  assert(!alias(c.tesserae[0].drawtile,m.tesserae[0].drawtile));
  c.update(fillpen=green);
  assert(c.tesserae[2].drawtile[0].fillpen == green);
  assert(c.tesserae[0].drawtile[0].fillpen == red);
  assert(m.tesserae[2].drawtile[0].fillpen == blue);
  mosaic moved=shift(2,3)*m;
  assert(moved.tesserae[0].drawtile[0].fillpen == red);
  assert(moved.tesserae[0].tag[0] == "custom");
  c.substitute(1);
  assert(c.tesserae.length == 9);
  write("Copies and transforms preserve custom state, sharing, and source isolation.");
}

// Callback tile changes take effect, including original input tile references.
if(test("callback")) {
  tile a=unitsquare;
  tile b=(0,0)--(2,0)--(0,2)--cycle;
  substitution sa=substitution(a);
  sa.addtile();
  substitution sb=substitution(b);
  sb.addtile();
  sb.addtile(shift(1,0));
  mosaic m=mosaic(0,sa,sb);
  void chooseB(tessera[] ts,int k) {
    if(k == 1) ts[0].prototile=m.rules[1].supertile;
  }
  m.substitute(1,chooseB);
  assert(m.tesserae[0].iterindex == 1);
  mosaic c=copy(m);
  c.substitute(1);
  assert(c.tesserae.length == 2);
  void chooseOriginalB(tessera[] ts,int k) {
    if(k == 0) ts[0].prototile=b;
  }
  mosaic original=mosaic(1,chooseOriginalB,sa,sb);
  assert(original.tesserae.length == 2);

  // An unknown type stops substituting without overwriting explicit freezing.
  tile unknown=unitcircle;
  void chooseUnknown(tessera[] ts,int k) {
    if(k == 0) ts[0].prototile=unknown;
  }
  mosaic stopped=mosaic(1,chooseUnknown,sa,sb);
  assert(stopped.tesserae.length == 1);
  assert(stopped.tesserae[0].iterindex == -1);
  assert(stopped.tesserae[0].iterate);
  void restoreB(tessera[] ts,int k) {ts[0].prototile=b;}
  stopped.substitute(1,restoreB);
  stopped.substitute(1);
  assert(stopped.tesserae.length == 2);
  void freezeB(tessera[] ts,int k) {
    if(k == 0) {
      ts[0].prototile=b;
      ts[0].iterate=false;
    }
  }
  assert(mosaic(2,freezeB,sa,sb).tesserae.length == 1);
  write("Callback type changes select the right rule; freezing and unknown types work.");
}

// Radial shading follows similarity transforms, including reflections.
if(test("radial") || test("radial-affine")) {
  tile shaded=tile(unitsquare,red,(0,0),1,blue,(1,1),2);
  tile enlarged=shift(2,4)*rotate(30)*scale(-3)*shaded;
  assert(abs(enlarged.radialra-3) < sqrtEpsilon);
  assert(abs(enlarged.radialrb-6) < sqrtEpsilon);
  assert(length(enlarged.radialb-
                (shift(2,4)*rotate(30)*scale(-3))*(1,1)) < sqrtEpsilon);
  tile reflected=reflect((0,0),(0,1))*enlarged;
  assert(abs(reflected.radialrb-6) < sqrtEpsilon);
  tile unchanged=shift(5,8)*shaded;
  assert(unchanged.radialra == 1 && unchanged.radialrb == 2);
  if(find(settings.user,"radial-affine") == 0) {
    // Must fail: circular radii cannot represent an elliptical gradient.
    tile unsupported=xscale(2)*shaded;
    abort("Expected rejection of nonuniform radial shading.");
  }
  write("Scaling by 3 changes radii 1,2 to 3,6; rigid transforms preserve radii.");
}

// Add each layer once per drawing array, including a frozen initial tile.
if(test("layers")) {
  tile a=unitsquare;
  substitution s=substitution(a);
  s.addtile();
  s.addtile(shift(1,0));
  void freeze(tessera[] ts,int k) {
    if(k == 0) ts[0].iterate=false;
  }
  mosaic frozen=mosaic(1,freeze,s);
  frozen.addlayer();
  assert(frozen.layers() == 2);
  assert(frozen.rules[0].layers() == 2);
  frozen.updatelayer(fillpen=red,layer=1);
  assert(frozen.tesserae[0].drawtile[1].fillpen == red);

  void customize(tessera[] ts,int k) {
    if(k == 2) {
      ts[0].drawtile=new tile[] {copy(ts[0].drawtile[0])};
      ts[1].drawtile=ts[0].drawtile;
    }
  }
  mosaic shared=mosaic(2,customize,s);
  shared.addlayer(2);
  for(tessera t : shared.tesserae) assert(t.layers() == 3);
  for(tessera t : shared.rules[0].tesserae) assert(t.layers() == 3);
  write("Frozen tiles receive layers; shared arrays receive each new layer once.");
}

// The initial tile has the normalized rule layer count before its callback.
if(test("initial-layers")) {
  tile a=unitsquare;
  substitution s=substitution(a);
  s.addtile();
  s.addlayer();
  void checkInitial(tessera[] ts,int k) {
    if(k == 0) assert(ts[0].layers() == 2);
  }
  mosaic m=mosaic(0,checkInitial,s);
  assert(m.layers() == m.rules[0].layers());
  m.updatelayer(fillpen=red,layer=1);
  assert(m.tesserae[0].drawtile[1].fillpen == red);
  mosaic c=copy(m);
  assert(c.layers() == 2);
  assert(c.tesserae[0].drawtile[1].fillpen == red);
  m.substitute(1);
  assert(m.layers() == 2);
  write("Initial tiles have both layers before callbacks, updates, and copying.");
}

// Copies and transforms preserve deleted tags instead of inheriting them again.
if(test("tags")) {
  tile a=tile(unitsquare,"base");
  tessera t=tessera(a);
  t.deletetag();
  assert(copy(t).tag.length == 0);
  assert(duplicate(t).tag.length == 0);
  assert((shift(1,0)*t).tag.length == 0);
  t.addtag("custom");
  tessera c=copy(t);
  assert(c.tag.length == 1 && c.tag[0] == "custom");
  c.addtag("copy-only");
  assert(t.tag.length == 1);
  write("Deleted tags remain deleted in copies, duplicates, and transforms.");
}

// Rule tags survive mosaic construction and copying and reach future tiles.
if(test("rule-tags")) {
  tile a=unitsquare;
  substitution s=substitution(a,"group");
  s.addtile();
  s.tesserae[0].deletetag();
  mosaic m=mosaic(1,s);
  assert(m.rules[0].tag.length == 1);
  assert(m.rules[0].tag[0] == "group");
  assert(m.tesserae[0].tag.length == 0);
  mosaic c=copy(m);
  c.rules[0].addtile();
  assert(c.rules[0].tesserae[1].tag[0] == "group");
  assert(c.rules[0].tesserae[0].tag.length == 0);
  assert(m.rules[0].tesserae.length == 1);
  write("Rule tags survive copying and reach new tiles without restoring deleted tags.");
}

// Zero substitutions preserve state; negative counts must be rejected.
if(test("zero-count") || test("negative-init") || test("negative-substitute")) {
  tile a=unitsquare;
  substitution s=substitution(a);
  s.addtile();
  s.addtile(shift(1,0));
  mosaic m=mosaic(1,s);
  m.substitute(0);
  assert(m.n == 1 && m.tesserae.length == 2 && m.tilecount.length == 2);
  if(find(settings.user,"negative-init") == 0) {
    mosaic invalid=mosaic(-1,s);
    abort("Expected rejection of a negative initial substitution count.");
  }
  if(find(settings.user,"negative-substitute") == 0) {
    m.substitute(-1);
    abort("Expected rejection of a negative substitution count.");
  }
  write("Zero substitutions leave the iteration count, tiles, and history unchanged.");
}
