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
