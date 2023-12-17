BEGIN {
	# directions
	left=8
	right=4
	top=2
	bottom=1
	sdir[left]="left"
	sdir[right]="right"
	sdir[top]="top"
	sdir[bottom]="bottom"
	inv[left]=right
	inv[right]=left
	inv[top]=bottom
	inv[bottom]=top
	# nxt[FROM][CELL][i]: i-th next direction for beam entering cell CELL
	# from direction FROM
	nxt[left]["."][1]=right
	nxt[left]["-"][1]=right
	nxt[left]["/"][1]=top
	nxt[left]["\\"][1]=bottom
	nxt[left]["|"][1]=top
	nxt[left]["|"][2]=bottom
	nxt[right]["."][1]=left
	nxt[right]["-"][1]=left
	nxt[right]["/"][1]=bottom
	nxt[right]["\\"][1]=top
	nxt[right]["|"][1]=top
	nxt[right]["|"][2]=bottom
	nxt[top]["."][1]=bottom
	nxt[top]["-"][1]=left
	nxt[top]["-"][2]=right
	nxt[top]["/"][1]=left
	nxt[top]["\\"][1]=right
	nxt[top]["|"][1]=bottom
	nxt[bottom]["."][1]=top
	nxt[bottom]["-"][1]=left
	nxt[bottom]["-"][2]=right
	nxt[bottom]["/"][1]=right
	nxt[bottom]["\\"][1]=left
	nxt[bottom]["|"][1]=top
	# displacements
	to[left]["x"]=-1
	to[right]["x"]=1
	to[top]["x"]=0
	to[bottom]["x"]=0
	to[left]["y"]=0
	to[right]["y"]=0
	to[top]["y"]=-1
	to[bottom]["y"]=1
}

function beam(from, x, y,    s, a, g, i, n) {
	debug::debug("beam(" sdir[from] ", " x ", " y ")\n")
	s=0
	if((x<1) || (x>w) || (y<1) || (y>h)) {
		debug::debug("  out\n")
		return s
	}
	a=arr[y][x]
	debug::debug("  arr[y][x]: " a "\n")
	if(and(a, from)) {
		debug::debug("  already done\n")
		return s
	}
	if(!a) {
		s=1
	}
	arr[y][x]=or(a, from)
	g=grid[y][x]
	for(i in nxt[from][g]) {
		n=nxt[from][g][i]
		s+=beam(inv[n], x+to[n]["x"], y+to[n]["y"])
	}
	return s
}

{
	patsplit($0, grid[NR], /./)
}

END {
	w=length
	h=NR
	if(dbg) {
		utils::print_screen(grid)
	}
	max=0
	for(i=1; i<=w; i++) {
		delete arr
		v=beam(top, i, 1)
		max=(v>max)?v:max
	}
	for(i=1; i<=w; i++) {
		delete arr
		v=beam(bottom, i, h)
		max=(v>max)?v:max
	}
	for(i=1; i<=h; i++) {
		delete arr
		v=beam(left, 1, i)
		max=(v>max)?v:max
	}
	for(i=1; i<=h; i++) {
		delete arr
		v=beam(right, w, i)
		max=(v>max)?v:max
	}
	print max
}
