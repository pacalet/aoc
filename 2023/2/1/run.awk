@include "rplib"

BEGIN {
	num["red"]=12
	num["green"]=13
	num["blue"]=14
}

{
	match($0,/^Game ([0-9]*):\s*(.*)/,a)
	g=a[1]
	s=a[2]
	debug::debug(g ":" s "\n")
	n1=split(s,a1,/;\s*/)
	for(i=1;i<=n1;i++) {
		n2=split(a1[i],a2,/,\s*/)
		for(j=1;j<=n2;j++) {
			match(a2[j],/^([0-9]*)\s*(\S*)/,a3)
			debug::debug("  " a3[1] " " a3[2] "\n")
			if(a3[1]>num[a3[2]]) {
				impossible[g]=1
			}
		}
	}
}

END {
	sum=0
	for(i=1;i<=g;i++) {
		if(impossible[i]) {
			debug::debug("** " i "\n")
			continue
		}
		sum+=i
	}
	print sum
}
