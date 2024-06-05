settings.outformat="pdf";
size(300);
import mosaic;

inflation=2;

// prototile
tile l1=tile((0,0)--(1,1));
tile l2=tile((0,0)--(1,1));

pen l1pen=red+100;
pen l2pen=green+100;

substitution l1Rule=substitution(l1); // l1 substitution rule
l1Rule.addtile(l1,drawpen=l1pen);
l1Rule.addtile(shift(1,1),l2,drawpen=l2pen);

substitution l2Rule=substitution(l2); // l2 substitution rule
l2Rule.addtile(l1,drawpen=l1pen);
l2Rule.addtile(shift(1,1),l1,drawpen=l1pen);

int n=4;
mosaic M=mosaic(l1,n,l1Rule,l2Rule);
draw(M);
