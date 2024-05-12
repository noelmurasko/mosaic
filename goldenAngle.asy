settings.outformat="pdf";
size(300);

import mosaic;

// angles (radians)
real w=(sqrt(5)-1)/2;
real alph=pi*w^3;  // golden angle
real beta=(pi-alph)/2;  

// angles (degrees)
real Alph=alph*180/pi;
real Beta=beta*180/pi;

// sides
real a = 1;
real b = sin(alph)/sin(beta);
real c = 2b^2*cos(beta);

// line colour and width
pen linePen=black+0.005;  

// colours
//pen scaP1=paleblue;
//pen scaP2=lightblue;
//pen isoPen=paleyellow;
pen isoPen=invisible;

// vertices in the substitution (counterclockwise)
pair q1=(0,0);
pair q2=(c,0);
pair q3=(b+c,0);
pair q4=(c+b*cos(alph),b*sin(alph));
pair q5=((b^2+b^3/c)*cos(beta),(b^2+b^3/c)*sin(beta));
pair q6=(b^2*cos(beta),b^2*sin(beta));

// tiles in the isosceles substitution
tile U1=q1--q2--q6--cycle;
tile U2=q2--q3--q4--cycle;
tile U3=q4--q5--q6--cycle;
tile U4=q2--q4--q6--cycle;

// prototile
tile iso=tile((q1--q2--q6--cycle),drawpen=linePen);
substitution isoSub=substitution(iso);

// subdivide rule
real isoDefl=c/(b+c);
isoSub.addtile(scale(isoDefl),isoPen);
isoSub.addtile(shift(q6*isoDefl)*scale(isoDefl*b/c),isoPen);
isoSub.addtile(shift(q3*isoDefl)*rotate(180-Beta)*scale(isoDefl/b),isoPen);
isoSub.addtile(shift(q6*isoDefl)*rotate(-Beta)*scale(isoDefl*b^2/c),isoPen);

// draw the starting tile 
int n=0;
mosaic m0=mosaic(iso,n,isoSub);
draw(q1--q2--q6--cycle,linePen);

// image settings
pair sepX=(isoDefl/2,0);    
pair sepY=(0,isoDefl/2);

// draw the first iteration
n=1;
pair t=(c,0)+sepX;
real rescale=(b+c)/b;
mosaic m1=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m1);

n=2;
t=t+(c*rescale,0)+sepX;
rescale=(1+b^2)/b;
mosaic m2=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m2);

n=3;
t=t+(c*rescale,0)+sepX;
rescale=(b+c)^2/b^2;
mosaic m3=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m3);

n=4;
t=t+(c*rescale,0)+sepX;
rescale=(1+b^2)/b^2;
mosaic m4=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m4);

n=5;
t=t+(c*rescale,0)+sepX;
rescale=(b+c)*(1+b^2)/b^2;
mosaic m5=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m5);

n=6;
rescale=(1+b^2)*(b+c)^2/b^3;
t=(0,-b^2*sin(beta)*rescale)-sepY;
rescale=(b+c)^3/b^3;
mosaic m6=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m6);

n=7;
t=t+(c*rescale,0)+sepX;
rescale=(1+b^2)^2/b^2;
mosaic m7=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m7);

n=8;
t=t+(c*rescale,0)+sepX;
rescale=(1+b^2)*(b+c)^2/b^3;
mosaic m8=mosaic(iso,n,isoSub);
draw(shift(t)*scale(rescale)*m8);


write("alph=",alph);
write("beta=",beta);



