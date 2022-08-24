import mosaic;

pair pointLine(pair a, pair b){
	real La=length(a);
	real Lb=length(b);
	if(La > Lb)
		return a-b;
 	else
		return b-a;
}

bool sameLine(pair a, pair b, pair c, real tol=1e-15){
	pair ab=pointLine(a,b);
	pair bc=pointLine(b,c);
	real crossprod=cross(ab,bc);
	if(crossprod < tol)
		return true;
	else
		return false;
}

int[] threeNodes(path p){
	int[] nodes={0,1};
	int i=2;
	pair p1;
	pair p2;
	pair p3;
	while(i < size(p)){
		p1=point(p,0);
		p2=point(p,1);
		p3=point(p,i);
		//write(sameLine(p1,p2,p3));
		if(!sameLine(p1,p2,p3)){
			nodes.push(i);
			i=size(p);
		} else
			i+=1;
	}
	return nodes;
}
//path B=(0,0)--(0,1)--(1/2,1)--(1,1)--(1,0)--cycle;

//write(threeNodes(B));