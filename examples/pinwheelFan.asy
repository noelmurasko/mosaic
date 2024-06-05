settings.outformat="pdf";
size(300);

import mosaic;

tile triangle=(0,0)--(2,0)--(2,1)--cycle;

// inflation factor
inflation=sqrt(5);

transform T=reflect((0,0),(0,1))*rotate(90+aTan(2));

// pinwheel substitution tiles
substitution pinSub=substitution(triangle);

// define the substitution rule
real varphi=aTan(1/2);
transform T=reflect((0,0),(0,1))*rotate(180-varphi);
pinSub.addtile(T, paleyellow);
pinSub.addtile(T*shift(2,1), paleyellow);
pinSub.addtile(T*reflect((2,0),(2,1)), lightred);
pinSub.addtile(T*reflect((0,1),(1,1))*shift(2,1), paleblue);
pinSub.addtile(T*shift(4,2)*rotate(-90), heavyred);

// number of iterations
int n=4;
pair sepX=(inflation^(n+1),0);
pair sepY=(0,1);

for(int k=0; k<n+1; ++k){
	
	mosaic M=mosaic(k,pinSub);
	transform RotVarphi=rotate(-varphi)^(k);
	transform Rot90=rotate(-90);

	if(k==0){

		path starttile=(0,0)--(2,0)--(2,1)--cycle;
		starttile=shift(sepX)*Rot90*starttile;
		filldraw(starttile,drawpen=black+0.1,fillpen=paleblue);

	}else{

	M=shift(sepX)*RotVarphi*Rot90*M;
	filldraw(M,p=black+0.1,scalelinewidth=false);
	
	}


}

for(int k=0; k<n+1; ++k){
	
	mosaic superM=mosaic(0,pinSub);
	superM.set(invisible);
	superM=scale(inflation^k)*superM;
	transform RotVarphi=rotate(-varphi)^(k);
	transform Rot90=rotate(-90);
	superM=shift(sepX)*RotVarphi*Rot90*superM;

	// draw the patch
	filldraw(superM,p=black+0.66,scalelinewidth=false);
}



