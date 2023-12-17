function hash(s,    n, a, h, i) {
	n=patsplit(s, a, /./)
	h=hstart
	for(i=1; i<=n; i++) {
		h+=ascii[a[i]]
		h=(hmul*h)%hmod
		debug::debug(s ": a[" i "] = " a[i] " (ASCII " ascii[a[i]] ") -> " h "\n")
	}
	return h
}

BEGIN {
	FS=","
	hstart=0
	hmul=17
	hmod=256
	for(i=0; i<256; i++) {
		ascii[sprintf("%c", i)]=i
	}
}

{
	sum=0
	for(i=1; i<=NF; i++) {
		sum+=hash($i)
	}
	print sum
}
