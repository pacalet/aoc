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

function process(step,    a, h, i, done) {
	match(step, /(.*)([-=])(.*)/, a)
	debug::debug("processing step " step "\n")
	h=hash(a[1])
	if(a[2]=="-") {
		debug::debug("remove lens " a[1] " from box " h "\n")
		for(i=1; i<=list::size(box[h]["label"]); i++) {
			if(box[h]["label"][i]==a[1]) {
				debug::debug("remove lens " a[1] " at position " i " in box " h ", with focal " box[h]["focal"][i] "\n")
				list::retrieve(box[h]["label"], i)
				list::retrieve(box[h]["focal"], i)
				break
			}
		}
	} else {
		done=0
		for(i=1; i<=list::size(box[h]["label"]); i++) {
			if(box[h]["label"][i]==a[1]) {
				debug::debug("change focal of lens " a[1] " at position " i " in box " h ", from focal " box[h]["focal"][i] " to focal " a[3] "\n")
				box[h]["focal"][i]=a[3]
				done=1
				break
			}
		}
		if(!done) {
			debug::debug("insert lens " a[1] " at end of box " h ", with focal " a[3] "\n")
			list::insert(box[h]["label"], a[1], 0)
			list::insert(box[h]["focal"], a[3], 0)
		}
	}
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
	for(h=0; h<256; h++) {
		list::init(box[h]["label"])
		list::init(box[h]["focal"])
	}
	for(i=1; i<=NF; i++) {
		process($i)
		if(dbg) {
			debug::debug("After \"" $i "\":\n")
			for(h=0; h<256; h++) {
				if(list::size(box[h]["label"])) {
					debug::debug("Box " h ": ")
					for(j=1; j<=list::size(box[h]["label"]); j++) {
						debug::debug("[" box[h]["label"][j] " " box[h]["focal"][j] "]" )
					}
					debug::debug("\n")
				}
			}
			debug::debug("\n")
		}
	}
	sum=0
	for(h=0; h<256; h++) {
		for(i=1; i<=list::size(box[h]["label"]); i++) {
			sum+=(h+1)*i*box[h]["focal"][i]
		}
	}
	print sum
}
