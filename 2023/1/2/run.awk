@include "rplib"

BEGIN {
	split("one,two,three,four,five,six,seven,eight,nine", atmp, /,/)
	utils::keyvalswap(atmp, digit)
	sum=0
}

{
	while(1) {
		min=length
		val=0
		for(d in digit) {
			tmp=index($0,d)
			if(tmp>0 && tmp<min) {
				min=tmp
				val=d
			}
		}
		if(val) {
			debug::debug(val " at " min "\n")
			$0=substr($0,1,min-1) digit[val] substr($0,min+length(val)-1)
		} else {
			break
		}
	}
	gsub(/[^0-9]/,"")
	tmp=(substr($0,1,1) substr($0,length))+0
	debug::debug(tmp "\n")
	sum+=tmp
}

END {
	print sum
}
