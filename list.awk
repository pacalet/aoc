@namespace "list"

################################################################################
# Implement LIST with array indexed from 1 (left) to N (right). Index 0 stores
# the number N of elements.
################################################################################

# Initialize an empty list
function init(list) {
	list[0]=0
	delete list
}

# Shift elements `pos` ... N to the right, insert value `val` at position `pos`.
# `pos` is first saturated in the -N ... N range. Negative or null positions are
# relative to N+1:
# - insert(list, val, 0) adds val at position N+1
# - insert(list, val, -1) is the same as insert(list, val, N)
# - ...
function insert(list, val, pos,    i) {
	if(pos<-list[0]) {
		pos=-list[0]
	} else if(pos>list[0]) {
		pos=list[0]
	}
	if(pos<=0) {
		pos+=list[0]+1
	}
	for(i=list[0]; i>=pos; i--) {
		list[i+1]=list[i]
	}
	list[pos]=val
	list[0]+=1
}

# Return element `pos` and shift elements `pos+1` ... N to the left. `pos` is
# first saturated in the -N ... N range. Negative or null positions are
# relative to N:
# - retrieve(list, 0) returns element N
# - retrieve(list, -1) is the same as retrieve(list, N-1)
# - ...
function retrieve(list, pos,    i, val) {
	if(pos<-list[0]) {
		pos=-list[0]
	} else if(pos>list[0]) {
		pos=list[0]
	}
	if(pos<0) {
		pos+=list[0]
	} else if(pos==0) {
		pos=list[0]
	}
	if(list[0]==0) {
		print "ERROR: cannot retrieve from empty list"
		exit(1)
	}
	val=list[pos]
	for(i=pos; i<list[0]; i++) {
		list[i]=list[i+1]
	}
	delete list[list[0]]
	list[0]-=1
	return val
}

# Get number of elements
function size(list) {
	return list[0]
}

@namespace "awk"

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab textwidth=0:
