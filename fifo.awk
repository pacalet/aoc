@namespace "fifo"

################################################################################
# Implement FIFO with array indexed from 1 (left, first input, first output) to
# N (right, last input, last output). Index 0 stores the number N of elements.
################################################################################

# Shift entries `pos` ... N to the right, insert value `val` at position `pos`.
# `pos` is first saturated in the -N ... N range. Negative or null positions are
# relative to N+1:
# - insert(fifo, val, 0) adds val at position N+1 (same as push)
# - insert(fifo, val, -1) is the same as insert(fifo, val, N)
# - ...
function insert(fifo, val, pos,    i) {
	insert(fifo, val, pos)
}

# Get number of elements
function size(fifo) {
	return fifo[0]
}

# Push to top
function push(fifo, val) {
	fifo[++fifo[0]]=val
}

# Pop from top
function pop(fifo,    val) {
	if(fifo[0]<1) {
		print "ERROR: pop from empty FIFO"
		exit(1)
	}
	val=fifo[1]
	for(i=1; i<fifo[0]; i++) {
		fifo[i]=fifo[i+1]
	}
	delete fifo[fifo[0]--]
	return val
}

@namespace "awk"

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab textwidth=0:
