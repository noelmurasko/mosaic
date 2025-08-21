settings.outformat="pdf";
size(300);

import mosaic;

tile W1=tile(polygon(8));
tile W2=copy(W1);
tile W3=copy(W1);

real s3=sqrt(3);
real s33=sqrt(33);
real cp19=(19+3*s33)^(1/3);
real cm19=(19-3*s33)^(1/3);
pair alpha=((1/3)-(1/6)*(cm19+cp19),(-s3/6)*(cm19-cp19));
transform Alpha=scale(abs(alpha))*rotate(degrees(alpha));
transform AlphaShift=shift(alpha)*Alpha;

substitution W1rule=substitution(W1);
W1rule.addtile(Alpha,W1);
W1rule.addtile(AlphaShift,W2);

substitution W2rule=substitution(W2);
W2rule.addtile(Alpha,W1);
W2rule.addtile(AlphaShift,W3);

substitution W3rule=substitution(W3);
W3rule.addtile(Alpha,W1);

int n=14;
mosaic M1=mosaic(n,W1rule,W2rule,W3rule);
mosaic M2=mosaic(n,W2rule,W1rule,W3rule);
mosaic M3=mosaic(n,W3rule,W2rule,W1rule);

transform hshift=shift(2);
filldraw(Alpha*M1, blue, blue);
filldraw(AlphaShift*M2, mediumred, mediumred);
filldraw(hshift*Alpha*M1, blue, blue);
filldraw(hshift*AlphaShift*M3, lightolive, lightolive);
filldraw(hshift^2*Alpha*M1, blue, blue);

