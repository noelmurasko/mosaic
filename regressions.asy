// Run with: asy -noV regressions.asy
import mosaic;

// Copying must preserve single-tile substitutions and accept empty mosaics.
{
  tile a=unitsquare;
  tile b=(0,0)--(2,0)--(0,2)--cycle;
  substitution sa=substitution(a);
  sa.addtile(shift(3,0),b,fillpen=red);
  substitution sb=substitution(b);
  sb.addtile();
  sb.addtile(shift(1,0));
  mosaic m=mosaic(1,sa,sb);
  mosaic c=copy(m);
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
}

// Copies retain independent decorations and sharing without aliasing the source.
{
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
  c.substitute(1);
  assert(c.tesserae.length == 9);
}

// Callback tile changes take effect, including original input tile references.
{
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
}

// Radial shading follows similarity transforms, including reflections.
{
  tile shaded=tile(unitsquare,red,(0,0),1,blue,(1,1),2);
  tile enlarged=shift(2,4)*rotate(30)*scale(-3)*shaded;
  assert(abs(enlarged.radialra-3) < sqrtEpsilon);
  assert(abs(enlarged.radialrb-6) < sqrtEpsilon);
  tile reflected=reflect((0,0),(0,1))*enlarged;
  assert(abs(reflected.radialrb-6) < sqrtEpsilon);
  tile unchanged=shift(5,8)*shaded;
  assert(unchanged.radialra == 1 && unchanged.radialrb == 2);
  if(find(settings.user,"radial-affine") == 0) {
    // Must fail: circular radii cannot represent an elliptical gradient.
    tile unsupported=xscale(2)*shaded;
    abort("Expected rejection of nonuniform radial shading.");
  }
}
