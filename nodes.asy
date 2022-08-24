import mosaic;

pair pointLine(pair a, pair b){
	real La=length(a);
	real Lb=length(b);
	if(La > Lb)
		return a-b;
 	else
		return b-a;
}

bool sameLine(pair a, pair b, real tol=1e-15){
	real crossprod=cross(a,b);
	if(abs(crossprod) < tol)
		return true;
	else
		return false;
}

int[] threeNodes(path p){
	int[] nodes={0,1};
	pair p1=dir(p,0,1);
	pair p2;
	path P;
	int i=2;
	while(i < size(p)){
		p2=dir(point(p,1)--point(p,i),0,1);
		if(!sameLine(p1,p2)){
			nodes.push(i);
			i=size(p);
		} else
			i+=1;
	}
	return nodes;
}

pair[] point(path p, int[] t) {
	int L=t.length;
	pair[] P=new pair[L];
	for(int i=0; i < L; ++i)
		P[i]=point(p,t[i]);
	return P;
}

// Test
path B=(0,0)--(0,1/2)--(0,1/4)--(0,1)--(1/2,1)--(1,1)--(1,0)--cycle;
write(point(B,threeNodes(B)));