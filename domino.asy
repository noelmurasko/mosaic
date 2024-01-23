settings.outformat="pdf";
size(300);

import mosaic;
inflation=2;

tile dom=tile(box((0,0),(1,2)),brown);
tile ino=tile(box((0,0),(2,1)),paleyellow);


substitution domRule=substitution(dom); // dom substitution rule

domRule.addtile(ino);
domRule.addtile(shift(0,1),dom);
domRule.addtile(shift(1,1),dom);
domRule.addtile(shift(0,3),ino);

substitution inoRule=substitution(ino); // ino substitution rule

inoRule.addtile(dom);
inoRule.addtile(shift(1,0),ino);
inoRule.addtile(shift(1,1),ino);
inoRule.addtile(shift(3,0),dom);

int n=6;
mosaic M=mosaic(dom,n,domRule,inoRule);

draw(M);
