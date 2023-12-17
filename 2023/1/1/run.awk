@include "rplib"

BEGIN {
	FPAT="."
	v=0
}

{
	gsub(/[^0-9]/,"")
	tmp=(substr($0,1,1) substr($0,length($0)))+0
	v+=tmp
}

END {
	print v
}
