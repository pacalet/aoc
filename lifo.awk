@namespace "lifo"

################################################################################
# Implement LIFO with array indexed from 1 (left, first input, last output) to N
# (right, last input, first output). Index 0 stores the number N of elements.
################################################################################

# Get number of elements
function size(lifo) {
	return lifo[0]
}

# Push to top
function push(lifo, val) {
	if(awk::isarray(val)) {
		utils::copy_array(val, lifo[++lifo[0]])
	} else {
		lifo[++lifo[0]]=val
	}
}

# Pop from top
function pop(lifo,    val) {
	if(lifo[0]<1) {
		print "ERROR: pop from empty LIFO"
		exit(1)
	}
	if(awk::isarray(lifo[lifo[0]])) {
		utils::copy_array(lifo[lifo[0]], val)
		delete lifo[lifo[0]--]
	} else {
		val=lifo[lifo[0]]
		delete lifo[lifo[0]--]
		return val
	}
}

@namespace "awk"

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab textwidth=0:
