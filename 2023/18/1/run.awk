BEGIN {
	x=1
	maxx=x
	minx=x
	y=1
	maxy=y
	miny=y
	grid[y][x]="#"
	color[y][x]=""
	movex["R"]=1
	movey["R"]=0
	movex["L"]=-1
	movey["L"]=0
	movex["D"]=0
	movey["D"]=1
	movex["U"]=0
	movey["U"]=-1
	num=0
}

{
	num+=$2
	for(i=1; i<=$2; i++) {
		x+=movex[$1]
		y+=movey[$1]
		grid[y][x]="#"
		color[y][x]=$3
		maxx=(x>maxx)?x:maxx
		minx=(x<minx)?x:minx
		maxy=(y>maxy)?y:maxy
		miny=(y<miny)?y:miny
	}
}

END {
	for(y=miny; y<=maxy; y++) {
		for(x=minx; x<=maxx; x++) {
			if(grid[y][x]!="#") {
				grid[y][x]="."
				color[y][x]=""
			}
		}
	}
	debug::debug(maxy-miny+1 " x " maxx - minx + 1 " ([" miny " .. " maxy "] x [" minx " .. " maxx "])\n")
	if(dbg) {
		utils::print_screen(grid)
	}
	utils::copy_array(grid, newgrid)
	# 5 configurations:
	# 1:
	#    #
	# -->#-->
	#    #
	# 2:
	# -->###-->
	#    # #
	# 3:
	#    # #
	# -->###-->
	# 4:
	#    #
	# -->###-->
	#      #
	# 5:
	#      #
	# -->###-->
	#    #
	for(y=miny+1; y<maxy; y++) {
		state=0
		prev="."
		up="."
		down="."
		for(x=minX; x<=maxx; x++) {
			if((prev==".") && (grid[y][x]=="#")) {
				up=grid[y-1][x]
				down=grid[y+1][x]
			} else if((prev=="#") && (grid[y][x]==".") && ((up==down) || (up!=grid[y-1][x-1]))) {
				state=1-state
			}
			if((grid[y][x]==".") && state) {
				newgrid[y][x]="#"
				num+=1
			}
			prev=grid[y][x]
		}
	}
	if(dbg) {
		utils::print_screen(newgrid)
	}
	print num
}
