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
