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
			if(sym[y][x]~/^[0-9]+$/) {
				debug::debug("sym[" y "," x "] (" xmin[y][x] "," xmax[y][x] "): " sym[y][x] "\n")
				left=xmax[y][x-1] && xmax[y][x-1]==xmin[y][x]-1
				right=xmin[y][x+1] && xmin[y][x+1]==xmax[y][x]+1
				top=0
				if(y>1) {
					debug::debug(y ">1 => top scan\n")
					for(j in xmin[y-1]) {
						top=top || (sym[y-1][j]~/^[^0-9.]$/ && xmin[y-1][j]>=(xmin[y][x]-1) && xmin[y-1][j]<=(xmax[y][x]+1))
					}
				}
				bottom=0
				if(y<ymax) {
					debug::debug(y "<" ymax " => bottom scan\n")
					for(j in xmin[y+1]) {
						debug::debug("[" y "," x "] (" xmin[y][x] "," xmax[y][x] "): " sym[y+1][j] " " xmin[y+1][j] "\n")
						bottom=bottom || (sym[y+1][j]~/^[^0-9.]$/ && xmin[y+1][j]>=(xmin[y][x]-1) && xmin[y+1][j]<=(xmax[y][x]+1))
					}
				}
			}
			if(left || right || top || bottom) {
#				debug::debug(sym[y][x] ": " left " " right " " top " " bottom "\n")
				sum+=sym[y][x]+0
			}
		}
	}
	print sum
}
