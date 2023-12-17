@include "rplib"

{
	x=1
	for(i=1; i<=length; i++) {
		left=substr($0,i-1,1)
		char=substr($0,i,1)
		right=substr($0,i+1,1)
		if((i==1 || left!~/[0-9]/) && char~/[0-9]/) {
			xmin[NR][x]=i
		}
		if((i==length || right!~/[0-9]/) && char~/[0-9]/) {
			xmax[NR][x]=i
			sym[NR][x]=substr($0,xmin[NR][x],xmax[NR][x]-xmin[NR][x]+1)
			x+=1
		}
		if(char~/[^0-9.]/) {
			xmin[NR][x]=i
			xmax[NR][x]=i
			sym[NR][x]=char
			x+=1
		}
	}
	ymax=NR+0
}

END {
	for(y in xmin) {
		y+=0
		for(x in xmin[y]) {
			x+=0
			if(sym[y][x]=="*") {
				debug::debug("sym[" y "," x "] (" xmin[y][x] "," xmax[y][x] "): " sym[y][x] "\n")
				n=0
				r=1
				if(xmax[y][x-1] && xmax[y][x-1]==xmin[y][x]-1 && sym[y][x-1]~/^[0-9]+$/) {
					debug::debug("left: " sym[y][x-1] " (" y "," x-1 ")\n")
					n+=1
					r*=(sym[y][x-1]+0)
				}
				if(xmin[y][x+1] && xmin[y][x+1]==xmax[y][x]+1 && sym[y][x+1]~/^[0-9]+$/) {
					debug::debug("right: " sym[y][x+1] " (" y "," x+1 ")\n")
					n+=1
					r*=(sym[y][x+1]+0)
				}
				if(y>1) {
					for(j in xmin[y-1]) {
						if(sym[y-1][j]~/^[0-9]+$/ && xmin[y][x]>=(xmin[y-1][j]-1) && xmin[y][x]<=(xmax[y-1][j]+1)) {
							debug::debug("top: " sym[y-1][j] " (" y-1 "," j ")\n")
							n+=1
							r*=(sym[y-1][j]+0)
						}
					}
				}
				if(y<ymax) {
					for(j in xmin[y+1]) {
						if(sym[y+1][j]~/^[0-9]+$/ && xmin[y][x]>=(xmin[y+1][j]-1) && xmin[y][x]<=(xmax[y+1][j]+1)) {
							debug::debug("bottom: " sym[y+1][j] " (" y+1 "," j ")\n")
							n+=1
							r*=(sym[y+1][j]+0)
						}
					}
				}
				if(n==2) {
					debug::debug("sum+=" r "\n")
					sum+=r
				}
			}
		}
	}
	print sum
}
