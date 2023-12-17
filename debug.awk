@namespace "debug"

# Print only if dbg set
function debug(str) {
	if(awk::dbg) printf("%s", str)
}

@namespace "awk"

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab textwidth=0:
