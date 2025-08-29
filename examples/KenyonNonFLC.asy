settings.outformat="pdf";
size(300);

import mosaic;

currentinflation=3;

// prototile
tile s1=tile(box((0,0),(1,1)),paleyellow);
tile s2=tile(box((0,0),(1,1)),deepmagenta);

real ishift=pi/8; // irrational shift

substitution s1Rule=substitution(s1); // s1 substitution rule

s1Rule.addtile(shift(0,1),s2);
s1Rule.addtile(s1);
s1Rule.addtile(shift(0,-1),s2);

s1Rule.addtile(shift(1,1),s1);
s1Rule.addtile(shift(1,0),s2);
s1Rule.addtile(shift(1,-1),s1);

s1Rule.addtile(shift(2,ishift+1),s2);
s1Rule.addtile(shift(2,ishift),s1);
s1Rule.addtile(shift(2,ishift-1),s2);

substitution s2Rule=substitution(s2); // s1 substitution rule

s2Rule.addtile(shift(0,1),s1);
s2Rule.addtile(s2);
s2Rule.addtile(shift(0,-1),s1);

s2Rule.addtile(shift(1,1),s2);
s2Rule.addtile(shift(1,0),s1);
s2Rule.addtile(shift(1,-1),s2);

s2Rule.addtile(shift(2,ishift+1),s1);
s2Rule.addtile(shift(2,ishift),s2);
s2Rule.addtile(shift(2,ishift-1),s1);


int n=4;
mosaic M=mosaic(n,s1Rule,s2Rule);

filldraw(M);
