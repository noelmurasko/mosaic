settings.outformat="pdf";
size(300);

import mosaic;

// inflation factor
inflation=2;

// prototile
tile bent=(0,1/3)--(2/3,1/3)--(2/3,0);
tile straight=(0,1/3)--(1,1/3);

// substitution rule
substitution bentRule=substitution(bent);
bentRule.addtile(shift(0,1)*rotate(-90));
bentRule.addtile(shift(0,1)*reflect((1/2,0),(1/2,1)));
bentRule.addtile(shift(1,1));
bentRule.addtile(shift(2,0)*rotate(90),straight);
//draw(bentRule);

substitution straightRule=substitution(straight);
straightRule.addtile(shift(0,1)*rotate(-90),bent);
straightRule.addtile(shift(0,1)*reflect((1/2,0),(1/2,1)),bent);
straightRule.addtile(shift(1,1),bent);
straightRule.addtile(reflect((1,0),(1,1))*shift(0,1)*rotate(-90),bent);

// draw patch
int n=4;
mosaic M=mosaic(n,bentRule,straightRule);
filldraw(M,black+5);
