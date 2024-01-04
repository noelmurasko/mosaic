settings.outformat="pdf";
size(300);

import mosaic;

path square=(0,0)--(0,1)--(1,1)--(1,0)--cycle;

mtile S=mtile(purple);
mtile T=mtile(shift(1,0),pink);

mrule sRule1=mrule(S,T);
int n=3;
mosaic M=mosaic(square,n,sRule1);

mrule sRule2=mrule(S,T);
//mosaic M=mosaic(square,n,sRule1);
mosaic M=mosaic(square,n,sRule2);

draw(M);

// the issue:
// nothing is drawn if:
// line 13 is uncommented and line 16 is commented

// note:
// the image IS drawn if:
// line 13 is commented and line 16 is uncommented

// other notes:
// -  mrule two mosaics is fine
// - two mrules and one mosaic is fine
// - mrules and two mosaics IS NOT fine IF the first mosaic comes before the second rule
// - two mrules and two mosaics IS fine IF both mosaics come after the mrule definitions
