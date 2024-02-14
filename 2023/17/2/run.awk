# Dijkstra path finder algorithm
#
# The problem is represented as a graph with "[x,y,d,n]" vertexes where "[x,y]"
# is a grid position (1<="x"<="width" and 1<="y"<="height"), "d" is the
# direction of last step ("north", "east", "south" or "west"), and "n" is the
# number of consecutive last moves in the same direction.
#
# "visited[v]" is a marker that "[x,y,d,n]" has already been visited and shall
# not be visited again.
#
# "losses[loss][v]" is defined if vertex v (visited or not) has loss "loss".

# Starting from vertex "v" with loss "loss", examine adjacent vertex in
# direction "dir". If the step is valid (no return, at least nmin steps in same
# direction before change, no more then nmax steps in same direction, final
# position on grid), and the adjacent vertex has not already been visited,
# update "losses" and "visited". Plus, if the new position is "[height,width]",
# print the final loss and stop.
function go(v, dir, loss,    va, x, y, d, n1, n2) {
	debug::debug("go(" v ", " sdir[dir] ") with loss " loss)
	split(v, va, SUBSEP); x=va[1]; y=va[2]; d=va[3]; n1=va[4]
	# New coordinates, number of steps in same direction and loss
	x+=off["x",dir]; y+=off["y",dir]; n2=(dir==d)?n1+1:1; loss+=grid[x,y]
	debug::debug(" try " x ", " y " (n=" n2 ", loss=" loss ")")
	# If valid step and adjacent vertex not visited
	if((x>=1) && (x<=width) && (y>=1) && (y<=height) && (dir!=op[d]) && ((dir==d) || (n1>=nmin)) && (n2<=nmax) && (!((x,y,dir,n2) in visited))) {
		debug::debug(": OK\n")
		losses[loss][x,y,dir,n2]; visited[x,y,dir,n2]
		if((x==width) && (y==height)) { print loss; exit }
	} else { debug::debug(": KO\n") }
}

BEGIN {
	# Minimum and maximum consecutive steps in same direction
	nmin=4; nmax=10
	# Directions
	north=1; east=2; south=3; west=4
	# Direction names
	sdir[north]="north"; sdir[east]="east"; sdir[south]="south"; sdir[west]="west";
	# Opposite directions
	op[north]=south; op[east]=west; op[south]=north; op[west]=east;
	# x/y offsets
	off["x",north]=0; off["x",east]=1; off["x",south]=0; off["x",west]=-1
	off["y",north]=-1; off["y",east]=0; off["y",south]=1; off["y",west]=0
	# Loop over arrays in numeric ascending order of indexes
	PROCINFO["sorted_in"]="@ind_num_asc"
	# Single-digit fields
	FPAT=@/[0-9]/
}

# Construct grid
{
	for(i=1; i<=NF; i++) grid[i,NR]=$i
}

END {
	# Grid width/height
	width=NF; height=NR
	debug::debug("width " width ", height " height "\n")
	# Create initial vertexes
	visited[1,1,east,0]; visited[1,1,south,0]; for(v in visited) losses[0][v]
	while(1) {
		debug::debug("Iteration " ++n "\n")
		# Iterate only once on the lowest loss
		for(loss in losses) {
			# Iterate over all vertexes with this loss
			for(v in losses[loss]) {
				debug::debug("vertex " v "\n")
				for(dir=1; dir<=4; dir++) { go(v, dir, loss) }
			}
			# Delete "losses[loss]"
			delete losses[loss]
			# Iterate only once on the lowest loss
			break
		}
	}
}
